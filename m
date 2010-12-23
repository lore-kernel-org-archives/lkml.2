Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0LWGGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:06:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LWGGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZDxFDqdM5zfDCBppF8yxSZ8i5pSnr5suyDkVUfV0Z1WcVJ4wKrIk08QldYfGxt3fn/
         C5tmWIvjQBITg+95BzUsP5c2KeWPnGbJrm65ON3hkDzhSIsAsNzyYwcRY1iG21Y+yeUV
         +fctgPiukTFLsKMpAbIdmvwbahOB+ccnk5Fb4=
MIME-Version: 1.0
In-Reply-To: <1292777645.13362.3.camel@koala>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
	<1292340409.2538.40.camel@localhost>
	<AANLkTi=zB7UBjkvGYv_wdwZpH1Ghatn6eye1z5616h4X@mail.gmail.com>
	<1292777645.13362.3.camel@koala>
Date: Thu, 23 Dec 2010 14:06:33 +0800
Message-ID: <AANLkTikSVLNaFOT55piRosOCyJ9uXQ85QD0u3w75UimU@mail.gmail.com>
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Jason Liu <liu.h.jason@gmail.com>
To: dedekind1@gmail.com
Cc: Jason Liu <r64343@freescale.com>, David.Woodhouse@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Artem,

2010/12/20 Artem Bityutskiy <dedekind1@gmail.com>:
> On Wed, 2010-12-15 at 09:55 +0800, Jason Liu wrote:
>> > š š š š/* Do not allow reads past end of device */
>> > š š š šif (unlikely(from >= mtd->size ||
>> > š š š š š š š š š š ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
>> > š š š š š š š š š š š š š š š š š š š š(from >> chip->page_shift)) * len)) {
>> > š š š š š š š šDEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt read beyond end "
>> > š š š š š š š š š š š š š š š š š š š š"of device\n", __func__);
>> > š š š š š š š šreturn -EINVAL;
>> > š š š š}
>>
>> Here the mtd->size in nand_base.c should be the NAND flash chip size,
>
> I think this is partition size as well.

I think you are wrong. This should be the NAND flash chip size not the
partition size.

>
>> while in nand_oobtest,
>>
>> š š š š š š š /* Attempt to read off end of device */
>> š š š š š š š š ops.mode š š š= MTD_OOB_AUTO;
>> š š š š š š š š ops.len š š š = 0;
>> š š š š š š š š ops.retlen š š= 0;
>> š š š š š š š š ops.ooblen š š= mtd->ecclayout->oobavail;
>> š š š š š š š š ops.oobretlen = 0;
>> š š š š š š š š ops.ooboffs š = 1;
>> š š š š š š š š ops.datbuf š š= NULL;
>> š š š š š š š š ops.oobbuf š š= readbuf;
>> š š š š š š š š printk(PRINT_PREF "attempting to read past end of device\n");
>> š š š š š š š š printk(PRINT_PREF "an error is expected...\n");
>> š š š š š š š š err = mtd->read_oob(mtd, mtd->size - mtd->writesize, &ops);
>> š š š š š š š š if (err) {
>> š š š š š š š š š š š š printk(PRINT_PREF "error occurred as expected\n");
>> š š š š š š š š š š š š err = 0;
>> š š š š š š š š } else {
>> š š š š š š š š š š š š printk(PRINT_PREF "error: read past end of device\n");
>> š š š š š š š š š š š š errcnt += 1;
>> š š š š š š š š }
>> š š š š }
>>
>> here, mtd->size is mtd partition size right? when the mtd partition is
>> not the last MTD partition, the error will happen.
>
> I think this is the same in both. Try to debug this with printks().
>
>>
>> I have tested on real NAND, while not on nandsim.
>
> Please, try to reproduce this with nandsim as well, and if it works, try
> to find out why (using printk debugging)

Yes, I have reproduce this issue with nandsim, please check the following log,

