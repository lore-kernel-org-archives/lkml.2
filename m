Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2JRNeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:34:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2JRNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:34:00 -0400
Date: Thu, 18 Oct 2012 14:33:53 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: cwillu <cwillu@cwillu.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com
Subject: Re: [tip:sched/core] sched: Fix race in task_group()
Message-ID: <20121018133353.GA25885@hercules>
References: <1340364965.18025.71.camel@twins>
 <tip-8323f26ce3425460769605a6aece7a174edaa7d1@git.kernel.org>
 <CAE5mzvjPXAZdOi1p8AB47zOQzgAErBU66gAS8spnpOs+=-+azA@mail.gmail.com>
 <507FD8AA.50500@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507FD8AA.50500@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:23:38PM +0200, Stefan Bader wrote:
> On 18.10.2012 10:27, cwillu wrote:
> > On Tue, Jul 24, 2012 at 8:21 AM, tip-bot for Peter Zijlstra
> > <peterz@infradead.org> wrote:
> >> Commit-ID:  8323f26ce3425460769605a6aece7a174edaa7d1
> >> Gitweb:     http://git.kernel.org/tip/8323f26ce3425460769605a6aece7a174edaa7d1
> >> Author:     Peter Zijlstra <peterz@infradead.org>
> >> AuthorDate: Fri, 22 Jun 2012 13:36:05 +0200
> >> Committer:  Ingo Molnar <mingo@kernel.org>
> >> CommitDate: Tue, 24 Jul 2012 13:58:20 +0200
> >>
> >> sched: Fix race in task_group()
> >>
> >> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched:
> >> Don't call task_group() too many times in set_task_rq()"), he
> >> found the reason to be that the multiple task_group()
> >> invocations in set_task_rq() returned different values.
> >>
> >> Looking at all that I found a lack of serialization and plain
> >> wrong comments.
> >>
> >> The below tries to fix it using an extra pointer which is
> >> updated under the appropriate scheduler locks. Its not pretty,
> >> but I can't really see another way given how all the cgroup
> >> stuff works.
> >>
> >> Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
> >> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Link: http://lkml.kernel.org/r/1340364965.18025.71.camel@twins
> >> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > 
> > I just finished bisecting a crash on boot to this commit; booting with
> > "noautogroup" brings it back.
> > 
> > 3.5.4 is the latest -stable that still boots, and none of the 3.6 rc's
> > boot at all.
> > 
> > Photo of the bug (3.6.0next is 3.6 + btrfs's for-linus):
> > https://lh5.googleusercontent.com/-0DY-YYhgvzs/UHdB-BQdzMI/AAAAAAAAAEg/QhY9rgxnv98/s811/2012-10-11
> > 
> 
> On a very quick glance I wonder whether there might be a case where sched_fork
> goes into set_task_cpu with a different cpu than the current but has not yet
> task_group.sched_task_group set to something valid...
> 
> 

I was looking at another bug report [1] which may be related with this
issue.  Basically, it looks like there is a race window where
resetting sched_autogroup_enabled will cause a crash on
shutdown/reboot.  In the bug report, the user has added:

echo 0 > /proc/sys/kernel/sched_autogroup_enabled

to /etc/rc.local.  This will cause a NULL pointer dereference during
shutdown (and it is reproducible with mainline kernel 3.7.0-rc1).

By using the kernel parameter noautogroup I *wasn't* able to reproduce
this issue.

After a little bit of digging, commit
800d4d30c8f20bd728e5741a3b77c4859a613f7c ("sched, autogroup: Stop
going ahead if autogroup is disabled") caught my attention as it
changes the following code path when sched_autogroup_enabled is
disabled:

    sched_autogroup_create_attach()
      autogroup_move_group()
        sched_move_task()          <<-- conditionally invoked
          task_move_group_fair()
            set_task_rq()
              task_group()
                autogroup_task_group()

And commit 8323f26ce3425460769605a6aece7a174edaa7d1 ("sched: Fix
race in task_group()") actually adds code to this conditional path (in
sched_move_task()).

A quick test shows that reverting
800d4d30c8f20bd728e5741a3b77c4859a613f7c (i.e., always going through
the whole call tree) seems to fix it or, at least, doesn't trigger the
NULL pointer.  But again, I may just be doing something foolish,
hiding something else.  It is also possible that this is a completely
different issue.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1055222

Cheers,
--
Luis
