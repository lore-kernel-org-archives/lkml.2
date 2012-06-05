Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab2FEBHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:07:15 -0400
Received: from ozlabs.org ([203.10.76.45]:47551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2FEBHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:07:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
In-Reply-To: <1338842001.28282.135.camel@twins>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 05 Jun 2012 10:10:33 +0930
Message-ID: <87zk8iioam.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2012 22:33:21 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-06-04 at 22:11 +0200, Thomas Gleixner wrote:
> 
> > I understand what you are trying to do, though I completely disagree
> > with the solution.
> > 
> > The main problem of the current hotplug code is that it is an all or
> > nothing approach. You have to tear down the whole thing completely
> > instead of just taking it out of the usable set of cpus.
> > 
> > I'm working on a proper state machine driven online/offline sequence,
> > where you can put the cpu into an intermediate state which avoids
> > bringing it down completely. This is enough to get the full
> > powersaving benefits w/o having to go through all the synchronization
> > states of a full online/offline. That will shorten the onlining time
> > of an previously offlined cpu to almost nothing.
> > 
> > I really want to avoid adding more bandaids to the hotplug code before
> > we have sorted out the existing horror.
> 
> Its far worse.. you shouldn't _ever_ care about hotplug latency unless
> you've got absolutely braindead hardware. We all now ARM has been
> particularly creative here, but is Intel now trying to trump ARM at
> stupid?

I disagree.  Deactivating a cpu for power saving is halfway to hotplug
anyway.  I'd rather unify the two cases, where we can specify how dead a
CPU should be, than have individual archs and boards do random hacks.

It also gives us a great excuse to audit and neaten various of the
hotplug cpu callbacks; most of the ones I've looked at have been racy :(

The ones which simply want to keep per-cpu stats can be given a nice
helper with two simple callbacks: one to empty stats for a going-away
cpu, and (maybe) one to restore them.

The per-cpu kthreads should no longer get torn down and recreated, and
doing it via a separate notifier function is ugly and error-prone.  My
plan is a "bool kthread_cpu_going(void)" and then a "void
kthread_cpu_can_go(void)", so kthreads can do:

        if (kthread_cpu_going()) {
                /* Do any cleanup we need. */
                ...

                /* This returns when CPU comes back. */
                kthread_cpu_can_go();
        }

Yeah, we should probably have the kthread exit inside
kthread_cpu_can_go() if they stop the kthread, but that's a detail.

Cheers,
Rusty.
