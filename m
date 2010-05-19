Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0ESPBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:01:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45714 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0ESPBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:01:35 -0400
Date: Wed, 19 May 2010 08:01:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
       willy@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
Message-ID: <20100519150132.GJ2237@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100517043353.GA22127@kryten>
 <20100517043457.GA22416@kryten>
 <alpine.LFD.2.00.1005170800100.4195@i5.linux-foundation.org>
 <20100519130327.GW2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519130327.GW2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:03:27PM +1000, Nick Piggin wrote:
> On Mon, May 17, 2010 at 08:01:54AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 17 May 2010, Anton Blanchard wrote:
> > > 
> > > It turns out this bad code is a result of us defining atomic_t as a
> > > volatile int.
> > 
> > Heh. Ok, as you point out in the commit message, I obviously agree with 
> > this patch. "volatile" on data is evil, with the possible exception of 
> > "jiffies" type things.
> > 
> > So applied.
> 
> I wonder, Linus, is there a good reason to use volatile for these at
> all?
> 
> I asked you about it quite a while back, and IIRC you said it might
> be OK to remove volatile from bitops, provided that callers were audited
> (ie. that nobody used bitops on volatile variables).
> 
> For atomic_read it shouldn't matter unless gcc is *really* bad at it.
> Ah, for atomic_read, the required semantic is surely ACCESS_ONCE, so
> that's where the volatile is needed? (maybe it would be clearer to
> explicitly use ACCESS_ONCE?)

Explicit use of ACCESS_ONCE() where needed makes a lot of sense to me,
and allows better code to be generated for initialization and cleanup
code where no other task has access to the atomic_t.

> The case I was thinking about for bitops was for multiple non-atomic
> bitops, which would be nice to combine. In reality a lot of performance
> critical code (like page allocator) bites the bullet and does the
> open-coded bitwise ops. But it would be nice if that just worked for
> __set_bit / __clear_bit too.

FWIW, a similar debate in the C-language standards committee seems to
be headed in the direction of allowing combining of adjacent atomic
operations.

							Thanx, Paul
