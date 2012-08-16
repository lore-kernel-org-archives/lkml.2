Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2HPINb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:13:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58665 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab2HPIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <1345043331.3393.151.camel@sauron.fi.intel.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com> <1345043331.3393.151.camel@sauron.fi.intel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 16 Aug 2012 10:13:03 +0200
Message-ID: <CACQ1gAgqYPAWvpCs-buhZfoxDfvsKYge=pq+Xg0eGAuURbNjxw@mail.gmail.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get bad_peb_limit
To: dedekind1@gmail.com
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/15 Artem Bityutskiy <dedekind1@gmail.com>:
> On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
>> +                     /* we are using here the whole MTD device size and not
>> +                      * the MTD partition size because the maximum number of
>> +                      * bad blocks is a percentage of the whole device and
>> +                      * the bad blocks are not fairly disposed on a flash
>> +                      * device
>> +                      */
>
> Would you please use proper kernel-style comments instead, to be
> consistent with the rest of the UBI code? I've amended this one, but
> wanted to note for future.
ok, sorry for that.

>
> I've re-based your patch against the latest UBI. I've also tried to
> improve the Kconfig help message as well. Below is the patch I ended up
> with.
>
>
> From cb14c6c5455443cbe960a36e77b3fcd0e5bc7152 Mon Sep 17 00:00:00 2001
> From: Richard Genoud <richard.genoud@gmail.com>
> Date: Tue, 10 Jul 2012 18:23:41 +0200
> Subject: [PATCH 2/2] UBI: use the whole MTD device size to get bad_peb_limit
>
> On NAND flash devices, UBI reserves some physical erase blocks (PEB) for
> bad block handling. Today, the number of reserved PEB can only be set as a
> percentage of the total number of PEB in each MTD partition. For example, for a
> NAND flash with 128KiB PEB, 2 MTD partition of 20MiB (mtd0) and 100MiB (mtd1)
> and 2% reserved PEB:
>  - the UBI device on mtd0 will have 2 PEB reserved
>  - the UBI device on mtd1 will have 16 PEB reserved
>
> The problem with this behaviour is that NAND flash manufacturers give a
> minimum number of valid block (NVB) during the endurance life of the
> device, e.g.:
>
> Parameter             Symbol    Min    Max    Unit      Notes
> --------------------------------------------------------------
> Valid block number     NVB     1004    1024   Blocks     1
> Note:
> 1. Invalid blocks are block that contain one or more bad bits beyond
> ECC. The device may contain bad blocks upon shipment. Additional bad
> blocks may develop over time; however, the total number of available
> blocks will not drop below NVB during the endurance life of the device.
>
> From this number we can deduce the maximum number of bad PEB that a device will
> contain during its endurance life: a 128MiB NAND flash (1024 PEB) will not have
> less than 20 bad blocks during the flash endurance life.
>
> But the manufacturer doesn't tell where those bad block will appear. He doesn't
> say either if they will be equally disposed on the whole device (and I'm pretty
> sure they won't). So, according to the datasheets, we should reserve the
> maximum number of bad PEB for each UBI device (worst case scenario: 20 bad
> blocks appears on the smallest MTD partition).
>
> So this patch make UBI use the whole MTD device size to calculate the maximum
> bad expected eraseblocks.
>
> The Kconfig option is in per1024 blocks, thus it can have a default value of 20
> which is *very* common for NAND devices.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  drivers/mtd/ubi/Kconfig |   27 +++++++++++++++++++++------
>  drivers/mtd/ubi/build.c |   21 ++++++++++++++++++---
>  2 files changed, 39 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
> index b2f4f0f..98bda6c 100644
> --- a/drivers/mtd/ubi/Kconfig
> +++ b/drivers/mtd/ubi/Kconfig
> @@ -28,14 +28,29 @@ config MTD_UBI_WL_THRESHOLD
>           to 128 or 256, although it does not have to be power of 2).
>
>  config MTD_UBI_BEB_LIMIT
> -       int "Percentage of maximum expected bad eraseblocks"
> -       default 2
> -       range 0 25
> +       int "Maximum expected bad eraseblock count per 1024 eraseblocks"
> +       default 20
> +       range 2 256
>         help
>           This option specifies the maximum bad physical eraseblocks UBI
> -         expects on the UBI device (percents of total number of physical
> -         eraseblocks on this MTD partition). If the underlying flash does not
> -         admit of bad eraseblocks (e.g. NOR flash), this value is ignored.
> +         expects on the MTD device (per 1024 eraseblocks). If the underlying
> +         flash does not admit of bad eraseblocks (e.g. NOR flash), this value
> +         is ignored.
> +
> +         NAND datasheets often specify the minimum and maximum NVM (Number of
> +         Valid Blocks) for the flashes' endurance lifetime. The maximum
> +         expected bad eraseblocks per 1024 eraseblocks then can be calculated
> +         as "1024 * (1 - MinNVB / MaxNVB)", which gives 20 for most NANDs
> +         (MaxNVB is basically the total count of eraseblocks on the chip).
> +
> +         To put it differently, if this value is 20, UBI will try to reserve
> +         about 1.9% of physical eraseblocks for bad blocks handling. And that
> +         will be 1.9% of eraseblocks on the entire NAND chip, not just the MTD
> +         partition UBI attaches. This means that if you have, say,  if a NAND
I don't quite understand this sentence.
Maybe you meant:
This means that if you have, say, a NAND flash chip that admits a
maximum of 40 bad eraseblocks [...]
(but I'm not a native english speaker !)
> +         flash chip admits maximum 40 bad eraseblocks, and it is split on two
> +         MTD partitions of the same size, UBI will reserve 40 eraseblocks when
> +         attaching a partition.
> +
>           Leave the default value if unsure.
>

Best regards,
Richard.


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
