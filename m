Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2F1QHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:07:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48228 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2F1QHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <1340894351.3070.121.camel@sauron.fi.intel.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com> <1340894351.3070.121.camel@sauron.fi.intel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 28 Jun 2012 18:07:24 +0200
Message-ID: <CACQ1gAjLdR-ZRUS6gxMrJzVpRdvdMK2JRceyiFmeSq-FQkZbZg@mail.gmail.com>
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in Kconfig
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/28 Artem Bityutskiy <dedekind1@gmail.com>:
> Hi, first of all, this 1% is does is not good enough for modern devices.
> It is just a default I picked out of the thin air.
Hi !
Agreed, it seems that 2% of the whole flash (at least for SLC device)
is more realistic.
>
> What we really need is to make it possible to specify beb_rsvd_level at
> attach time. I believe it is not difficult to implement:
>
> 1. Add a parameter to ubiattach
> 2. Extend the attach ioctl and add beb_rsvd_level there. We have 12
> unused bytes in 'struct ubi_attach_req'.
> 3. Extend the "mtd" module parameter and allow to specify beb_rsvd_level
> there as well.
>
> That's it - you can specify the needed numbers for your flash.
>
>  to make this per-MTD device
All right, with this approach, we can have different flash devices
with different MBB. Got it.

> On Mon, 2012-06-25 at 17:08 +0200, Richard Genoud wrote:
>> The problem with this behaviour is that NAND flash manufacturers give a
>> minimum number of valid block (NVB) during the endurance life of the
>> device.
>> E.G.:
>> Parameter             Symbol    Min    Max    Unit      Notes
>> --------------------------------------------------------------
>> Valid block number     NVB     1004    1024   Blocks     1
>> Note:
>> 1. Invalid blocks are block that contain one or more bad bits beyond
>> ECC. The device may contain bad blocks upon shipment. Additional bad
>> blocks may develop over time; however, the total number of available
>> blocks will not drop below NVB during the endurance life of the device.
>
> OK, in this discussion is is easier to talk about maximum bad blocks
> (MBB) rather than minimum good blocks, though. So basically, the vendor
> guarantees that there will be at most MBB bad blocks.
>
>> From this number we can deduce the maximum number of bad PEB that a
>> device will contain during its endurance life :
>> A 128MiB NAND flash (1024 PEB) will not have less than 20 bad blocks
>> during the flash endurance life.
>
> OK.
>
>> BUT, the manufacturer doesn't tell where those bad block will appear. He
>> doesn't say either if they will be equally disposed on the whole device
>> (and I'm pretty sure they won't).
>
> Right, then if you implement what I suggested, you'll pass
> "beb_rsvd_level=20" when attaching both partitions.
>
>> So, according to the datasheets, we should reserve the maximum number of
>> bad PEB for each UBI volume.
>> (Worst case scenario: 20 bad blocks appears on the smallest UBI volume.)
>
> Err, not smallest UBI volume, but smallest MTD partition. We reserve
> PEBs per-MTD device.
Yes, you're right (I usually use only one ubi volume per mdt device,
that's why I mixed up things)

>> => The actual parameter MTD_UBI_BEB_RESERVE is not enough to cover this
>> scenario. We need to set a minimal number of reserved PEB for a UBI
>> volume.
>
> Frankly, I do not understand this logic :-) And your patch looks wrong -
> it touches the "auto-format" code which you may consider more like a
> "debugging" feature and should not rely on this in production.
Sorry, but I don't understand what you mean by the "auto-format" code.
The other thing I don't understand is that the patch touches only the
ubi_calculate_reserved() function which is the only place where
beb_rsvd_level is set.
And with your approach, as far as we'll get beb_rsvd_level value from
ioctl, I'll have also to touch this function...
(or maybe what's wrong with this patch is that beb_rsvd_level can be
less that 2, in this case I should have set a minimum range of 2 in
Kconfig)

Thanks for your comments.

Best regards,
Richard.

> --
> Best Regards,
> Artem Bityutskiy



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
