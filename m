Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2HSTv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:51:56 -0400
Received: from zose-mta15.web4all.fr ([176.31.217.11]:40446 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2HSTvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:51:52 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 15:51:52 EDT
Message-ID: <503141B5.7070705@tribudubois.net>
Date: Sun, 19 Aug 2012 21:42:45 +0200
From: Jean-Christophe DUBOIS <jcd@tribudubois.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question on SLAB allocator.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was working on some memory related cleaning requirements and as part 
of this I tried to force all SLAB allocated memory (this is the 
allocator I use in my kernel) to be zeroized before being handed back to 
the requester.

So basically in mm/slab.c (__cache_alloc_node() and __cache_alloc()) I 
made the optional zeroization (based on __GFP_ZERO) non optional 
(forcing __GFP_ZERO in the flags, so always done). Therefore all 
allocated memory through these 2 functions is set to 0 before being used 
by the kernel.

When doing so, the kernel will fail booting with the following backtrace 
(I am testing this on Qemu emulating a versatilepb board with stock 
kernel 3.4.4 but I have the same problem on real hardware [i.MX25 based] 
with kernel 3.0.3).

...
[    0.659312] Trying to unpack rootfs image as initramfs...
[    0.666474] Unable to handle kernel NULL pointer dereference at 
virtual address 00000004
[    0.666916] pgd = c0004000
[    0.667091] [00000004] *pgd=00000000
[    0.667601] Internal error: Oops: 805 [#1] PREEMPT ARM
[    0.668024] CPU: 0    Not tainted  (3.4.4 #77)
[    0.668691] PC is at inode_lru_list_del+0x2c/0x98
[    0.668942] LR is at inode_lru_list_del+0x18/0x98
[    0.669180] pc : [<c00a0b88>]    lr : [<c00a0b74>] psr: a0000013
[    0.669197] sp : c789dde8  ip : 00000002  fp : c789ddfc
[    0.669660] r10: c7a96c30  r9 : c7a96c43  r8 : 00000030
[    0.670164] r7 : 00000001  r6 : c017a550  r5 : c789c000  r4 : c741eed8
[    0.670490] r3 : c741ef4c  r2 : 00000000  r1 : 00000000  r0 : 00000001
[    0.670933] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel
[    0.671294] Control: 00093177  Table: 00004000  DAC: 00000017
[    0.671611] Process swapper (pid: 1, stack limit = 0xc789c270)
[    0.671957] Stack: (0xc789dde8 to 0xc789e000)
[    0.672278] dde0:                   00000007 c741eed8 c789de1c 
c789de00 c00a2588 c00a0b68
[    0.672730] de00: 00000007 c741eed8 c789c000 c741eed8 c789de34 
c789de20 c00a2714 c00a24b8
[    0.673137] de20: 00000000 c741df70 c789de54 c789de38 c009f874 
c00a26e4 00000000 c741df70
[    0.673538] de40: c7402ed8 00000000 c789de74 c789de58 c00971f8 
c009f76c 00000001 c7403f70
[    0.674099] de60: c741df70 c01ec998 c789def4 c789de78 c00972fc 
c00970d0 00000000 c785bf78
[    0.674645] de80: c7403f70 01c0d8cc 00000004 c7a94000 00000000 
c789dea0 c7402ed8 00000000
[    0.675360] dea0: 00000002 00000000 00000000 c78941c0 00000002 
00000000 00000000 00000000
[    0.675967] dec0: 00000000 00000000 502f13fa 00000000 502f13fa 
00000000 00000000 c7a94000
[    0.676579] dee0: c7a96c00 00000000 c789df04 c789def8 c0097328 
c0097218 c789df7c c789df08
[    0.677007] df00: c01b6d28 c009731c c789df24 c019e8a8 00000001 
00000009 000241c0 00000000
[    0.677488] df20: 00000000 00000000 00001000 00000000 502f13fa 
00000000 502f13fa 00000000
[    0.678020] df40: 00000000 173eed84 00000000 00000000 00000000 
c789df80 00000005 c01c6188
[    0.678559] df60: 00000000 c01b6bf8 c01b41a8 c01d0cf8 c789dfb4 
c789df80 c01b48d0 c01b6c04
[    0.679050] df80: 00000000 c031f4dc c789dfb4 c01c61a4 00000005 
c01c61a8 00000005 c01c6188
[    0.679544] dfa0: c01eca40 0000002e c789dff4 c789dfb8 c01b4a9c 
c01b483c 00000005 00000005
[    0.680024] dfc0: c01b41a8 c01b49a8 c0019eb0 00000000 c01b49a8 
c0019eb0 00000013 00000000
[    0.680540] dfe0: 00000000 00000000 00000000 c789dff8 c0019eb0 
c01b49b4 aaaaaaaa aaaaaaaa
[    0.681055] Backtrace:
[    0.681459] [<c00a0b5c>] (inode_lru_list_del+0x0/0x98) from 
[<c00a2588>] (iput_final+0xdc/0x22c)
[    0.682041]  r4:c741eed8 r3:00000007
[    0.682379] [<c00a24ac>] (iput_final+0x0/0x22c) from [<c00a2714>] 
(iput+0x3c/0x44)
[    0.682843]  r6:c741eed8 r5:c789c000 r4:c741eed8 r3:00000007
[    0.683254] [<c00a26d8>] (iput+0x0/0x44) from [<c009f874>] 
(d_delete+0x114/0x128)
[    0.683632]  r4:c741df70 r3:00000000
[    0.683887] [<c009f760>] (d_delete+0x0/0x128) from [<c00971f8>] 
(vfs_rmdir+0x134/0x148)
[    0.684301]  r6:00000000 r5:c7402ed8 r4:c741df70 r3:00000000
[    0.684707] [<c00970c4>] (vfs_rmdir+0x0/0x148) from [<c00972fc>] 
(do_rmdir+0xf0/0x104)
[    0.685101]  r6:c01ec998 r5:c741df70 r4:c7403f70 r3:00000001
[    0.685487] [<c009720c>] (do_rmdir+0x0/0x104) from [<c0097328>] 
(sys_rmdir+0x18/0x1c)
[    0.685878]  r5:00000000 r4:c7a96c00
[    0.686200] [<c0097310>] (sys_rmdir+0x0/0x1c) from [<c01b6d28>] 
(populate_rootfs+0x130/0x228)
[    0.686677] [<c01b6bf8>] (populate_rootfs+0x0/0x228) from 
[<c01b48d0>] (do_one_initcall+0xa0/0x178)
[    0.687176] [<c01b4830>] (do_one_initcall+0x0/0x178) from 
[<c01b4a9c>] (kernel_init+0xf4/0x1bc)
[    0.687617]  r8:0000002e r7:c01eca40 r6:c01c6188 r5:00000005 r4:c01c61a8
[    0.688076] [<c01b49a8>] (kernel_init+0x0/0x1bc) from [<c0019eb0>] 
(do_exit+0x0/0x77c)
[    0.688601] Code: e2843074 e1530002 0a000010 e5941078 (e5821004)
[    0.690985] ---[ end trace 1b75b31a2719ed1c ]---
[    0.691426] note: swapper[1] exited with preempt_count 2
[    0.692799] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b

The fact is, that when inspecting the inode structure passed to 
inode_lru_list_del(), some list members seem to be badly set. In my case 
the i_lru (and i_wb_list ?) member is initialized to {next = 0x0, prev = 
0x0} which is detected as a non empty list but obviously this cannot fly 
and the kernel crash badly on it (see above).

(gdb) print *inode
$1 = {i_mode = 16832, i_opflags = 4, i_uid = 0, i_gid = 0, i_flags = 16,
   i_op = 0xc0175360, i_sb = 0xc780b000, i_mapping = 0xc7400338, i_ino = 
9, {
     i_nlink = 0, __i_nlink = 0}, i_rdev = 0, i_atime = {tv_sec = 
1345262586,
     tv_nsec = 0}, i_mtime = {tv_sec = 1345262586, tv_nsec = 0}, i_ctime = {
     tv_sec = 0, tv_nsec = 350000004}, i_lock = {{rlock = {
         raw_lock = {<No data fields>}}}}, i_bytes = 0, i_blocks = 0,
   i_size = 0, i_state = 7, i_mutex = {count = {counter = 1}, wait_lock = {{
         rlock = {raw_lock = {<No data fields>}}}}, wait_list = {
       next = 0xc74002e0, prev = 0xc74002e0}}, dirtied_when = 0, i_hash = {
     next = 0x0, pprev = 0x0}, i_wb_list = {next = 0x0, prev = 0x0}, 
i_lru = {
     next = 0x0, prev = 0x0}, i_sb_list = {next = 0xc740041c,
     prev = 0xc780b064}, {i_dentry = {next = 0xc740030c, prev = 
0xc740030c},
     i_rcu = {next = 0xc740030c, func = 0xc740030c}}, i_count = {counter 
= 0},
   i_blkbits = 12, i_version = 0, i_dio_count = {counter = 0}, 
i_writecount = {
     counter = 0}, i_fop = 0xc0172100, i_flock = 0x0, i_data = {
     host = 0xc7400288, page_tree = {height = 0, gfp_mask = 0, rnode = 
0x0},
     tree_lock = {{rlock = {raw_lock = {<No data fields>}}}},
     i_mmap_writable = 0, i_mmap = {prio_tree_node = 0x0, index_bits = 0,
       raw = 0}, i_mmap_nonlinear = {next = 0x0, prev = 0x0}, 
i_mmap_mutex = {
       count = {counter = 0}, wait_lock = {{rlock = {
             raw_lock = {<No data fields>}}}}, wait_list = {next = 0x0,
         prev = 0x0}}, nrpages = 0, writeback_index = 0, a_ops = 
0xc0175440,
     flags = 268566738, backing_dev_info = 0xc01d8c98, private_lock = {{
         rlock = {raw_lock = {<No data fields>}}}}, private_list = {next 
= 0x0,
       prev = 0x0}, assoc_mapping = 0x0}, i_devices = {next = 0x0, prev 
= 0x0},
   {i_pipe = 0x0, i_bdev = 0x0, i_cdev = 0x0}, i_generation = 0,
   i_private = 0x0}

In comparison a "good" (non crashing) kernel (at the iput_final() 
breakpoint) would have an inode struct looking like this.

(gdb) print *inode
$1 = {i_mode = 16832, i_opflags = 4, i_uid = 0, i_gid = 0, i_flags = 16,
   i_op = 0xc0175360, i_sb = 0xc780b000, i_mapping = 0xc7400338, i_ino = 
9, {
     i_nlink = 0, __i_nlink = 0}, i_rdev = 0, i_atime = {tv_sec = 
1345262586,
     tv_nsec = 0}, i_mtime = {tv_sec = 1345262586, tv_nsec = 0}, i_ctime = {
     tv_sec = 0, tv_nsec = 350000004}, i_lock = {{rlock = {
         raw_lock = {<No data fields>}}}}, i_bytes = 0, i_blocks = 0,
   i_size = 0, i_state = 7, i_mutex = {count = {counter = 1}, wait_lock = {{
         rlock = {raw_lock = {<No data fields>}}}}, wait_list = {
       next = 0xc74002e0, prev = 0xc74002e0}}, dirtied_when = 0, i_hash = {
     next = 0x0, pprev = 0x0}, i_wb_list = {next = 0xc74002f4,
     prev = 0xc74002f4}, i_lru = {next = 0xc74002fc, prev = 0xc74002fc},
   i_sb_list = {next = 0xc740041c, prev = 0xc780b064}, {i_dentry = {
       next = 0xc740030c, prev = 0xc740030c}, i_rcu = {next = 0xc740030c,
       func = 0xc740030c}}, i_count = {counter = 0}, i_blkbits = 12,
   i_version = 0, i_dio_count = {counter = 0}, i_writecount = {counter = 
0},
   i_fop = 0xc0172100, i_flock = 0x0, i_data = {host = 0xc7400288, 
page_tree = {
       height = 0, gfp_mask = 32, rnode = 0x0}, tree_lock = {{rlock = {
           raw_lock = {<No data fields>}}}}, i_mmap_writable = 0, i_mmap = {
       prio_tree_node = 0x0, index_bits = 1, raw = 1}, i_mmap_nonlinear = {
       next = 0xc7400354, prev = 0xc7400354}, i_mmap_mutex = {count = {
         counter = 1}, wait_lock = {{rlock = {raw_lock = {<No data 
fields>}}}},
       wait_list = {next = 0xc7400360, prev = 0xc7400360}}, nrpages = 0,
     writeback_index = 0, a_ops = 0xc0175440, flags = 268566738,
     backing_dev_info = 0xc01d8c98, private_lock = {{rlock = {
           raw_lock = {<No data fields>}}}}, private_list = {next = 
0xc740037c,
       prev = 0xc740037c}, assoc_mapping = 0x0}, i_devices = {
     next = 0xc7400388, prev = 0xc7400388}, {i_pipe = 0x0, i_bdev = 0x0,
     i_cdev = 0x0}, i_generation = 0, i_private = 0x0}

As one can see most list members are badly set (to {next = 0x0, prev = 
0x0}) at iput() time in the kernel doing forced zeroization of allocated 
memory ...

So beside the fact that setting the memory to 0 in all allocation is 
certainly bad for performance (for example inodes structures are 
explicitely set to 0 by inode_init_once()), is there another reason it 
should not be done on __all__ allocation? Is there some type of 
allocation that should never be set to 0 whatsoever? If so why?

Thanks for your time.

JC





