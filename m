Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2JUTKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab2JUTKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:10:36 -0400
Date: Sun, 21 Oct 2012 21:11:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called
	after the task is added to css_set
Message-ID: <20121021191141.GA26218@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426526-14254-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Tejun Heo wrote:
>
> cgroup_subsys->fork() is invoked way before the new task is added to
> the css_set.

Plus, it called before this task (and even its task_struct) was fully
initialized.

All I can say is: personally I like this patch, it also simplifies
copy_process().

But I am in no position to ack it. I seem to forget everything (not
too much ;) I ever knew about this code.



A couple of off-topic questions. With or without this patch I do not
understand cgroup_fork,

	/*
	 * We don't need to task_lock() current because current->cgroups
	 * can't be changed concurrently here. The parent obviously hasn't
	 * exited and called cgroup_exit(), and we are synchronized against
	 * cgroup migration through threadgroup_change_begin().
	 */
	child->cgroups = current->cgroups;
	get_css_set(child->cgroups);

How so? threadgroup_change_begin() is only called if CLONE_THREAD.
So in theory this copy + atomic_add looks racy...




And it seems that fork() can race with cgroup iterator. post_fork
will notice use_task_css_set_links, but until then the child belongs
to the parent's css and it is not "visible" to iterator (and right
after cgroup_fork() it is not visible to do_each_thread() if
use_task_css_set_links is not set).

For example. Suppose that the child migrates to another cgroup after
copy_process() makes it visible to the user-space. Then update_if_frozen
sets CGROUP_FROZEN (again, cgroup_iter_next do not see this child).

Now, post_fork calls freezer_fork() and hits BUG_ON(CGROUP_FROZEN).

But again, I do not blame this patch.


I am starting to think again about a big-rw-lock around copy_process.
Recently I tried to add one around dup_mmap for uprobes, but perhaps
cgroups can use it too...

Oleg.

