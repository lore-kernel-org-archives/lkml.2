Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2APOxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:53:13 -0500
Received: from smtp.nokia.com ([147.243.1.48]:21380 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab2APOxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:53:09 -0500
From: <ext-denis.2.karpov@nokia.com>
To: <shubhrajyoti@ti.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc across
 reset
Thread-Topic: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc
 across reset
Thread-Index: AQHM1EL/mf6ola8WEkW6K3MWR6zOfpYO8jXggAAI/QCAABSGIA==
Date: Mon, 16 Jan 2012 14:53:01 +0000
Message-ID: <5E7C2FE2AE03DF4CA6AC500032BF8F77C176F7@008-AM1MPN1-072.mgdnok.nokia.com>
References: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com>
 <5E7C2FE2AE03DF4CA6AC500032BF8F77C1762A@008-AM1MPN1-072.mgdnok.nokia.com>
 <4F143296.8090802@ti.com>
In-Reply-To: <4F143296.8090802@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.50.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2012 14:53:02.0786 (UTC) FILETIME=[8C020A20:01CCD45E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Shubhrajyoti wrote on 2012-01-16:
> On Monday 16 January 2012 06:41 PM, ext-denis.2.karpov@nokia.com wrote:
>> ext Shubhrajyoti D wrote on 2012-01-16:
>>> The commit 11dd62:[omap_hsmmc: context save/restore support]
>>> 
>>> does a reset and restores AUTOIDLE settings.
>>> This patch saves the register does a reset and restores
>>> the same configuration.
>> ...
>>>  	if (pdata->get_context_loss_count) {
>>> @@ -700,6 +700,7 @@ static int omap_hsmmc_context_restore(struct
>>> omap_hsmmc_host *host)
>>>  		&& time_before(jiffies, timeout)) 		; +	sysc =
>>>  OMAP_HSMMC_READ(host->base, SYSCONFIG); 	/* Do software reset */
>>>  	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET); 	timeout =
>>>  jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
>>> @@ -707,8 +708,7 @@ static int omap_hsmmc_context_restore(struct
>>> omap_hsmmc_host *host)
>>>  		&& time_before(jiffies, timeout))
>>>  		;
>>> -	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
>>> -			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
>>> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, sysc);
>> The meaning of the code is to restore the register context after it was lost
> during transition into low power consumption state. SW reset is needed to bring
> all the registers in a consistent state before reconfiguring some of them.
> Agreed thanks.
>> Saving and restoring the SYSCONFIG register across SW reset is not needed.
>> 
>> Also re-configuring AUTOIDLE feature is not necessary since SYSCONFIG reset
> value has is 1 already, according to TRM. I guess it was done to make things
> more explicit.
> However in addition to autoidle there are other bits in the register
> like the sidle mode , enable wakeup which will get not get overwritten now.
> 
> Do you agree?

No, there's no need to do that - after SW reset the registers have predefined reset values; the reset value is correct in case of SYSCONFIG register for most of omap3|4 boards based, doesn't need any update after SW reset.

If in case of your board the reset value of SYSCONFIG register is not what you want - you still cannot rely on the contents of the SYSCONFIG register once the context was lost, i.e. saving its value before SW reset doesn't help. 
You would need to initialize it to the proper value after the SW reset manually, probably the same value that you used during initialization.

Denis
