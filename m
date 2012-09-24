Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2IXLvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:51:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2IXLvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:51:41 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Toshi Kani <toshi.kani@hp.com>
Subject: RE: [GIT PULL REQUEST] watchdog - v3.6-rc5 Fixes
Thread-Topic: [GIT PULL REQUEST] watchdog - v3.6-rc5 Fixes
Thread-Index: AQHNlwf5E9j+r9WZNEKoNRT28E+Cs5eZZHqA
Date: Mon, 24 Sep 2012 11:51:15 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041DB389@DFLE12.ent.ti.com>
References: <20120920081429.GC16482@spo001.leaseweb.com>
In-Reply-To: <20120920081429.GC16482@spo001.leaseweb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: linux-watchdog-owner@vger.kernel.org [mailto:linux-watchdog-
>> owner@vger.kernel.org] On Behalf Of Wim Van Sebroeck
>> Sent: Thursday, September 20, 2012 4:14 AM
>> To: Linus Torvalds
>> Cc: Andrew Morton; LKML; Linux Watchdog Mailing List; Wei Yongjun; Toshi Kani
>> Subject: [GIT PULL REQUEST] watchdog - v3.6-rc5 Fixes
>> 
>> Hi Linus,
>> 
>> Please pull from 'master' branch of
>> 	git://www.linux-watchdog.org/linux-watchdog.git
>> 
>> It will fix a kdump issue in hpwdt and a possible NULL dereference.
>> 
>> This will update the following files:
>> 
>>  hpwdt.c         |    3 +++
>>  watchdog_core.c |    3 ++-
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>> 
>> with these Changes:
>> 
>> commit b232a70a1735c004f9ee6fdf363def527b9234b6
>> Author: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> Date:   Mon Sep 10 12:41:15 2012 +0800
>> 
>>     watchdog: move the dereference below the NULL test
>> 
>>     The dereference should be moved below the NULL test.
>> 
>>     spatch with a semantic match is used to found this.
>>     (http://coccinelle.lip6.fr/)
>> 
>>     Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>> 
>> commit 308b135e4fcc00c80c07e0e04e7afa8edf78583c
>> Author: Toshi Kani <toshi.kani@hp.com>
>> Date:   Mon Aug 27 12:52:24 2012 -0600
>> 
>>     hpwdt: Fix kdump issue in hpwdt
>> 
>>     kdump can be interrupted by watchdog timer when the timer is left
>>     activated on the crash kernel. Changed the hpwdt driver to disable
>>     watchdog timer at boot-time. This assures that watchdog timer is
>>     disabled until /dev/watchdog is opened, and prevents watchdog timer
>>     to be left running on the crash kernel.
>> 
>>     Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>>     Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
>>     Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
>>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>>     Cc: stable <stable@vger.kernel.org>
>> 
>> For completeness, I added the overal diff below.
>> 
>> Greetings,
>> Wim.
>> 
>> ========================================================
>> ========================
>> diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
>> index 1eff743..ae60406 100644
>> --- a/drivers/watchdog/hpwdt.c
>> +++ b/drivers/watchdog/hpwdt.c
>> @@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
>>  	hpwdt_timer_reg = pci_mem_addr + 0x70;
>>  	hpwdt_timer_con = pci_mem_addr + 0x72;
>> 
>> +	/* Make sure that timer is disabled until /dev/watchdog is opened */
>> +	hpwdt_stop();
>> +
>>  	/* Make sure that we have a valid soft_margin */
>>  	if (hpwdt_change_timer(soft_margin))
>>  		hpwdt_change_timer(DEFAULT_MARGIN);
>> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
>> index 6aa46a9..3796434 100644
>> --- a/drivers/watchdog/watchdog_core.c
>> +++ b/drivers/watchdog/watchdog_core.c
>> @@ -128,11 +128,12 @@ EXPORT_SYMBOL_GPL(watchdog_register_device);
>>  void watchdog_unregister_device(struct watchdog_device *wdd)
>>  {
>>  	int ret;
>> -	int devno = wdd->cdev.dev;
>> +	int devno;
>> 
>>  	if (wdd == NULL)
>>  		return;
>> 
>> +	devno = wdd->cdev.dev;
>>  	ret = watchdog_dev_unregister(wdd);
>>  	if (ret)
>>  		pr_err("error unregistering /dev/watchdog (err=%d)\n", ret);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Wim,

Could you take the watchdog davinci patch as well?  http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg23630.html

I have tried 2 times to send the patch to the linux-watchdog list, but the server is rejecting it for some reason. The second time I tried registering my email id to the list and re-sent, but no success.

Murali
