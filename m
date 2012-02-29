Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2B2QWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:22:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61058 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab2B2QWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:22:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.180.100.196 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Wed, 29 Feb 2012 17:21:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH v2] cgroups: Run subsystem fork callback from
 cgroup_post_fork()
Message-ID: <20120229162148.GA8375@somewhere.redhat.com>
References: <1330057410-9375-1-git-send-email-fweisbec@gmail.com>
 <1330362171-30697-1-git-send-email-fweisbec@gmail.com>
 <20120229155500.GU3090@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229155500.GU3090@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 07:55:00AM -0800, Mandeep Singh Baines wrote:
> Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > When a user freezes a cgroup, the freezer sets the subsystem state
> > to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> > 
> > But there is a possible race here, although unlikely, if a task
> > forks and the parent is preempted between write_unlock(tasklist_lock)
> > and cgroup_post_fork(). If we freeze the cgroup while the parent
> 
> So what if you moved cgroup_post_forks() a few lines up to be
> inside the tasklist_lock?

It won't work. Consider this scenario:

CPU 0                                     CPU 1

                                       cgroup_fork_callbacks()
                                       write_lock(tasklist_lock)
try_to_freeze_cgroup() {               add child to task list etc...
	cgroup_iter_start()
        freeze tasks                        
        cgroup_iter_end()
}                                      cgroup_post_fork()
                                       write_unlock(tasklist_lock)

If this is not the first time we call cgroup_iter_start(), we won't go
through the whole tasklist, we simply iterate through the css set task links.

Plus we try to avoid anything under tasklist_lock when possible.


> 
> I agree with you on the race and believe your solution is correct.
> 
> > is sleeping and the parent wakes up thereafter, its child will
> > be missing from the set of tasks to freeze because:
> > 
> > - The child was not yet linked to its css_set->tasks, as is done
> > from cgroup_post_fork(). cgroup_iter_start() has thus missed it.
> > 
> > - The cgroup freezer's fork callback can handle that child but
> > cgroup_fork_callbacks() has been called already.
> > 
> > One way to fix this is to call the fork callbacks after we link
> > the task to the css set. The cgroup freezer is the only user of
> > this callback anyway.
> > 
> > v2: Keep the call to cgroup_exit to put the css_set on fork error.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Mandeep Singh Baines <msb@chromium.org>
> > ---
> > 
> > Not sure this is the right solution, especially as I still need
> > a cancellable fork callback for my task counter and for this I
> > need the fork callbacks to be called before the task is added
> > on the tasklist. But anyway at least that reports this race.
> > 
> 
> I'm new to the task counter stuff. Would you mind providing a
> reference.

Sure, have a look at this:

https://lkml.org/lkml/2012/1/31/489

Especially this patch:
https://lkml.org/lkml/2012/1/31/495

And this one that implements a fork callback:
https://lkml.org/lkml/2012/1/31/497

The fork callback may return an error to cancel the fork. But doing
this at cgroup_post_fork() time is too late.
