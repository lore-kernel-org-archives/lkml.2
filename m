Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2DTOSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:18:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:45255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2DTOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:18:11 -0400
Date: Fri, 20 Apr 2012 16:18:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <4F916AF3.7020301@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1204201602330.2542@ionos>
References: <20120420122120.097464672@linutronix.de> <4F916AF3.7020301@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Srivatsa S. Bhat wrote:
> > This first part moves the idle thread management for non-boot cpus
> > into the core. fork_idle() is called in a workqueue as it is
> > implemented in a few architectures already. This is necessary when not
> > all cpus are brought up by the early boot code as otherwise we would
> > take a ref on the user task VM of the thread which brings the cpu up
> > via the sysfs interface.
> > 
> 
> 
> Do you have a git tree where you have made these patches available?
> That would be pretty useful, so that we can build on whatever you have

Not yet, but I'll stick that into a tip/ branch.

> already done.. Myself and Nikunj had some initial design/ideas on reducing
> the duplication in architecture code, related to managing the setting
> of the cpu in the online mask, sending out CPU_STARTING notifiers etc
> from generic code..

The whole notifier business needs a redesign as well, because we don't
have a way to express proper dependencies, we add random notifier
points and the teardown path is ass backwards. The whole thing wants
to be a tree which can be walked in either direction and from any
point. Right now we cut the trunk first and keep the single limb up
with a helicopter and start dismantling it.

Flat notifiers are not working for this as they do not allow a tree
structure and prevent us to do things in parallel.

That really needs to be completely reworked. There is also a lot of
stuff which wants to be moved into the starting/dying CPU
context. Right now we kinda do that by trampling on the CPU with a
high prio stomper thread, but that's really just a bandaid and steady
cause of trouble.

If you look at facilities which use kthreads, then there is lots other
setup which does not need a notifier at all, as it can be done in the
context of the thread when we have a way to start/park those threads
at the right time in the up/down process.

I've already done a prototype for kthread park/unpark and converted
softirq over to use it. That makes the complete softirq notifier go
away and let the core code handle the thread creation / start / park /
unpark. It's pretty hacky right now, but I'm going to push on this
next, once I have a better idea how to express the dependency tree.

Thanks,

	tglx
