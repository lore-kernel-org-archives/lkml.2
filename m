Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1A1HPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:15:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33509 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1A1HPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rRTefsPkr3HfMA4P1jfrg9Ms5772URkAVJuS+YP/zkJA8shtaxmzSf2gyKxANpuuTD
         1N0ELJyoa4T7Y36pT05e3pHbfRwzxM+sQCyV23bnueOvCq9Mh6hCLx1XXtAqZAHALL0k
         S9ei+jBCgujNy1joam7z3ReLboOM5kRvVVWeY=
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 15:15:34 +0800
Message-ID: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
Subject: ext2 write performance regression from 2.6.32
From: Kyle liu <op.q.liu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since upgrading 2.6.30->2.6.32, ext2 write performance of SATA/SD/USB
card is very low (except SSD). The issue is also exist after 2.6.32,
e.g. 2.6.34, 2.6.35. Write performance of SATA decreased from 115MB/s
to 80MB/s. Write performance of SDHC decreased from 12MB/s to 3MB/s.

My test tool is iozone  and dd, test file size is 2*RAM size. CPU is
PowerPC core e500, SATA disk is WD 10000RPM drives, SDHC is Sandisk
class 10 card.

What decrease the performance? Because the sequence of block of
writing is not continuous.
Here are some debug info below (in function  mmc_blk_issue_rq).
major means major device number of the device, pos means the position
of writing, blocks means the block number need writing.

iozone -Rab result -i0 -r64 -n512m -g512m -f /mnt/ff
dd if=/dev/zero of=/mnt/ff bs=16K count=32768
…………..
major=179, pos=270360, blocks=8
major=179, pos=278736, blocks=8
major=179, pos=24, blocks=8
major=179, pos=8216, blocks=24
major=0, pos=16424, blocks=8
major=0, pos=196624, blocks=104
major=179, pos=204920, blocks=16
major=0, pos=204936, blocks=128
…………..
major=179, pos=1048592, blocks=8
major=179, pos=1074256, blocks=8
major=179, pos=1090656, blocks=8
major=179, pos=16, blocks=8
major=0, pos=884704, blocks=128
major=0, pos=884832, blocks=128
major=0, pos=884960, blocks=128
major=0, pos=885088, blocks=32
major=179, pos=1082456, blocks=8
major=179, pos=1098856, blocks=8
major=179, pos=24, blocks=8
major=179, pos=8232, blocks=8
major=179, pos=204920, blocks=8
major=0, pos=885120, blocks=128
………….

Some write are from write_boundary_block, these are necessary. But
others that major is not zero is from def_blk_aops->blkdev_writepage.
Before 2.6.32, there is no case happened like this. And why, I have
already mount filesystem. What are the usage of these data?

Temporarily, I mask all these write operations in do_writepage() below,
/* no need to write device if the operation is not used to format device */
if (imajor(mapping->host) && (wbc->sync_mode == WB_SYNC_NONE))
return 0;

test record below (same behavior to 2.6.30):
…………
major=0, pos=23488, blocks=128
major=0, pos=23616, blocks=128
major=0, pos=23744, blocks=128
major=0, pos=23872, blocks=128
major=0, pos=24000, blocks=128
major=0, pos=24128, blocks=128
major=0, pos=24256, blocks=128
major=0, pos=24384, blocks=128
major=0, pos=24512, blocks=128
major=0, pos=24640, blocks=128
major=179, pos=24768, blocks=8—from write_boundary_block()
major=0, pos=24784, blocks=128
major=0, pos=24912, blocks=128
major=0, pos=25040, blocks=128
major=0, pos=29136, blocks=128
major=0, pos=29264, blocks=128
major=0, pos=29392, blocks=128
major=0, pos=29520, blocks=128
…………..

Until now it works fine (except format disk). Data integrity is fine.
Who can tell me what is the usage of the redundant data. I’m not
familiar with filesystem.

Thanks.

Best Regards
Eiji
