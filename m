Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2EUIZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:25:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:58028 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2EUIZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:25:27 -0400
Date: Mon, 21 May 2012 10:25:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <871ume48ds.fsf@rustcorp.com.au>
Message-ID: <alpine.LFD.2.02.1205211013440.3231@ionos>
References: <20120420122120.097464672@linutronix.de> <4F916AF3.7020301@linux.vnet.ibm.com> <alpine.LFD.2.02.1204201602330.2542@ionos> <871ume48ds.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Rusty Russell wrote:

> On Fri, 20 Apr 2012 16:18:04 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 20 Apr 2012, Srivatsa S. Bhat wrote:
> > The whole notifier business needs a redesign as well, because we don't
> > have a way to express proper dependencies, we add random notifier
> > points and the teardown path is ass backwards. The whole thing wants
> > to be a tree which can be walked in either direction and from any
> > point. Right now we cut the trunk first and keep the single limb up
> > with a helicopter and start dismantling it.
> 
> But there are two ways to do it.  One is to eliminate the need for
> callbacks.  The other is to make a full dependency-based callback

What do you mean with fully eliminating the need for callbacks. Do you
want to put the necessary bringup/shutdown function calls just in the
core code so we get rid of the notifiers or do you have something
different in mind ?

> system.
> 
> Let's try the first before the second.  I implemented a full dep-based
> system for initcalls once, and it was not as nice as I'd hoped.

Yeah, a full dependency thing might be overkill.

> > Flat notifiers are not working for this as they do not allow a tree
> > structure and prevent us to do things in parallel.
> 
> Not sure whether calling notifiers in parallel is going to be a big win:
> they'll end up fighting over the cpu we're taking down.  But I could be
> wrong.

I'm not going to aim for parallel in the first place. That was just an
idea and if we chose the right implementation then parallelism can be
added later.
 
> > That really needs to be completely reworked. There is also a lot of
> > stuff which wants to be moved into the starting/dying CPU
> > context. Right now we kinda do that by trampling on the CPU with a
> > high prio stomper thread, but that's really just a bandaid and steady
> > cause of trouble.
> > 
> > If you look at facilities which use kthreads, then there is lots other
> > setup which does not need a notifier at all, as it can be done in the
> > context of the thread when we have a way to start/park those threads
> > at the right time in the up/down process.
> 
> That's a very nice idea.  Should be simpler for kthreads park/unpark
> themselves, rather than having some notifier to kill them.

Well, something needs to tell them to park/unpark, but what should
move into the thread is the setup/teardown of context.
 
> The original concept of stopping the machine for cpu hotplug and trying
> not to effect any other kernel code has jumped the shark: I think we
> need to look seriously at a complete rewrite where we don't use
> stop_machine.

Yep. Working on it. :)

Thanks,

	tglx
 
