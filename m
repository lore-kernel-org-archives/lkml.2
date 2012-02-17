Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2BQAQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab2BQAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:16:39 -0500
Date: Thu, 16 Feb 2012 19:16:34 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: tyhicks@canonical.com
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217001634.GH23550@zod.bos.redhat.com>
References: <20120217000856.GA13112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217000856.GA13112@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> Remember this ? https://lkml.org/lkml/2011/4/15/272
> Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> but it seems to still be there.

I think Tyler Hicks actually noticed this a while ago, but his patch has
been waiting on comment from Al and Christoph:

http://thread.gmane.org/gmane.linux.file-systems/58795/focus=59565

I've been hesitant to comment because I obviously screwed up once
already.  We could try this patch in Fedora for a while if Al and
company don't speak up soon.

josh

> 
> 	Dave
> 
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.3.0-rc3+ #2 Not tainted
> -------------------------------------------------------
> trinity/30663 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#18){+.+...}, at: [<ffffffff81298169>] hugetlbfs_file_mmap+0x89/0x140
> 
> but task is already holding lock:
>  (&mm->mmap_sem){++++++}, at: [<ffffffff81182d97>] sys_mmap_pgoff+0x1d7/0x230
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&mm->mmap_sem){++++++}:
>        [<ffffffff810d073d>] lock_acquire+0x9d/0x220
>        [<ffffffff811789c0>] might_fault+0x80/0xb0
>        [<ffffffff811d2997>] filldir+0x77/0xe0
>        [<ffffffff811e61ae>] dcache_readdir+0x5e/0x220
>        [<ffffffff811d2c68>] vfs_readdir+0xb8/0xf0
>        [<ffffffff811d2d99>] sys_getdents+0x89/0x100
>        [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> 
> -> #0 (&sb->s_type->i_mutex_key#18){+.+...}:
>        [<ffffffff810d0008>] __lock_acquire+0x1bf8/0x1c20
>        [<ffffffff810d073d>] lock_acquire+0x9d/0x220
>        [<ffffffff8169a5b9>] __mutex_lock_common+0x59/0x500
>        [<ffffffff8169ab94>] mutex_lock_nested+0x44/0x50
>        [<ffffffff81298169>] hugetlbfs_file_mmap+0x89/0x140
>        [<ffffffff811826a9>] mmap_region+0x369/0x4f0
>        [<ffffffff81182b9f>] do_mmap_pgoff+0x36f/0x390
>        [<ffffffff81182db7>] sys_mmap_pgoff+0x1f7/0x230
>        [<ffffffff8101eda2>] sys_mmap+0x22/0x30
>        [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&mm->mmap_sem);
>                                lock(&sb->s_type->i_mutex_key#18);
>                                lock(&mm->mmap_sem);
>   lock(&sb->s_type->i_mutex_key#18);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by trinity/30663:
>  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81182d97>] sys_mmap_pgoff+0x1d7/0x230
> 
> stack backtrace:
> Pid: 30663, comm: trinity Not tainted 3.3.0-rc3+ #2
> Call Trace:
>  [<ffffffff816924d7>] print_circular_bug+0x1fb/0x20c
>  [<ffffffff810d0008>] __lock_acquire+0x1bf8/0x1c20
>  [<ffffffff816a1c2d>] ? sub_preempt_count+0x9d/0xd0
>  [<ffffffff811a40cc>] ? deactivate_slab+0x54c/0x5f0
>  [<ffffffff810d073d>] lock_acquire+0x9d/0x220
>  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
>  [<ffffffff810d12fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
>  [<ffffffff8169a5b9>] __mutex_lock_common+0x59/0x500
>  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
>  [<ffffffff811825e5>] ? mmap_region+0x2a5/0x4f0
>  [<ffffffff81298169>] ? hugetlbfs_file_mmap+0x89/0x140
>  [<ffffffff8169ab94>] mutex_lock_nested+0x44/0x50
>  [<ffffffff81298169>] hugetlbfs_file_mmap+0x89/0x140
>  [<ffffffff811826a9>] mmap_region+0x369/0x4f0
>  [<ffffffff812c1e9a>] ? file_map_prot_check+0xaa/0xe0
>  [<ffffffff81182b9f>] do_mmap_pgoff+0x36f/0x390
>  [<ffffffff81182d97>] ? sys_mmap_pgoff+0x1d7/0x230
>  [<ffffffff81182db7>] sys_mmap_pgoff+0x1f7/0x230
>  [<ffffffff810d12fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
>  [<ffffffff8101eda2>] sys_mmap+0x22/0x30
>  [<ffffffff816a5b69>] system_call_fastpath+0x16/0x1b
> 
