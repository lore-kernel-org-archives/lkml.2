Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1BOGqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:46:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:58084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1BOGqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:46:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,473,1291622400"; 
   d="scan'208";a="602726864"
Date: Tue, 15 Feb 2011 14:46:41 +0800
From: Feng Tang <feng.tang@intel.com>
To: <op.q.liu@gmail.com>, <linux-kernel@vger.kernel.org>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, <axboe@kernel.dk>,
        <jack@suse.cz>
Subject: Re: ext2 write performance regression from 2.6.32
Message-ID: <20110215144641.05318556@feng-i7>
In-Reply-To: <AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
References: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
	<AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

After some debugging, here is one possible root cause for the dd performance
drop between 2.6.30 and 2.6.32 (33/34/35 as well): in .30 the dd is a pure
sequential operation while in .32 it isn't, and the change is related to
the introduction of per-pdi flush.

I used a laptop with SDHC controller and run a simple dd of a double RAM size
 _file_ to a 1G SDHC card, the drop from .32 to .30 is about 30%, from roughly
10MB/s to 7MB/s

I'm not very familiar with .30/.32 code, and here is a simple analysis:

When dd to a big ext2 file, there are 2 types of metadata will be updated
besides the file data:
1. The ext2 global info like group descriptors and block bitmaps, whose
   buffer_header will be marked dirty in ext2_new_blocks()
2. The inode of the file under written, marked dirty in ext2_write/update_inode(),
   which is called by write_inode() and in writeback path.

In 2.6.30, with old pdflush interface, during the dd, the writeback of the 2
types of metadata will be triggered from wb_timer_fn() and dirty_balance_pages(),
but they are always delayed in pdflush_operations() as the pdflush_list is
empty. So that only the file data got be written back in a very smooth
sequential mode. 

In 2.6.32, the writeback is per-bdi operation, every time the bdi for the sd
card is called for flush, it will check and try to write back all the dirty
pages, including both the metadata and data pages, so the previously sequential
sd block access is periodically chimed in by the metadata block, which cause
the performance drop. And if I ugly delayed the metadata writeback, the
performance will be restored same as .30.

As for .32, the general max writeback truck is 4MB (with 4K page), so for a
large file dd, maybe we should delay the fs/inode metadata update. Fengguang
Wu's recent writback page enlarge the writetrunk and add io-less writeback,
which may help here.

Thanks,
Feng

> ---------- Forwarded message ----------
> From: Kyle liu <op.q.liu@gmail.com>
> Date: 2011/1/28
> Subject: ext2 write performance regression from 2.6.32
> To: linux-kernel@vger.kernel.org
> 
> 
> Hello,
> 
> Since upgrading 2.6.30->2.6.32, ext2 write performance of SATA/SD/USB
> card is very low (except SSD). The issue is also exist after 2.6.32,
> e.g. 2.6.34, 2.6.35. Write performance of SATA decreased from 115MB/s
> to 80MB/s. Write performance of SDHC decreased from 12MB/s to 3MB/s.
> 
> My test tool is iozone  and dd, test file size is 2*RAM size. CPU is
> PowerPC core e500, SATA disk is WD 10000RPM drives, SDHC is Sandisk
> class 10 card.
> 
> What decrease the performance? Because the sequence of block of
> writing is not continuous.
> Here are some debug info below (in function  mmc_blk_issue_rq).
> major means major device number of the device, pos means the position
> of writing, blocks means the block number need writing.
> 
> iozone -Rab result -i0 -r64 -n512m -g512m -f /mnt/ff
> dd if=/dev/zero of=/mnt/ff bs=16K count=32768
> …………..
> major=179, pos=270360, blocks=8
> major=179, pos=278736, blocks=8
> major=179, pos=24, blocks=8
> major=179, pos=8216, blocks=24
> major=0, pos=16424, blocks=8
> major=0, pos=196624, blocks=104
> major=179, pos=204920, blocks=16
> major=0, pos=204936, blocks=128
> …………..
> major=179, pos=1048592, blocks=8
> major=179, pos=1074256, blocks=8
> major=179, pos=1090656, blocks=8
> major=179, pos=16, blocks=8
> major=0, pos=884704, blocks=128
> major=0, pos=884832, blocks=128
> major=0, pos=884960, blocks=128
> major=0, pos=885088, blocks=32
> major=179, pos=1082456, blocks=8
> major=179, pos=1098856, blocks=8
> major=179, pos=24, blocks=8
> major=179, pos=8232, blocks=8
> major=179, pos=204920, blocks=8
> major=0, pos=885120, blocks=128
> ………….
> 
> Some write are from write_boundary_block, these are necessary. But
> others that major is not zero is from def_blk_aops->blkdev_writepage.
> Before 2.6.32, there is no case happened like this. And why, I have
> already mount filesystem. What are the usage of these data?
> 
> Temporarily, I mask all these write operations in do_writepage()
> below, /* no need to write device if the operation is not used to
> format device */ if (imajor(mapping->host) && (wbc->sync_mode ==
> WB_SYNC_NONE)) return 0;
> 
> test record below (same behavior to 2.6.30):
> …………
> major=0, pos=23488, blocks=128
> major=0, pos=23616, blocks=128
> major=0, pos=23744, blocks=128
> major=0, pos=23872, blocks=128
> major=0, pos=24000, blocks=128
> major=0, pos=24128, blocks=128
> major=0, pos=24256, blocks=128
> major=0, pos=24384, blocks=128
> major=0, pos=24512, blocks=128
> major=0, pos=24640, blocks=128
> major=179, pos=24768, blocks=8—from write_boundary_block()
> major=0, pos=24784, blocks=128
> major=0, pos=24912, blocks=128
> major=0, pos=25040, blocks=128
> major=0, pos=29136, blocks=128
> major=0, pos=29264, blocks=128
> major=0, pos=29392, blocks=128
> major=0, pos=29520, blocks=128
> …………..
> 
> Until now it works fine (except format disk). Data integrity is fine.
> Who can tell me what is the usage of the redundant data. I’m not
> familiar with filesystem.
> 
> Thanks.
> 
> Best Regards
> Eiji
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
