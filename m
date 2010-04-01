Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0DAQQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:16:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59735 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab0DAQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:16:08 -0400
Date: Thu, 1 Apr 2010 09:15:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401161551.GE2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <4BB4C0F5.3070204@redhat.com>
 <1270137406.1598.78.camel@laptop>
 <4BB4C48C.5000005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB4C48C.5000005@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 07:06:36PM +0300, Avi Kivity wrote:
> On 04/01/2010 06:56 PM, Peter Zijlstra wrote:
> >On Thu, 2010-04-01 at 18:51 +0300, Avi Kivity wrote:
> >>On 04/01/2010 06:42 PM, Andrea Arcangeli wrote:
> >>>On Thu, Apr 01, 2010 at 01:43:14PM +0200, Peter Zijlstra wrote:
> >>>
> >>>>On Thu, 2010-04-01 at 13:27 +0200, Peter Zijlstra wrote:
> >>>>
> >>>>>I've almost got a patch done that converts those two, still need to look
> >>>>>where that tasklist_lock muck happens.
> >>>>>
> >>>>OK, so the below builds and boots, only need to track down that
> >>>>tasklist_lock nesting, but I got to run an errand first.
> >>>>
> >>>You should have a look at my old patchset where Christoph already
> >>>implemented this (and not for decreasing latency but to allow
> >>>scheduling in mmu notifier handlers, only needed by XPMEM):
> >>>
> >>>http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/
> >>>
> >>>The ugliest part of it (that I think you missed below) is the breakage
> >>>of the RCU locking in the anon-vma which requires adding refcounting
> >>>to it. That was the worst part of the conversion as far as I can tell.
> >>>
> >>>http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/anon-vma
> >>>
> >>Can we use srcu now instead?
> >I would much rather we make call_rcu_preempt() available at all times.
> 
> I don't understand.  I thought the problem was that the locks were
> taken inside an rcu critical section; switching to srcu would fix
> that.  But how is call_rcu_preempt() related?  Grepping a bit, what
> is call_rcu_preempt()?  my tree doesn't have it.

I believe that Peter is referring to the RCU implementation you get
with CONFIG_TREE_PREEMPT_RCU, which currently depends on CONFIG_PREEMPT.
The other implementation is CONFIG_TREE_RCU, which is usually called
"classic RCU".

							Thanx, Paul