root@freescale ~$ insmod nandsim.ko first_id_byte=0x20
second_id_byte=0xaa third_id_byte=0x00 fourth_id_byte=0x15
parts=0x400,0x400
[nandsim] warning: read_byte: unexpected data output cycle, state is
STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is
STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is
STATE_READY return 0x0
[nandsim] warning: read_byte: unexpected data output cycle, state is
STATE_READY return 0x0
NAND device: Manufacturer ID: 0x20, Chip ID: 0xaa (ST Micro NAND
256MiB 1,8V 8-bit)
flash size: 256 MiB
page size: 2048 bytes
OOB area size: 64 bytes
sector size: 128 KiB
pages number: 131072
pages per sector: 64
bus width: 8
bits in sector size: 17
bits in page size: 11
bits in OOB size: 6
flash size with OOB: 270336 KiB
page address bytes: 5
sector address bytes: 3
options: 0x8
Scanning device for bad blocks
Creating 2 MTD partitions on "NAND 256MiB 1,8V 8-bit":
0x000000000000-0x000008000000 : "NAND simulator partition 0"
0x000008000000-0x000010000000 : "NAND simulator partition 1"
root@freescale ~$ cat /proc/mtd
dev:    size   erasesize  name
mtd0: 00300000 00080000 "bootloader"
mtd1: 00500000 00080000 "nand.kernel"
mtd2: 10000000 00080000 "nand.rootfs"
mtd3: 10000000 00080000 "nand.userfs1"
mtd4: df800000 00080000 "nand.userfs2"
mtd5: 08000000 00020000 "NAND simulator partition 0"
mtd6: 08000000 00020000 "NAND simulator partition 1"
root@freescale ~$ insmod mtd_oobtest.ko dev=5
=================================================
mtd_oobtest: MTD device: 5
mtd_oobtest: MTD device size 134217728, eraseblock size 131072, page
size 2048, count of eraseblocks 1024, pages per eraseblock
64, OOB size 64
mtd_oobtest: scanning for bad eraseblocks
mtd_oobtest: scanned 1024 eraseblocks, 0 are bad
mtd_oobtest: test 1 of 5
mtd_oobtest: erasing whole device
mtd_oobtest: erased 1024 eraseblocks
mtd_oobtest: writing OOBs of whole device
mtd_oobtest: written up to eraseblock 0
mtd_oobtest: written up to eraseblock 256
mtd_oobtest: written up to eraseblock 512
mtd_oobtest: written up to eraseblock 768
mtd_oobtest: written 1024 eraseblocks
mtd_oobtest: verifying all eraseblocks
mtd_oobtest: verified up to eraseblock 0
mtd_oobtest: verified up to eraseblock 256
mtd_oobtest: verified up to eraseblock 512
mtd_oobtest: verified up to eraseblock 768
mtd_oobtest: verified 1024 eraseblocks
mtd_oobtest: test 2 of 5
mtd_oobtest: erasing whole device
mtd_oobtest: erased 1024 eraseblocks
mtd_oobtest: writing OOBs of whole device
mtd_oobtest: written up to eraseblock 0
mtd_oobtest: written up to eraseblock 256
mtd_oobtest: written up to eraseblock 512
mtd_oobtest: written up to eraseblock 768
mtd_oobtest: written 1024 eraseblocks
mtd_oobtest: verifying all eraseblocks
mtd_oobtest: verified up to eraseblock 0
mtd_oobtest: verified up to eraseblock 256
mtd_oobtest: verified up to eraseblock 512
mtd_oobtest: verified up to eraseblock 768
mtd_oobtest: verified 1024 eraseblocks
mtd_oobtest: test 3 of 5
mtd_oobtest: erasing whole device
mtd_oobtest: erased 1024 eraseblocks
mtd_oobtest: writing OOBs of whole device
mtd_oobtest: written up to eraseblock 0
mtd_oobtest: written up to eraseblock 256
mtd_oobtest: written up to eraseblock 512
mtd_oobtest: written up to eraseblock 768
mtd_oobtest: written 1024 eraseblocks
mtd_oobtest: verifying all eraseblocks
mtd_oobtest: verified up to eraseblock 0
mtd_oobtest: verified up to eraseblock 256
mtd_oobtest: verified up to eraseblock 512
mtd_oobtest: verified up to eraseblock 768
mtd_oobtest: verified 1024 eraseblocks
mtd_oobtest: test 4 of 5
mtd_oobtest: erasing whole device
mtd_oobtest: erased 1024 eraseblocks
mtd_oobtest: attempting to start write past end of OOB
mtd_oobtest: an error is expected...
mtd_oobtest: error occurred as expected
mtd_oobtest: attempting to start read past end of OOB
mtd_oobtest: an error is expected...
mtd_oobtest: error occurred as expected
mtd_oobtest: attempting to write past end of device
mtd_oobtest: an error is expected...
mtd_oobtest: error occurred as expected
mtd_oobtest: attempting to read past end of device
mtd_oobtest: an error is expected...
mtd_oobtest: error: read past end of device
mtd_oobtest: attempting to write past end of device
mtd_oobtest: an error is expected...
mtd_oobtest: error occurred as expected
mtd_oobtest: attempting to read past end of device
mtd_oobtest: an error is expected...
mtd_oobtest: error: read past end of device
mtd_oobtest: test 5 of 5
mtd_oobtest: erasing whole device
mtd_oobtest: erased 1024 eraseblocks
mtd_oobtest: writing OOBs of whole device
mtd_oobtest: written up to eraseblock 0
mtd_oobtest: written up to eraseblock 0
mtd_oobtest: written up to eraseblock 256
mtd_oobtest: written up to eraseblock 256
mtd_oobtest: written up to eraseblock 512
mtd_oobtest: written up to eraseblock 512
mtd_oobtest: written up to eraseblock 768
mtd_oobtest: written up to eraseblock 768
mtd_oobtest: written 1023 eraseblocks
mtd_oobtest: verifying all eraseblocks
mtd_oobtest: verified up to eraseblock 0
mtd_oobtest: verified up to eraseblock 256
mtd_oobtest: verified up to eraseblock 512
mtd_oobtest: verified up to eraseblock 768
mtd_oobtest: verified 1023 eraseblocks
mtd_oobtest: finished with 2 errors
=================================================

>
> --
> Best Regards,
> Artem Bityutskiy (âÉÔÀÃËÉÊ áÒÔ£Í)
>
>
