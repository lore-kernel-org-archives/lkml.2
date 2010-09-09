Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0IIVlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:41:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50630 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753556Ab0IIVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:41:08 -0400
Date: Thu, 9 Sep 2010 16:40:58 -0500
From: Jack Steiner <steiner@sgi.com>
To: tj@kernel.org, shijie8@gmail.com, cl@linux-foundation.org
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Failure in pcpu_extend_area_map()
Message-ID: <20100909214058.GA9650@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have started to see failures in the percpu allocator in recent
linux-next kernels. Failures seem to occur immediately
after pcpu_chunk_relocate() is called to relocate a chunk from slot
10 in pcpu_slot[] to slot 0.

It appears that the list_for_each_entry() in pcpu_alloc() fails
after pcpu_chunk_relocate() does the list_move().


Call tree is:
	pcpu_alloc -> pcpu_alloc_area -> pcpu_chunk_relocate 	(at end of function - /* fully scanned */)


Adding the following patch fixes the problem but I suspect this is not the proper
fix. Has anyone else seen this this failure?


BUG: unable to handle kernel paging request at ffffc90030d02000^M
IP: [<ffffffff810d3173>] pcpu_extend_area_map+0x70/0xb1^M
PGD e81b067 PUD e81c067 PMD 6117067 PTE 0^M
Oops: 0002 [#1] SMP ^M
last sysfs file: ^M
CPU 0 ^M
Modules linked in:^M
^M
Pid: 1, comm: swapper Not tainted 2.6.36-rc3-next-20100908-medusa+ #1 /^M
RIP: 0010:[<ffffffff810d3173>]  [<ffffffff810d3173>] pcpu_extend_area_map+0x70/0xb1^M
RSP: 0018:ffff88000e9dba60  EFLAGS: 00000007^M
RAX: ffffffffffff8800 RBX: ffffc90028d02000 RCX: fffffffffffe2000^M
RDX: 0000000000000282 RSI: ffff8800019c38a0 RDI: ffffc90028d02000^M
RBP: ffff88000e9dba90 R08: 00000000000000d2 R09: ffffffff810d27f1^M
R10: dead000000100100 R11: 0000000000000001 R12: fffffffffffe2000^M
R13: ffff8800019c3880 R14: ffff8800019c38a0 R15: 0000000002000000^M
FS:  0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000^M
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005007b^M
CR2: ffffc90030d02000 CR3: 0000000001604000 CR4: 00000000000006f0^M
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000^M
Process swapper (pid: 1, threadinfo ffff88000e9da000, task ffff88000e9e0000)^M
Stack:^M
 0000000008000000 0000000002000000 00000000000000a0 ffff8800019c3880^M
<0> 0000000000000282 000000000000000a ffff88000e9dbb30 ffffffff810d36cc^M
<0> 0000000000000004 0000000000000004 0000000400000000 ffffffffffffffff^M
Call Trace:^M
 [<ffffffff810d36cc>] pcpu_alloc+0x197/0x7e1^M
 [<ffffffff811ed846>] ? extract_entropy+0x4c/0x96^M
 [<ffffffff810d3d31>] __alloc_percpu+0xb/0xd^M
 [<ffffffff811925df>] __percpu_counter_init+0x25/0x76^M
 [<ffffffff811396a3>] ext2_fill_super+0xb7c/0xb98^M
 [<ffffffff810dce90>] ? sget+0x3ba/0x3ca^M
 [<ffffffff810dd25c>] get_sb_bdev+0x142/0x18e^M
 [<ffffffff81138b27>] ? ext2_fill_super+0x0/0xb98^M
 [<ffffffff811379df>] ext2_get_sb+0x13/0x15^M
 [<ffffffff810dc8f2>] vfs_kern_mount+0xaf/0x18f^M
 [<ffffffff810dca2f>] do_kern_mount+0x47/0xee^M
 [<ffffffff810f1524>] do_mount+0x6a5/0x742^M
 [<ffffffff810adf69>] ? strndup_user+0x39/0x50^M
 [<ffffffff810f1640>] sys_mount+0x7f/0xb8^M
...



---
 mm/percpu.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/mm/percpu.c
===================================================================
--- linux.orig/mm/percpu.c      2010-09-09 15:21:22.000000000 -0500
+++ linux/mm/percpu.c   2010-09-09 16:25:52.000000000 -0500
@@ -775,6 +775,7 @@ restart:
                        off = pcpu_alloc_area(chunk, size, align);
                        if (off >= 0)
                                goto area_found;
+                       goto restart;
                }
        }

