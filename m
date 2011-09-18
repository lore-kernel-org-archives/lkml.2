Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1IRSua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab1IRSu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:50:29 -0400
Date: Sun, 18 Sep 2011 20:46:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>,
        Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
	exit and exec
Message-ID: <20110918184613.GA6159@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-4-git-send-email-htejun@gmail.com> <20110918173723.GA2384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918173723.GA2384@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Oleg Nesterov wrote:
>
> Of course I am in no position to ack the changes in this code, I do not
> fell I understand it enough. But afaics this series is fine.
  ^^^^
I do not feel ;)

> If I am right, afaics the only change 4/4 needs is that it should not add
> WARN_ON_ONCE(tsk->flags & PF_EXITING) into cgroup_task_migrate().

Hmm. Unless I missed something this WARN_ON_ONCE() is not right anyway,
because

> - * Call holding cgroup_mutex. May take task_lock of
> - * the task 'tsk' during call.
> + * Call with cgroup_mutex and threadgroup locked. May take task_lock of
> + * @tsk during call.
>   */
>  int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)

this is not true, cgroup_attach_proc() has other callers.

cgroup_attach_task_all() is probably fine, tsk should be current.

but cpuset_do_move_task() doesn't look fine at first glance, we can race
with the exiting task.

And this leads to another question about the cgroup_mutex/threadgroup_lock
nesting...

Oleg.

