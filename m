Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0ESO5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:57:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0ESO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:57:51 -0400
Date: Wed, 19 May 2010 07:55:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
       willy@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t
 definition
In-Reply-To: <20100519130327.GW2516@laptop>
Message-ID: <alpine.LFD.2.00.1005190740390.23538@i5.linux-foundation.org>
References: <20100517043353.GA22127@kryten> <20100517043457.GA22416@kryten> <alpine.LFD.2.00.1005170800100.4195@i5.linux-foundation.org> <20100519130327.GW2516@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Nick Piggin wrote:
> 
> I wonder, Linus, is there a good reason to use volatile for these at
> all?
> 
> I asked you about it quite a while back, and IIRC you said it might
> be OK to remove volatile from bitops, provided that callers were audited
> (ie. that nobody used bitops on volatile variables).

The bitops volatiles are different. They are there to allow for the C type 
system (ie "const volatile *" just means that it accepts any kind of 
pointer without complaining about implicit casting of const -> non-const 
or volatile -> non-volatile).

For atomic_read(), and for the test_bit(), the _internal_ volatiles are 
there just to get that ACCESS_ONCE() behavior, so that you can do things 
like

	while (test_bit(..)) {
		..
	}

and know that the compiler doesn't think it can do things like move the 
atomic or bit read outside the loop or whatever.

Now, I do agree that _normally_ we should have memory barriers or similar 
that guarantee that the compiler won't do odd things, but atomics and the 
bitops are basically designed to work in the _absense_ of any other 
serialization, so that's why it makes sense to have ACCESS_ONCE() 
semantics for them.

> For atomic_read it shouldn't matter unless gcc is *really* bad at it.
> Ah, for atomic_read, the required semantic is surely ACCESS_ONCE, so
> that's where the volatile is needed? (maybe it would be clearer to
> explicitly use ACCESS_ONCE?)

Exactly. The volatile access on read inside those macros/functions (as 
opposed to the "volatiles" that are there for C type reasons) is basically 
the same as ACCESS_ONCE(). We could replace it with ACCESS_ONCE, although 
I don't think it makes much difference as long as you always just think of 
volatile as ACCESS_ONCE and just always put it in code (rather than on the 
data structures)).

And replacing it with ACCESS_ONCE always has the header file dependency 
issues, so..

> The case I was thinking about for bitops was for multiple non-atomic
> bitops, which would be nice to combine. In reality a lot of performance
> critical code (like page allocator) bites the bullet and does the
> open-coded bitwise ops. But it would be nice if that just worked for
> __set_bit / __clear_bit too.

__set_bit / __clear_bit should probably just be done as regular C code. 
And yeah, we should remove the volatile from them. They aren't even valid 
on anything that isn't locked anyway, so if somebody uses them on 
something they have marked volatile, it's a bug.

		Linus
