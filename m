Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1DOURb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1DOURa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:17:30 -0400
Date: Fri, 15 Apr 2011 16:16:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: hugetlb locking bug.
Message-ID: <20110415201652.GA5131@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this lockdep report..

	Dave

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.39-rc3+ #3
 -------------------------------------------------------
 trinity/11299 is trying to acquire lock:
  (&sb->s_type->i_mutex_key#18){+.+.+.}, at: [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
 
 but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff81109097>] sys_mmap_pgoff+0xf8/0x16a
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (&mm->mmap_sem){++++++}:
        [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
        [<ffffffff81100cd0>] might_fault+0x89/0xac
        [<ffffffff8114159b>] filldir+0x6f/0xc7
        [<ffffffff81150075>] dcache_readdir+0x67/0x204
        [<ffffffff811417ed>] vfs_readdir+0x78/0xb1
        [<ffffffff8114190c>] sys_getdents+0x7e/0xd1
        [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b
 
 -> #0 (&sb->s_type->i_mutex_key#18){+.+.+.}:
        [<ffffffff810864e6>] __lock_acquire+0x99e/0xc81
        [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
        [<ffffffff814b9d00>] __mutex_lock_common+0x4c/0x35b
        [<ffffffff814ba0d3>] mutex_lock_nested+0x3e/0x43
        [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
        [<ffffffff81108ac8>] mmap_region+0x26d/0x446
        [<ffffffff81108f45>] do_mmap_pgoff+0x2a4/0x2fe
        [<ffffffff811090b7>] sys_mmap_pgoff+0x118/0x16a
        [<ffffffff8100c56c>] sys_mmap+0x22/0x24
        [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
 1 lock held by trinity/11299:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81109097>] sys_mmap_pgoff+0xf8/0x16a
 
 stack backtrace:
 Pid: 11299, comm: trinity Not tainted 2.6.39-rc3+ #3
 Call Trace:
  [<ffffffff814b1126>] print_circular_bug+0xa6/0xb5
  [<ffffffff810864e6>] __lock_acquire+0x99e/0xc81
  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
  [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
  [<ffffffff814b9d00>] __mutex_lock_common+0x4c/0x35b
  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
  [<ffffffff814b3ee2>] ? __slab_alloc+0xdb/0x3b7
  [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
  [<ffffffff814b3eeb>] ? __slab_alloc+0xe4/0x3b7
  [<ffffffff81108a12>] ? mmap_region+0x1b7/0x446
  [<ffffffff814ba0d3>] mutex_lock_nested+0x3e/0x43
  [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
  [<ffffffff81108ac8>] mmap_region+0x26d/0x446
  [<ffffffff81108f45>] do_mmap_pgoff+0x2a4/0x2fe
  [<ffffffff811090b7>] sys_mmap_pgoff+0x118/0x16a
  [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
  [<ffffffff8100c56c>] sys_mmap+0x22/0x24
  [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b

