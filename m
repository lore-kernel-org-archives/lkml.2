Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0FCPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:35:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:48561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0FCPfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:35:24 -0400
Date: Fri, 4 Jun 2010 01:35:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603153518.GP6822@laptop>
References: <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
 <20100603120450.GH4035@linux.vnet.ibm.com>
 <20100603123832.GL6822@laptop>
 <20100603151730.GE4166@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603151730.GE4166@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:17:30PM +0200, Andi Kleen wrote:
> On Thu, Jun 03, 2010 at 10:38:32PM +1000, Nick Piggin wrote:
> > And they aren't even using ticket spinlocks!!
> 
> I suppose they simply don't have unfair memory. Makes things easier.

That would certainly be a part of it, I'm sure they have stronger
fairness and guarantees at the expense of some performance. We saw the
spinlock starvation first on 8-16 core Opterons I think, wheras Altix
had been over 1024 cores and POWER7 1024 threads now apparently without
reported problems.

However I think more is needed than simply "fair" memory at the cache
coherency level, considering that for example s390 implements it simply
by retrying cas until it succeeds. So you could perfectly round-robin
all cache requests for the lock word, but one core could quite easily
always find it is granted the cacheline when the lock is already taken.

So I think actively enforcing fairness at the lock level would be
required. Something like if it is detected that a core is not making
progress on a tight cas loop, then it will need to enter a queue of
cores where the head of the queue is always granted the cacheline first
after it has been dirtied. Interrupts will need to be ignored from this
logic. This still doesn't solve the problem of an owner unfairly
releasing and grabbing the lock again, they could have more detection to
handle that.

I don't know how far hardware goes. Maybe it is enough to statistically
avoid starvation if memory is pretty fair. But it does seem a lot easier
to enforce fairness in software.

