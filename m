Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2KFUt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:49:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab2KFUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:49:56 -0500
Date: Tue, 6 Nov 2012 15:49:47 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: sched_debug / traverse allocation failures.
Message-ID: <20121106204947.GA1762@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fuzz-testing, I frequently run into this..

trinity-child4: page allocation failure: order:4, mode:0x40d0
Pid: 21842, comm: trinity-child4 Not tainted 3.7.0-rc4+ #54
Call Trace:
 [<ffffffff81179ce9>] warn_alloc_failed+0xe9/0x150
 [<ffffffff816c24fc>] ? __alloc_pages_direct_compact+0x1f8/0x209
 [<ffffffff8117e6f6>] __alloc_pages_nodemask+0x936/0xb60
 [<ffffffff811c2020>] alloc_pages_current+0xb0/0x120
 [<ffffffff81178ada>] __get_free_pages+0x2a/0x80
 [<ffffffff811ce299>] kmalloc_order_trace+0x39/0x190
 [<ffffffff811ce66d>] __kmalloc+0x27d/0x2b0
 [<ffffffff8120cc8d>] traverse+0x1bd/0x230
 [<ffffffff8120d0c0>] ? seq_lseek+0x120/0x120
 [<ffffffff8120d0c0>] ? seq_lseek+0x120/0x120
 [<ffffffff8120d41b>] seq_read+0x35b/0x3e0
 [<ffffffff816d1969>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff8120d0c0>] ? seq_lseek+0x120/0x120
 [<ffffffff81257890>] proc_reg_read+0x80/0xc0
 [<ffffffff811e72dc>] vfs_read+0xac/0x180
 [<ffffffff811e758a>] sys_pread64+0x9a/0xb0
 [<ffffffff816d5f88>] tracesys+0xe1/0xe6


I added some instrumentation to traverse, and it appears that the /proc file
in question is 'sched_debug'.

Most the time this is quite small, but can grow to large lengths it seems,
which when we're under memory fragmentation results in the spew above.

>From my reading of the code, it doesn't actually use the seq_operations,
to print out things record-at-a-time, but just dumps everything
in its ->open routine.

thoughts?

	Dave

