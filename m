Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0EaB5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:57:13 -0400
Received: from ip-70-38-54-39.static.privatedns.com ([70.38.54.39]:37776 "EHLO
	ginevra.hungrycats.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755317Ab0EaB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:57:12 -0400
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
Date: Sun, 30 May 2010 21:57:10 -0400
From: Zygo Blaxell <vger-linux-omap-esightcorp@mailtoo.hungrycats.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100531015710.GA24917@gibbs.hungrycats.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
 <20100527220949.GB10602@srcf.ucam.org>
 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
 <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
 <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 10:17:55AM +0100, Alan Cox wrote:
> > Android does not only run on phones. It is possible that no android
> > devices have ACPI, but I don't know that for a fact. What I do know is
> > that people want to run Android on x86 hardware and supporting suspend
> > could be very benficial.
> 
> Sufficently beneficial to justify putting all this stuff all over the
> kernel and apps ? That is a *very* high hurdle, doubly so when those
> vendors who have chosen to be part of the community are shipping phones
> and PDAs just fine without them.

I'm not sure "other people are shipping without them" is such a good
metric, especially for scheduler features.  For some reason (I have some
ideas what it might be, but I won't speculate here) people don't like
messing with the scheduler in mainline, even though there's a lot of
special cases where a bit of messing with the scheduler (or replacing
it outright) goes a long way toward qualitatively improving performance
on some workloads.

I'd love to have several more ways to have large classes of processes stop
executing, and stay stopped, even though traditional Unix and mainline
Linux would try to run them.  I don't want to put knowledge of this into
every application I run since there are literally thousands of them,
and IMNSHO it's not even an application's responsibility to know this
kind of thing.  The "sort" program can't know what QoS to ask for in any
sane system design.  The best it can do is try to execute as hard as it
can whenever the kernel lets it, and have some other application advise
the kernel about how much or how little service (including cases like
"no service at all") the sort program should get from the system.

To choose a random example, I'd like a "duty cycle" constraint on
process execution (i.e. a runnable task must execute between L and M ns
per N ns interval--stealing slices from lower priority processes if it
doesn't get enough and isn't blocked on I/O, and leaving the CPU idle even
though the process is runnable if it gets too much).  I usually want to
apply this kind of limit to programs like Firefox, because Firefox is a)
big enough that controlling it actually matters for power consumption,
b) sensitive enough to user interaction latency that I want it to have
fairly high CPU priority when it has something to do, and c) big and
complex enough that I wouldn't want to try to adjust its behavior by
modifying its source.  Also, Firefox's behavior tends to be driven by
the data it pulls from random web sites, over which I have no control
whatsoever, and many of them are intentionally wasteful.

I'm not willing to run a non-mainline kernel (or Firefox, for that
matter) just to get that feature, and I'm not willing to submit patches
to mainline if I've seen nearly identical ideas rejected recently, so I
live without the feature for now.  This implies that the statistic for
"people running desirable scheduler features" is at least one lower than
the statistic for "people who would use desirable scheduler features if
they didn't have to hack up non-mainline kernels to get them."

I can hack up something that does something similar to duty cycle in
user-space, but it's got a lot of problems:

	- when you send SIGSTOP/SIGCONT to a process, it wakes up its
	parent through waitpid() (well, you can partially get around
	this with ptrace(), but that raises other issues),

	- it's racy wrt fork(),

	- it can't opportunistically schedule process execution,
	e.g. during times when the CPU is idle at high clock rates,

	- sufficiently badly behaved processes are able to escape
	the CPU usage regulation mechanism, and

	- estimating how much global CPU has been used as a percentage of
	real time is easy, but how much CPU relative to other processes
	running on the system is not.  I keep doing math like "subtract
	aggregate process CPU usage from global CPU usage" and getting
	numbers outside the range of 0..100% of global CPU usage.

Also, for non-trivial cases, the user-space CPU management process
consumes more CPU than any other process on the system, and keeps waking
up the CPU every N and M ns, even if the process being scheduled isn't
runnable.  

Simply providing better information to userspace to help a regulator
application of this kind would be a huge leap in the right direction.

Arguably I could run the applications I want to throttle under KVM,
and hack up the KVM to manage the CPU usage; however, that's hardly
transparent to the application, which is now running on the wrong machine
for a lot of what it wants to do.

So instead of fixing the software, I have an extra-large third-party
battery on my laptop.  It's a cheaper solution on small (one user) scales.
I can't ship a competitive product with that kind of problem, though.

Having said all that, I'm fairly sure suspend blockers aren't the way to
get it.  I'd much rather have interesting QoS constraint features,
including new conditions under which to not run otherwise runnable tasks.
Maybe ionice and SCHED_IDLEPRIO on steroids?

