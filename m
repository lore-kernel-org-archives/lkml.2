Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2JUTW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:22:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39250 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2JUTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:22:27 -0400
Date: Sun, 21 Oct 2012 12:22:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
Message-ID: <20121021192222.GB5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-2-git-send-email-tj@kernel.org>
 <20121021191141.GA26218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021191141.GA26218@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sun, Oct 21, 2012 at 09:11:41PM +0200, Oleg Nesterov wrote:
> A couple of off-topic questions. With or without this patch I do not
> understand cgroup_fork,
> 
> 	/*
> 	 * We don't need to task_lock() current because current->cgroups
> 	 * can't be changed concurrently here. The parent obviously hasn't
> 	 * exited and called cgroup_exit(), and we are synchronized against
> 	 * cgroup migration through threadgroup_change_begin().
> 	 */
> 	child->cgroups = current->cgroups;
> 	get_css_set(child->cgroups);
> 
> How so? threadgroup_change_begin() is only called if CLONE_THREAD.
> So in theory this copy + atomic_add looks racy...

It's a bug.  Revert patches to restore task_lock() are already queued
in cgroup/for-3.7-fixes.

> And it seems that fork() can race with cgroup iterator. post_fork
> will notice use_task_css_set_links, but until then the child belongs
> to the parent's css and it is not "visible" to iterator (and right
> after cgroup_fork() it is not visible to do_each_thread() if
> use_task_css_set_links is not set).
> 
> For example. Suppose that the child migrates to another cgroup after
> copy_process() makes it visible to the user-space. Then update_if_frozen
> sets CGROUP_FROZEN (again, cgroup_iter_next do not see this child).
> 
> Now, post_fork calls freezer_fork() and hits BUG_ON(CGROUP_FROZEN).
> 
> But again, I do not blame this patch.

I'm planning to update it to,

* Clear ->cgroup to %NULL during copy_process().  A new task isn't
  considered to be cgroup-wise active at this point.  Userland is not
  allowed to migrate it and none of cgroup callbacks will be called.

* Do all the initialization in post_fork so that a task is only allowd
  to be migrated and operated on cgroup-wise after ->fork() is
  complete.

> I am starting to think again about a big-rw-lock around copy_process.
> Recently I tried to add one around dup_mmap for uprobes, but perhaps
> cgroups can use it too...

If some other subsystems need it, maybe just make threadgroup locking
coarser?  I *think* I can make cgroup work correctly without a agiant
rwlock there but if someone else needs it we can definitely hitch.

Thanks.

--
tejun
