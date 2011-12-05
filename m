Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1LEHbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:31:23 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:47392
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab1LEHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:31:22 -0500
Message-ID: <4EDC7343.7080309@compulab.co.il>
Date: Mon, 05 Dec 2011 09:31:15 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL: add power off functionality
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>	<4ED205F9.3070908@compulab.co.il>	<20111203123516.5ebb057b@notabene.brown>	<4EDB43DC.2050000@compulab.co.il>	<20111204215859.695b31aa@notabene.brown> <20111205084342.43776420@notabene.brown>
In-Reply-To: <20111205084342.43776420@notabene.brown>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/11 23:43, NeilBrown wrote:
> On Sun, 4 Dec 2011 21:58:59 +1100 NeilBrown <neilb@suse.de> wrote:
> 
>> On Sun, 04 Dec 2011 11:56:44 +0200 Igor Grinberg <grinberg@compulab.co.il>
>> wrote:
>>
>>> Hi Neil,
>>>
>>> On 12/03/11 03:35, NeilBrown wrote:
>>>> On Sun, 27 Nov 2011 11:42:17 +0200 Igor Grinberg <grinberg@compulab.co.il>
>>>> wrote:
>>>>
>>>>> ping!
>>>>
>>>> pong ...
>>>>
>>>>
>>>> Hi,
>>>>  I've been trying this patch out on my GTA04 with 3.2-rc4 and it doesn't
>>>>  work :-(
>>>
>>> Probably, v3.2-rc4 is not the best to try things out...
>>> This patch is based on v3.1, can you try v3.1, so at least we can
>>> check the that the patch itself has no problems?
>>> Also, CC'ing linux-omap.
>>
>> I think I'll be able to give 3.1 a try - I'll let you know.
>>
> 
> Yes, works fine with 3.1

Good to hear!

> 
> 
> I've managed to find the problem.
> 
> commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9
> Author: Peter Chen <peter.chen@freescale.com>
> Date:   Tue Nov 15 21:52:29 2011 +0100
> 
>     PM / driver core: disable device's runtime PM during shutdown
>  
> ....
> 
> @@ -1742,6 +1743,8 @@ void device_shutdown(void)
>                  */
>                 list_del_init(&dev->kobj.entry);
>                 spin_unlock(&devices_kset->list_lock);
> +               /* Disable all device's runtime power management */
> +               pm_runtime_disable(dev);
>  
>                 if (dev->bus && dev->bus->shutdown) {
>                         dev_dbg(dev, "shutdown\n");
> 
> 
> 
> Removing this call allows power-off to work.
> 
> It seems that omap_i2c.1 is normally in runtime suspend.
> omap_i2c_xfer wakes it up, performs the xfer, then puts it back to sleep.
> 
> So this pm_runtime_disable is called while the device is asleep, so it stays
> asleep.  omap_i2c_xfer cannot wake it up and so cannot xfer anything.

Good job on that investigation.
There were several discussions runtime pm related at the kernel summit,
but I failed to see the impact of that on the issue...

> 
> I'll start a new thread including the people responsible for that patch.

Hopefully, it will get us a solution.


-- 
Regards,
Igor.
