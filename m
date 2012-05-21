Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab2EUEOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 00:14:18 -0400
Received: from ozlabs.org ([203.10.76.45]:60859 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab2EUEOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 00:14:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <alpine.LFD.2.02.1204201602330.2542@ionos>
References: <20120420122120.097464672@linutronix.de> <4F916AF3.7020301@linux.vnet.ibm.com> <alpine.LFD.2.02.1204201602330.2542@ionos>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 May 2012 11:12:39 +0930
Message-ID: <871ume48ds.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 16:18:04 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 20 Apr 2012, Srivatsa S. Bhat wrote:
> > already done.. Myself and Nikunj had some initial design/ideas on reducing
> > the duplication in architecture code, related to managing the setting
> > of the cpu in the online mask, sending out CPU_STARTING notifiers etc
> > from generic code..
> 
> The whole notifier business needs a redesign as well, because we don't
> have a way to express proper dependencies, we add random notifier
> points and the teardown path is ass backwards. The whole thing wants
> to be a tree which can be walked in either direction and from any
> point. Right now we cut the trunk first and keep the single limb up
> with a helicopter and start dismantling it.

But there are two ways to do it.  One is to eliminate the need for
callbacks.  The other is to make a full dependency-based callback
system.

Let's try the first before the second.  I implemented a full dep-based
system for initcalls once, and it was not as nice as I'd hoped.

> Flat notifiers are not working for this as they do not allow a tree
> structure and prevent us to do things in parallel.

Not sure whether calling notifiers in parallel is going to be a big win:
they'll end up fighting over the cpu we're taking down.  But I could be
wrong.

> That really needs to be completely reworked. There is also a lot of
> stuff which wants to be moved into the starting/dying CPU
> context. Right now we kinda do that by trampling on the CPU with a
> high prio stomper thread, but that's really just a bandaid and steady
> cause of trouble.
> 
> If you look at facilities which use kthreads, then there is lots other
> setup which does not need a notifier at all, as it can be done in the
> context of the thread when we have a way to start/park those threads
> at the right time in the up/down process.

That's a very nice idea.  Should be simpler for kthreads park/unpark
themselves, rather than having some notifier to kill them.

The original concept of stopping the machine for cpu hotplug and trying
not to effect any other kernel code has jumped the shark: I think we
need to look seriously at a complete rewrite where we don't use
stop_machine.

Cheers,
Rusty.
