Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2HEALH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:11:07 -0400
Received: from mx.treblig.org ([80.68.94.177]:37426 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab2HEALB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:11:01 -0400
Date: Sun, 5 Aug 2012 01:10:51 +0100
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] page-table walkers vs memory order
Message-ID: <20120805001051.GC1255@gallifrey>
References: <1343064870.26034.23.camel@twins>
 <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
 <20120804143719.GB10459@redhat.com>
 <20120804220245.GB3307@linux.vnet.ibm.com>
 <20120804224705.GD10459@redhat.com>
 <20120804225910.GB1255@gallifrey>
 <20120804231151.GK3307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120804231151.GK3307@linux.vnet.ibm.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 01:01:37 up 152 days, 10:34,  1 user,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Aug 04, 2012 at 11:59:10PM +0100, Dr. David Alan Gilbert wrote:

<snip>

> > A compiler could decide to dereference it using a non-faulting load,
> > do the calculations or whatever on the returned value of the non-faulting
> > load, and then check whether the load actually faulted, and whether the
> > address matched the prediction before it did a store based on it's
> > guess.
> 
> Or the compiler could record a recovery address in a per-thread variable
> before doing the speculative reference.  The page-fault handler could
> consult the per-thread variable and take appropriate action.

The difference is that I'd expect a compiler writer to think that
they've got a free hand in terms of instruction usage that the OS/library
doesn't see - if it's in the instruction manual and it's marked as user
space and non-faulting I'd say it's fair game; once they know that they're
going to take a fault or mark pages specially then they already know they're
going to have to cooperate with the OS, or worry about what other
normal library calls are going to do.
(A bit of googling seems to suggest IA64 and SPARC have played around
with non-faulting load optimisations, but I can't tell how much.)

> But both this approach and your approach are vulnerable to things like
> having the speculation area mapped to (say) MMIO space.  Not good!

Not good for someone doing MMIO, but from an evil-compiler point
of view, they might well assume that a pointer is to memory
unless someone has made an effort to tell them otherwise (not that
there is a good standard to do that).

> So I am with Andrea on this one -- there would need to be some handshake
> between kernel and compiler to avoid messing with possibly-unsafe
> mappings.  And I am still not much in favor of value speculation.  ;-)

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
