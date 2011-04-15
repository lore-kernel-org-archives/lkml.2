Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1DOUvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:51:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab1DOUvl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110415201652.GA5131@redhat.com>
References: <20110415201652.GA5131@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 13:49:04 -0700
Message-ID: <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
Subject: Re: hugetlb locking bug.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Adding the hugetlbfs/lockdep people to the cc.

This _looks_ like the same kind of false positive we've had with some
other cases: we're taking the i_mutex lock only dor directory inodes
(for the readdir) and we take the i_mmap lock only for non-directory
inodes, so you can't actually get any real circular locking issues.

So yes, we do mix the order of i_mmap_sem and i_mutex, but it's
conceptually two "different" kinds of i_mutex that just happen to
share a name.

And I really thought we annotated it as such with different
"lockdep_set_class()" cases (ie the whole

  lockdep_set_class(&inode->i_mutex,&type->i_mutex_dir_key);

for the S_ISDIR case in unlock_new_inode().

Can somebody more alert than me see why this lockdep issue still
triggers with hugetlbfs?

                         Linus

On Fri, Apr 15, 2011 at 1:16 PM, Dave Jones <davej@redhat.com> wrote:
> Just hit this lockdep report..
>
>        Dave
>
>  =======================================================
>  [ INFO: possible circular locking dependency detected ]
>  2.6.39-rc3+ #3
>  -------------------------------------------------------
>  trinity/11299 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#18){+.+.+.}, at: [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
>
>  but task is already holding lock:
>  (&mm->mmap_sem){++++++}, at: [<ffffffff81109097>] sys_mmap_pgoff+0xf8/0x16a
>
>  which lock already depends on the new lock.
>
>
>  the existing dependency chain (in reverse order) is:
>
>  -> #1 (&mm->mmap_sem){++++++}:
>        [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
>        [<ffffffff81100cd0>] might_fault+0x89/0xac
>        [<ffffffff8114159b>] filldir+0x6f/0xc7
>        [<ffffffff81150075>] dcache_readdir+0x67/0x204
>        [<ffffffff811417ed>] vfs_readdir+0x78/0xb1
>        [<ffffffff8114190c>] sys_getdents+0x7e/0xd1
>        [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b
>
>  -> #0 (&sb->s_type->i_mutex_key#18){+.+.+.}:
>        [<ffffffff810864e6>] __lock_acquire+0x99e/0xc81
>        [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
>        [<ffffffff814b9d00>] __mutex_lock_common+0x4c/0x35b
>        [<ffffffff814ba0d3>] mutex_lock_nested+0x3e/0x43
>        [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
>        [<ffffffff81108ac8>] mmap_region+0x26d/0x446
>        [<ffffffff81108f45>] do_mmap_pgoff+0x2a4/0x2fe
>        [<ffffffff811090b7>] sys_mmap_pgoff+0x118/0x16a
>        [<ffffffff8100c56c>] sys_mmap+0x22/0x24
>        [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b
>
>  other info that might help us debug this:
>
>  1 lock held by trinity/11299:
>  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81109097>] sys_mmap_pgoff+0xf8/0x16a
>
>  stack backtrace:
>  Pid: 11299, comm: trinity Not tainted 2.6.39-rc3+ #3
>  Call Trace:
>  [<ffffffff814b1126>] print_circular_bug+0xa6/0xb5
>  [<ffffffff810864e6>] __lock_acquire+0x99e/0xc81
>  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
>  [<ffffffff81086c59>] lock_acquire+0xd0/0xfb
>  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
>  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
>  [<ffffffff814b9d00>] __mutex_lock_common+0x4c/0x35b
>  [<ffffffff811ebfec>] ? hugetlbfs_file_mmap+0x7f/0x10d
>  [<ffffffff814b3ee2>] ? __slab_alloc+0xdb/0x3b7
>  [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
>  [<ffffffff814b3eeb>] ? __slab_alloc+0xe4/0x3b7
>  [<ffffffff81108a12>] ? mmap_region+0x1b7/0x446
>  [<ffffffff814ba0d3>] mutex_lock_nested+0x3e/0x43
>  [<ffffffff811ebfec>] hugetlbfs_file_mmap+0x7f/0x10d
>  [<ffffffff81108ac8>] mmap_region+0x26d/0x446
>  [<ffffffff81108f45>] do_mmap_pgoff+0x2a4/0x2fe
>  [<ffffffff811090b7>] sys_mmap_pgoff+0x118/0x16a
>  [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
>  [<ffffffff8100c56c>] sys_mmap+0x22/0x24
>  [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b
>
>
