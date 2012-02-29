Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2B2Jcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:32:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab2B2Jcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:32:45 -0500
Date: Wed, 29 Feb 2012 10:32:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120229093224.GB11505@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228084359.GJ21106@elte.hu>
 <20120228132719.f375071a.akpm@linux-foundation.org>
 <20120229082944.GA10425@elte.hu>
 <1330505894.11248.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330505894.11248.108.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-02-29 at 09:29 +0100, Ingo Molnar wrote:
>
> > As part of any cleanup they should first be converted from 
> > arch_spinlock_t to regular spinlock_t - I bet if that is 
> > done then that not only simplifies the wrappers massively, 
> > it also turns the above soft lockup report into a nice, 
> > actionable lockdep splat.
> 
> It might help if you'd actually read the code.. that will 
> simply not work.

It cannot find all bugs - such as the CPU hotplug race that is 
still present in the code.

Still there's no excuse to go outside regular spinlock debug 
primitives via arch_spinlock_t.

If lockdep blows up in br_write_lock() due to holding up to 4096 
individual locks then we should add the exceptions to this 
particular write lock when the CPU count is too high - but:

 - do not disable the checking on saner configs

 - not disable all the *OTHER* lock debugging checks such as:

     - spin-lockup detection [this works even without ->held_locks]

     - allocate/free failure detection:

         The percpu code could be extended to run the equivalent 
         of debug_check_no_locks_freed() over the percpu area 
         that is going away, to make sure no held locks are 
         freed.

etc.

Thanks,

	Ingo
