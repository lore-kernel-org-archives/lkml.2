Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2JVSDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2JVSDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:03:38 -0400
Date: Mon, 22 Oct 2012 20:04:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called
	after the task is added to css_set
Message-ID: <20121022180445.GB21553@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-2-git-send-email-tj@kernel.org> <20121021191141.GA26218@redhat.com> <20121021192222.GB5951@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021192222.GB5951@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 10/21, Tejun Heo wrote:
>
> On Sun, Oct 21, 2012 at 09:11:41PM +0200, Oleg Nesterov wrote:
>
> > And it seems that fork() can race with cgroup iterator. post_fork
> > will notice use_task_css_set_links, but until then the child belongs
> > to the parent's css and it is not "visible" to iterator (and right
> > after cgroup_fork() it is not visible to do_each_thread() if
> > use_task_css_set_links is not set).
> >
> > For example. Suppose that the child migrates to another cgroup after
> > copy_process() makes it visible to the user-space. Then update_if_frozen
> > sets CGROUP_FROZEN (again, cgroup_iter_next do not see this child).
> >
> > Now, post_fork calls freezer_fork() and hits BUG_ON(CGROUP_FROZEN).
> >
> > But again, I do not blame this patch.
>
> I'm planning to update it to,
>
> * Clear ->cgroup to %NULL during copy_process().

I completely agree. new_child->cgroups copied from parent looks simply
strange until post_fork. If nothing else, the new task is still under
construction by the time cgroup_fork() is called.

> > I am starting to think again about a big-rw-lock around copy_process.
> > Recently I tried to add one around dup_mmap for uprobes, but perhaps
> > cgroups can use it too...
>
> If some other subsystems need it, maybe just make threadgroup locking
> coarser?

What do you mean?

> I *think* I can make cgroup work correctly without a agiant
> rwlock

Yes, probably cgroup doesn't really need it. Although we could probably
kill signal->group_rwsem, but this is minor and "write-lock" will be much
slower.

Oleg.

