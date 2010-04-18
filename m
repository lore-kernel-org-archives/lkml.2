Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0DRNzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 09:55:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38499 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0DRNzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 09:55:06 -0400
Date: Sun, 18 Apr 2010 06:55:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
Message-ID: <20100418135500.GD3096@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271425881.4807.2319.camel@twins>
 <20100416141745.GC2615@linux.vnet.ibm.com>
 <1271427819.4807.2353.camel@twins>
 <20100416143202.GE2615@linux.vnet.ibm.com>
 <1271429810.4807.2390.camel@twins>
 <20100416150909.GF2615@linux.vnet.ibm.com>
 <1271430855.4807.2411.camel@twins>
 <20100416164503.GH2615@linux.vnet.ibm.com>
 <1271559996.14589.9.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271559996.14589.9.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 10:06:36PM -0500, James Bottomley wrote:
> On Fri, 2010-04-16 at 09:45 -0700, Paul E. McKenney wrote:
> > o	mutex_lock(): Critical sections need not guarantee
> > 	forward progress, as general blocking is permitted.
> 
> This isn't quite right.  mutex critical sections must guarantee eventual
> forward progress against the class of other potential acquirers of the
> mutex otherwise the system will become either deadlocked or livelocked.

If I understand you correctly, you are saying that it is OK for a given
critical section for a given mutex to fail to make forward progress if
nothing else happens to acquire that mutex during that time.  I would
agree, at least I would if you were to further add that the soft-lockup
checks permit an additional 120 seconds of failure to make forward progress
even if something -is- attempting to acquire that mutex.

By my standards, 120 seconds is a reasonable approximation to infinity,
hence my statement above.

So, would you agree with the following as a more precise statement?

o	mutex_lock(): Critical sections need not guarantee
	forward progress unless some other task is waiting
	on the mutex in question, in which case critical sections
	should complete in 120 seconds.

							Thanx, Paul
