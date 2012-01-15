Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2AOWhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:37:07 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:49327 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2AOWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:37:05 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jan 2012 17:37:04 EST
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 15 Jan 2012 23:37:01 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: linux-kernel@vger.kernel.org
Subject: [kmemleak report 1/2] kernel 3.1.6, x86_64: mm, xfs ?, vfs ?
Message-ID: <20120115223701.GA3937@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120115222932.GA24330@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly 10 … 30 objects are reported with identical backtraces after daily tarsync run updating the
Gentoo portage tree on my root partition:

unreferenced object 0xffff8800ca5c9e50 (size 208):
  comm "flush-8:0", pid 12135, jiffies 4525218264 (age 20542.327s)
  hex dump (first 32 bytes):
    88 bd b9 1c 01 88 ff ff 00 e0 da 24 01 88 ff ff  ...........$....
    80 f3 6f 81 ff ff ff ff 04 00 00 00 00 00 00 00  ..o.............
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff81266baf>] kmem_zone_alloc+0x6f/0xe0
    [<ffffffff81266c39>] kmem_zone_zalloc+0x19/0x50
    [<ffffffff8126a977>] xfs_allocbt_init_cursor+0x47/0xc0
    [<ffffffff812690e8>] xfs_alloc_ag_vextent_near+0x68/0x850
    [<ffffffff81269995>] xfs_alloc_ag_vextent+0xc5/0x100
    [<ffffffff8126a328>] xfs_alloc_vextent+0x398/0x4a0
    [<ffffffff81275a07>] xfs_bmap_btalloc+0x2f7/0x710
    [<ffffffff81275e29>] xfs_bmap_alloc+0x9/0x10
    [<ffffffff81278632>] xfs_bmapi+0xa92/0x1160
    [<ffffffff8125b1f5>] xfs_iomap_write_allocate+0x175/0x320
    [<ffffffff8124e093>] xfs_map_blocks+0x183/0x1b0
    [<ffffffff8124f006>] xfs_vm_writepage+0x186/0x490
    [<ffffffff810f9e72>] __writepage+0x12/0x40


For trials to reproduce the problem, mount options and relevant part of sysctl.conf settings are
shown below:
*  I get fewer of this backtraces, when I switch off laptop mode and use sysctl.conf (b) kernel
   default settings.
*  I get even more of this backtraces and additionally ALSA output stalls, when I switch off laptop
   mode and use sysctl.conf settings (c) “paranoid” shown below.
*  I get fewer of this backtraces, when I try to reproduce the write load on another XFS partition
   with the same mount options (same disk, theoretically a bit faster than the root partition).
*  I get none of this backtraces, when I use this other XFS partition with mount option nodelaylog.


grep ' / ' /proc/mounts
-----------------------
/dev/root / xfs rw,attr2,delaylog,nobarrier,logbufs=8,logbsize=256k,noquota 0 0


sysctl.conf:  (a) laptop mode with my preferred settings
--------------------------------------------------------
fs.xfs.age_buffer_centisecs = 20000
fs.xfs.filestream_centisecs = 20000
fs.xfs.xfsbufd_centisecs = 600
fs.xfs.xfssyncd_centisecs = 20000
vm.dirty_expire_centisecs = 9000
vm.dirty_writeback_centisecs = 9000
vm.laptop_mode = 20
vm.dirty_ratio = 6
vm.dirty_background_ratio = 60
vm.vfs_cache_pressure = 20

sysctl.conf:  (b) kernel default, for convenient “undoing” of (a) and (c)
---------------------------------
fs.xfs.age_buffer_centisecs = 1500
fs.xfs.filestream_centisecs = 3000
fs.xfs.xfsbufd_centisecs = 100
fs.xfs.xfssyncd_centisecs = 3000
vm.dirty_expire_centisecs = 3000
vm.dirty_writeback_centisecs = 500
vm.laptop_mode = 0
vm.dirty_ratio = 60
vm.dirty_background_ratio = 40
vm.vfs_cache_pressure = 100

sysctl.conf:  (c) “paranoid”, just for testing
-----------------------------
fs.xfs.age_buffer_centisecs = 100
fs.xfs.filestream_centisecs = 100
fs.xfs.xfsbufd_centisecs = 50
fs.xfs.xfssyncd_centisecs = 100
vm.dirty_expire_centisecs = 20
vm.dirty_writeback_centisecs = 20
vm.laptop_mode = 0
vm.dirty_bytes = 8192
vm.dirty_background_bytes = 8192
vm.vfs_cache_pressure = 100


uname -r -m -p
--------------
3.1.6-grsecurity.roland.0 x86_64 Intel(R) Core(TM) i7 CPU M 620 @ 2.67GHz 


-- 
Roland Eggner
