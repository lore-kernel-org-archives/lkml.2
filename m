Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab0FBOJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab0FBOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:09:39 -0400
Date: Wed, 2 Jun 2010 16:06:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100602140659.GA5324@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com> <20100531180446.GA16249@redhat.com> <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Paul Menage wrote:
>
> On Mon, May 31, 2010 at 11:04 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > And, forgot to mention, I do not understand the PF_EXITING check in
> > attach_task_by_pid() (and some others).
> >
> > At first glance, it buys nothing. PF_EXITING can be set right after
> > the check.
>
> It can, but it's a benign race.

Yes,

> Moving a non-current thread into a cgroup takes task->alloc_lock and
> checks for PF_EXITING before manipulating that thread's cgroup links.
> The exit procedure sets PF_EXITING and then (somewhat later, but
> guaranteed) moves current to the root cgroups while holding
> alloc_lock.

Yes sure, I understand this part. cgroup_attach_task() correctly checks
PF_EXITING under task_lock(), this protects from the case when this
task has already passed cgroup_exit() which takes this lock too.

But. This exactly means that the PF_EXITING check in attach_task_by_pid()
is not necessary from the correctness pov (while probably can be considered
as optimization), right?

And,

> so it's fine to refuse to move it to a new cgroup.

I am not sure. It doesn't hurt when we try to move a thread. But if
we want to move the whole thread group, we should proceed even if the
group leader has already exited and thus has PF_EXITING bit set.

That was my question.

Oleg.

