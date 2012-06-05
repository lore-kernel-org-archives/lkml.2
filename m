Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544Ab2FEJhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:37:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:45224 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab2FEJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:37:03 -0400
Date: Tue, 5 Jun 2012 11:36:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <87zk8iioam.fsf@rustcorp.com.au>
Message-ID: <alpine.LFD.2.02.1206051135260.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Rusty Russell wrote:
> On Mon, 04 Jun 2012 22:33:21 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-06-04 at 22:11 +0200, Thomas Gleixner wrote:
> > 
> > > I understand what you are trying to do, though I completely disagree
> > > with the solution.
> > > 
> > > The main problem of the current hotplug code is that it is an all or
> > > nothing approach. You have to tear down the whole thing completely
> > > instead of just taking it out of the usable set of cpus.
> > > 
> > > I'm working on a proper state machine driven online/offline sequence,
> > > where you can put the cpu into an intermediate state which avoids
> > > bringing it down completely. This is enough to get the full
> > > powersaving benefits w/o having to go through all the synchronization
> > > states of a full online/offline. That will shorten the onlining time
> > > of an previously offlined cpu to almost nothing.
> > > 
> > > I really want to avoid adding more bandaids to the hotplug code before
> > > we have sorted out the existing horror.
> > 
> > Its far worse.. you shouldn't _ever_ care about hotplug latency unless
> > you've got absolutely braindead hardware. We all now ARM has been
> > particularly creative here, but is Intel now trying to trump ARM at
> > stupid?
> 
> I disagree.  Deactivating a cpu for power saving is halfway to hotplug
> anyway.  I'd rather unify the two cases, where we can specify how dead a
> CPU should be, than have individual archs and boards do random hacks.
> 
> It also gives us a great excuse to audit and neaten various of the
> hotplug cpu callbacks; most of the ones I've looked at have been racy :(
> 
> The ones which simply want to keep per-cpu stats can be given a nice
> helper with two simple callbacks: one to empty stats for a going-away
> cpu, and (maybe) one to restore them.
> 
> The per-cpu kthreads should no longer get torn down and recreated, and
> doing it via a separate notifier function is ugly and error-prone.  My
> plan is a "bool kthread_cpu_going(void)" and then a "void
> kthread_cpu_can_go(void)", so kthreads can do:
> 
>         if (kthread_cpu_going()) {
>                 /* Do any cleanup we need. */
>                 ...
> 
>                 /* This returns when CPU comes back. */
>                 kthread_cpu_can_go();
>         }
> 
> Yeah, we should probably have the kthread exit inside
> kthread_cpu_can_go() if they stop the kthread, but that's a detail.

I have an implementation of that already. Need to polish and post. If
my day would have more than 24 hours....

Thanks,

	tglx
