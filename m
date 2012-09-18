Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2IROfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab2IROfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:35:08 -0400
Date: Tue, 18 Sep 2012 10:35:04 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: 3.6rc6 slab corruption.
Message-ID: <20120918143504.GA30585@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was chasing a networking bug, and had trinity reduced to just making read & setsockopt calls,
and let that run overnight.  I woke up to 800mb of traces from a different bug..

The traces look mostly like this..


=============================================================================
BUG kmalloc-64 (Not tainted): Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88001f4b4970-0xffff88001f4b4977. First byte 0xbb instead of 0xcc 
INFO: Allocated in u32_array_read+0xd1/0x110 age=0 cpu=6 pid=32767
        __slab_alloc+0x516/0x5a5
        __kmalloc+0x213/0x2c0
        u32_array_read+0xd1/0x110
        vfs_read+0xac/0x180
        sys_read+0x4d/0x90
        system_call_fastpath+0x1a/0x1f
INFO: Freed in u32_array_read+0x99/0x110 age=0 cpu=0 pid=32749
        __slab_free+0x3f/0x3bf
        kfree+0x2d5/0x310
        u32_array_read+0x99/0x110
        vfs_read+0xac/0x180
        sys_read+0x4d/0x90
        system_call_fastpath+0x1a/0x1f
INFO: Slab 0xffffea00007d2d00 objects=41 used=14 fp=0xffff88001f4b7410 flags=0x10000000004081
INFO: Object 0xffff88001f4b4930 @offset=2352 fp=0xffff88001f4b7410

Bytes b4 ffff88001f4b4920: 1b 20 1c 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  . ......ZZZZZZZZ
Object ffff88001f4b4930: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88001f4b4940: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88001f4b4950: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88001f4b4960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
Redzone ffff88001f4b4970: bb bb bb bb bb bb bb bb                          ........
Padding ffff88001f4b4ab0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
Pid: 32756, comm: trinity-child52 Not tainted 3.6.0-rc6+ #44
Call Trace:
 [<ffffffff811c10ad>] ? print_section+0x3d/0x40
 [<ffffffff811c23fe>] print_trailer+0xfe/0x160
 [<ffffffff811c2592>] check_bytes_and_report+0xe2/0x120
 [<ffffffff81023b79>] ? native_sched_clock+0x19/0x80
 [<ffffffff811c2b5b>] check_object+0x18b/0x250
 [<ffffffff8169b7d7>] free_debug_processing+0xc0/0x1fd
 [<ffffffff812d2e29>] ? u32_array_read+0x99/0x110
 [<ffffffff8169ba5c>] __slab_free+0x3f/0x3bf
 [<ffffffff81365a1c>] ? debug_check_no_obj_freed+0x16c/0x210
 [<ffffffff810db04f>] ? lock_release_holdtime.part.26+0xf/0x180
 [<ffffffff812d2e29>] ? u32_array_read+0x99/0x110
 [<ffffffff811c5725>] kfree+0x2d5/0x310
 [<ffffffff812d2e29>] u32_array_read+0x99/0x110
 [<ffffffff811df88c>] vfs_read+0xac/0x180
 [<ffffffff811df9ad>] sys_read+0x4d/0x90
 [<ffffffff816aea2d>] system_call_fastpath+0x1a/0x1f
FIX kmalloc-64: Restoring 0xffff88001f4b4970-0xffff88001f4b4977=0xcc
=============================================================================

Which looks like we read some file (probably something in sysfs/procfs) that corrupted some internal state.
Any ideas on what I could do to narrow this down ?

The full traces are at http://www.codemonkey.org.uk/junk/slab-corrupt.txt
They vary a little later, but it looks like it's probably all the same problem to me.
Sometimes it flip-flops between "First byte 0xbb instead of 0xcc" and "First byte 0xcc instead of 0xbb"


The one outlier being this weird message..

Sep 18 02:00:13 bitcrush kernel: [36617.487681] hrtimer: interrupt took 242337 ns

Which is weird, but probably unrelated.

	Dave

