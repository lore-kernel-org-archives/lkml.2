Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2CGPnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:43:31 -0500
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:40244 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755251Ab2CGPn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:43:29 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 10:43:29 EST
MIME-Version: 1.0
In-Reply-To: <CANrkHUZysOnHKKUuLm0Vbo1KsNp0yUd=udjGvQ43=gTTXbWeCw@mail.gmail.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
	<20120301185535.29210.71546.stgit@kaulin.local>
	<4F50643B.9050500@ti.com>
	<20120302172251.GJ18901@atomide.com>
	<4F548457.5050205@ti.com>
	<CANrkHUZysOnHKKUuLm0Vbo1KsNp0yUd=udjGvQ43=gTTXbWeCw@mail.gmail.com>
Date: Wed, 7 Mar 2012 21:06:42 +0530
Message-ID: <CANrkHUaYDpv=p0p81oKWCoewyjheyZYkCqvZY7_ZQxWi_=8YFw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mmc: omap_hsmmc: Simplify init for twl6030 MMC card detect
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 3:55 PM, T Krishnamoorthy, Balaji
<balajitk@ti.com> wrote:
> On Mon, Mar 5, 2012 at 2:46 PM, Rajendra Nayak <rnayak@ti.com> wrote:
>> On Friday 02 March 2012 10:52 PM, Tony Lindgren wrote:
>>>
>>> BTW, with -rc5, looks like re-inserting omap_hsmmc on omap4 fails
>>> to detect any cards, and then fails to unload. This works on omap3
>>> just fine. Any ideas why that would be?
>>
>>
>> Yeah, looks like thats broken. I am not sure whats going wrong though.
>> I just enabled CONFIG_MMC_DEBUG and saw these logs below.
>>
>> Venkat/Balaji, care to look at this one?
>>
>
> Let me check this

OMAP4 and OMAP3 HSMMC IP registers differ by 0x100 offset.
Addng the offset to platform_device resource structure
increments the start address for every insmod operation.
MMC command fails on re-insertion as module due incorrect register base.
Fix this by updating the ioremap base address only.

Signed-off-by: Balaji T K <balajitk@ti.com>
---
Note:  eMMC detection is still failing on resertion due to card vcc
power off on rmmod

 drivers/mmc/host/omap_hsmmc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index fd0c661..4e1f8f6 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1870,8 +1870,6 @@ static int __init omap_hsmmc_probe(struct
platform_device *pdev)
 	if (res == NULL || irq < 0)
 		return -ENXIO;

-	res->start += pdata->reg_offset;
-	res->end += pdata->reg_offset;
 	res = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (res == NULL)
 		return -EBUSY;
@@ -1896,7 +1894,7 @@ static int __init omap_hsmmc_probe(struct
platform_device *pdev)
 	host->irq	= irq;
 	host->id	= pdev->id;
 	host->slot_id	= 0;
-	host->mapbase	= res->start;
+	host->mapbase	= res->start + pdata->reg_offset;
 	host->base	= ioremap(host->mapbase, SZ_4K);
 	host->power_mode = MMC_POWER_OFF;
 	host->next_data.cookie = 1;
-- 
1.7.0.4

>
>> # insmod omap_hsmmc.ko
>> [   43.358398] omap_hsmmc omap_hsmmc.0: context was not lost
>> [   43.364105] omap_hsmmc omap_hsmmc.0: enabled
>> [   44.434661] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0
>> timing 0
>> [   44.442352] omap_hsmmc omap_hsmmc.0: Set clock to 0Hz
>> [   44.474365] omap_hsmmc omap_hsmmc.0: disabled
>> [   44.482208] omap_hsmmc omap_hsmmc.4: context was not lost
>> [   44.482208] omap_hsmmc omap_hsmmc.4: enabled
>> [   44.546600] omap_hsmmc omap_hsmmc.0: context was not lost
>> [   44.552276] omap_hsmmc omap_hsmmc.0: enabled
>> [   44.552276] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
>> [   44.563720] mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 18 width 0
>> timing 0
>> [   44.572174] omap_hsmmc omap_hsmmc.0: Set clock to 0Hz
>> [   44.613800] mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 18 width
>> 0 timing 0
>> [   44.621887] omap_hsmmc omap_hsmmc.0: Set clock to 400000Hz
>> [   44.735290] mmc0: starting CMD52 arg 00000c00 flags 00000195
>> [   44.741271] omap_hsmmc omap_hsmmc.0: mmc0: CMD52, argument 0x00000c00
>> [   45.560241] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0
>> timing 0
>> [   45.567871] omap_hsmmc omap_hsmmc.4: Set clock to 0Hz
>> [   45.591491] omap_hsmmc omap_hsmmc.4: disabled
>> #
>> #
>> # rmmod omap_hsmmc
>> [  607.302307] omap_hsmmc omap_hsmmc.4: context was not lost
>> [  607.308044] omap_hsmmc omap_hsmmc.4: enabled
>> [  607.312591] omap_hsmmc omap_hsmmc.4: disabled
>> [  607.317199] omap_hsmmc omap_hsmmc.4: context was not lost
>> [  607.322875] omap_hsmmc omap_hsmmc.4: enabled
>>



-- 
Thanks and Regards,
Balaji T K
