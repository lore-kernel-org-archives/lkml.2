Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2EDIfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:35:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60032 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752051Ab2EDIe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:34:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SA35I5Q7Sr6SQqs04eR/2kmpo1Ia8Nvka4JUGo7
	dSV8WUL4IRLCec
Message-ID: <1336120490.25479.20.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 10:34:50 +0200
In-Reply-To: <m1aa1oidmn.fsf@fess.ebiederm.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 00:55 -0700, Eric W. Biederman wrote: 
> Mike Galbraith <efault@gmx.de> writes:
> 
> > Namespaces have something in common with cgroups.  synchronize_rcu()
> > makes them somewhat less than wonderful for dynamic use.
> 
> Well unlike cgroups namespaces were not designed for heavy dynamic use.
> Although it appears that vsftp puts them to that kind of use so some
> of the design decisions are with revisiting.

Yeah, the testcase was distilled from vsftp, so it must be beating on
namespaces pretty hard to induce a bug report.

> > default flags = SIGCHLD
> >
> > -namespace:  flag |= CLONE_NEWPID 
> > -all:  flags |= CLONE_NEWIPC | CLONE_NEWNET | CLONE_NEWUSER
> >
> > marge:/usr/local/tmp/starvation # ./hackbench
> > Running with 10*40 (== 400) tasks.
> > Time: 2.636
> > marge:/usr/local/tmp/starvation # ./hackbench -namespace
> > Running with 10*40 (== 400) tasks.
> > Time: 11.624
> > marge:/usr/local/tmp/starvation # ./hackbench -namespace -all
> > Running with 10*40 (== 400) tasks.
> > Time: 51.474
> 
> CLONE_NEWUSER?  I presume you have applied my latest user namespace
> patches?  Otherwise you are running completely half baked code.

I was testing in mainline.  While fiddling with the testcase and leakage
monitor script, I decided to see what happens with all namespace flags.
The others didn't cause any leakage, but did make things slow down.

> hackbench?  Which kernel are you running.  Hackbench in some kernels is
> really good at triggering cache ping-pong effects with pids, and creds.
> So I'm not certain what to say there.  In the latest kernels things
> should be better with unix domain sockets as long as you don't actually
> ask to pass your creds but hackbench is still a pretty ridiculous
> benchmark.  Oversharing is always going to be bad for performance.

Hackbench was just to show the price of hefty namespace usage.

> > You can create trash quickly, but you have to haul it away.
> 
> Well synchronize_rcu is much better in that respect than call_rcu, which
> let's the trash build up but is never carried away.
> 
> The core design assumption with namespaces is that they will be used
> much more than they will be created/destroyed, and as long as there are
> progress guarantees in place I don't have a problem with that.   At the
> same time if there are easy things we can do to make things go faster
> I am in favor of that notion.
> 
> Still especially in the case of hackbench I think it is worth asking the
> question how much of the slow down is due to cache ping-pong due to
> oversharing.

Dunno, and doubt I'll have time to tinker with it more.  Darn bugzilla
thing keeps knocking on my mailbox with interesting bugs in places I
know _diddly spit_ about.. like namespaces.

-Mike

