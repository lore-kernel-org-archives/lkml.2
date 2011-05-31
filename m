Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab1EaSLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:11:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41804 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1EaSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:11:21 -0400
Date: Tue, 31 May 2011 11:11:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU fix
Message-ID: <20110531181116.GI2393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110531162726.GA15162@elte.hu>
 <BANLkTi=aWc2c18OohJVmVn_aniyxDKO9Rw@mail.gmail.com>
 <20110531174430.GG2393@linux.vnet.ibm.com>
 <BANLkTimapK+1vDwB-Akw0eVimM4gHBdqaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimapK+1vDwB-Akw0eVimM4gHBdqaw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 02:52:59AM +0900, Linus Torvalds wrote:
> On Wed, Jun 1, 2011 at 2:44 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > The reason for the switch is to allow threads blocked in TREE_PREEMPT_RCU
> > and TINY_PREEMPT_RCU RCU read-side critical sections to have their
> > priority boosted in order to avoid OOM.  People have made these OOMs
> > happen, so this is not longer just a theoretical concern.
> 
> Quite frankly, that doesn't make much sense.
> 
> First off, the default for priority boosting is off (and you cannot
> even select it unless you have RT_MUTEX and PREEMPT_RCU), so why the
> heck do we still use the threads even when we don't support the
> boosting at all?

I considered using softirq in the !RCU_BOOST case, but that makes the
code larger and just makes the failure cases we saw less likely.  And
some of the failure cases could be made to happen from userspace with
real-time threads, not just from RCU priority boosting.

But I could of course switch to the dual softirq/kthread approach
if needed.

> Secondly, if a process is in danger of exhausting the RCU resources,
> and it is preemptable, why doesn't the rcu_read_unlock() logic just
> try to force a reschedule and thus an rcu idle period? Using processes
> and process priorities for this seems to be just stupid.

This approach does work (and is used) for TINY_RCU and TREE_RCU,
but it unfortunately simply does not work for TINY_PREEMPT_RCU and
TREE_PREEMPT_RCU.  The reason for this is that for the preemptible
variants of RCU, a reschedule in not guaranteed to be an RCU quiescent
state.  Which is why RCU_BOOST depends on PREEMPT_RCU (which is either
TINY_PREEMPT_RCU or TREE_PREEMPT_RCU.

> I dunno. After RCU_TINY showed how fragile it was to use kernel
> threads for this, and after this subtle issue just re-inforced that
> conclusion, I just cannot begin to believe that using a thread was the
> right thing to do. It just seems stupid.

Again, at least some of these were things that could be made to happen
from userspace with the standard APIs, so those at least did need to
be fixed.

							Thanx, Paul
