Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab2EDOuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:50:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34219 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757506Ab2EDOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:50:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mWFVO7ZXm3NBlGkwtdO3shGQM/9CpEiYrmmTTu2
	om1agKEfMNMC4a
Message-ID: <1336142995.25479.49.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 16:49:55 +0200
In-Reply-To: <m1vckcdoey.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <1336105676.7356.42.camel@marge.simpson.net>
	 <m1aa1oidmn.fsf@fess.ebiederm.org>
	 <1336124716.25479.36.camel@marge.simpson.net>
	 <m1vckcdoey.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 07:13 -0700, Eric W. Biederman wrote: 
> Mike Galbraith <efault@gmx.de> writes:
> 
> > On Fri, 2012-05-04 at 00:55 -0700, Eric W. Biederman wrote:
> >
> >> CLONE_NEWUSER?  I presume you have applied my latest user namespace
> >> patches?  Otherwise you are running completely half baked code.
> >
> > I Removed CLONE_NEWUSER flag.
> >
> >> hackbench?  Which kernel are you running.  Hackbench in some kernels is
> >> really good at triggering cache ping-pong effects with pids, and creds.
> >
> > Not when pinned.  3.0 kernel without the debug stuff enabled in 3.4.git.
> > 
> > marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench
> > Running with 10*40 (== 400) tasks.
> > Time: 0.868
> > marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace
> > Running with 10*40 (== 400) tasks.
> > Time: 7.582
> > marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace -all
> > Running with 10*40 (== 400) tasks.
> > Time: 29.677
> 
> Interesting.  I guess what truly puzzles me is what serializes all of
> the processes.  Even synchronize_rcu should sleep and thus let other
> synchronize_rcu calls run in parallel.
> 
> Did you have HZ=100 in that kernel?  400 tasks at 100Hz all serialized
> somehow and then doing synchronize_rcu at a jiffy each would account
> for 4 seconds.  And the nsproxy certainly has a synchronize_rcu call.

HZ=250

> The network namespace is comparatively heavy weight, at least in the
> amount of code and other things it has to go through, so that would be
> my prime suspect for those 29 seconds.  There are 2-4 synchronize_rcu
> calls needed to put the loopback device.  Still we use
> synchronize_rcu_expedited and that work should be out of line and all of
> those calls should batch.
> 
> Mike is this something you are looking at a pursuing farther?

Not really, but I can put it on my good intentions list.

> I want to guess the serialization comes from waiting on children to be
> reaped but the namespaces are all cleaned up in exit_notify() called
> from do_exit() so that theory doesn't hold water.  The worst case
> I can see is detach_pid from exit_signal running under the task list lock.
> but nothing sleeps under that lock.  :(

I'm up to my ears in zombies with several instances of the testcase
running in parallel, so I imagine it's the same with hackbench.

marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace& for i in 1 2 3 4 5 6 7 ; do ps ax|grep defunct|wc -l;sleep 1; done
[1] 29985
Running with 10*40 (== 400) tasks.
1
397
327
261
199
135
72
marge:/usr/local/tmp/starvation # Time: 7.675

-Mike

