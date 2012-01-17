Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2AQQKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:10:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30569 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2AQQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:10:38 -0500
Date: Tue, 17 Jan 2012 11:10:24 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: cfq crashing on boot with CONFIG_DEBUG_PAGE_ALLOC (linus master)
Message-ID: <20120117161024.GC30322@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020206.4F159D73.0124,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Looks like cfq is using stale pages, I'm getting crashes on boot with
CONFIG_DEBUG_PAGE_ALLOC enabled.  The oops leads to crashing in
cfqq_type, and if you add some fuzz for inlining, it looks like we're
here:

(gdb) list *cfq_insert_request+0x3f5
0xffffffff812683d8 is in cfq_insert_request (block/cfq-iosched.c:3131).
3126	
3127		/*
3128		 * workload type is changed, don't save slice, otherwise preempt
3129		 * doesn't happen
3130		 */
3131		if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
3132			cfqq->cfqg->saved_workload_slice = 0;
3133	
3134		/*
3135		 * Put the new queue at the front of the of the current list,

It seems like the most likely reason is that old_cfqq was previously
freed:

        struct cfq_queue *old_cfqq = cfqd->active_queue;

Hopefully Tejun or Jens can reproduce, I crash immediately on boot.
Fully oops:

BUG: unable to handle kernel paging request at ffff8800746c4f0c
IP: [<ffffffff81266d59>] cfqq_type+0xb/0x20
PGD 18d4063 PUD 1fe15067 PMD 1ffb9067 PTE 80000000746c4160
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
CPU 3
Modules linked in:

Pid: 1, comm: init Not tainted 3.2.0-josef+ #367 Bochs Bochs
RIP: 0010:[<ffffffff81266d59>]  [<ffffffff81266d59>] cfqq_type+0xb/0x20
RSP: 0018:ffff880079c11778  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880076f3df08 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffff880074271888 RDI: ffff8800746c4f08
RBP: ffff880079c11778 R08: 0000000000000078 R09: 0000000000000001
R10: 09f911029d74e35b R11: 09f911029d74e35b R12: ffff880076f337f0
R13: ffff8800746c4f08 R14: ffff8800746c4f08 R15: 0000000000000002
FS:  00007f62fd44f700(0000) GS:ffff88007cd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8800746c4f0c CR3: 0000000076c21000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff880079c10000, task ffff880079c0a040)
Stack:
 ffff880079c117c8 ffffffff812683d8 ffff880079c117a8 ffffffff8125de43
 ffff8800744fcf48 ffff880074b43e98 ffff8800770c8828 ffff880074b43e98
 0000000000000003 0000000000000000 ffff880079c117f8 ffffffff81254149
Call Trace:
 [<ffffffff812683d8>] cfq_insert_request+0x3f5/0x47c
 [<ffffffff8125de43>] ? blk_recount_segments+0x20/0x31
 [<ffffffff81254149>] __elv_add_request+0x1ca/0x200
 [<ffffffff8125aa99>] blk_queue_bio+0x2ef/0x312
 [<ffffffff81258f7b>] generic_make_request+0x9f/0xe0
 [<ffffffff8125907b>] submit_bio+0xbf/0xca
 [<ffffffff81136ec7>] submit_bh+0xdf/0xfe
 [<ffffffff81176d04>] ext3_bread+0x50/0x99
 [<ffffffff811785b3>] dx_probe+0x38/0x291
 [<ffffffff81178864>] ext3_dx_find_entry+0x58/0x219
 [<ffffffff81178ad5>] ext3_find_entry+0xb0/0x406
 [<ffffffff8110c4d5>] ? cache_alloc_debugcheck_after.isra.46+0x14d/0x1a0
 [<ffffffff8110cfbd>] ? kmem_cache_alloc+0xef/0x191
 [<ffffffff8117a330>] ext3_lookup+0x39/0xe1
 [<ffffffff81119461>] d_alloc_and_lookup+0x45/0x6c
 [<ffffffff8111ac41>] do_lookup+0x1e4/0x2f5
 [<ffffffff8111aef6>] link_path_walk+0x1a4/0x6ef
 [<ffffffff8111b557>] path_lookupat+0x59/0x5ea
 [<ffffffff8127406c>] ? __strncpy_from_user+0x30/0x5a
 [<ffffffff8111bce0>] do_path_lookup+0x23/0x59
 [<ffffffff8111cfd6>] user_path_at_empty+0x53/0x99
 [<ffffffff8107b37b>] ? remove_wait_queue+0x51/0x56
 [<ffffffff8111d02d>] user_path_at+0x11/0x13
 [<ffffffff811141f5>] vfs_fstatat+0x3a/0x64
 [<ffffffff8111425a>] vfs_stat+0x1b/0x1d
 [<ffffffff81114359>] sys_newstat+0x1a/0x33
 [<ffffffff81060e12>] ? task_stopped_code+0x42/0x42
 [<ffffffff815d6712>] system_call_fastpath+0x16/0x1b
Code: 89 e6 48 89 c7 e8 fa ca fe ff 85 c0 74 06 4c 89 2b 41 b6 01 5b 44 89 f0 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 66 66 66 66 90 31 c0 <8b> 57 04 f6 c6 01 74 0b 83 e2 20 83 fa 01 19 c0 83 c0 02 5d c3
RIP  [<ffffffff81266d59>] cfqq_type+0xb/0x20
 RSP <ffff880079c11778>
CR2: ffff8800746c4f0c
---[ end trace 60aa4e44bd00b68c ]---

