Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2JHBYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 21:24:33 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54342 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2JHBYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 21:24:30 -0400
Date: Sun, 7 Oct 2012 21:24:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RNG: is it possible to spoil /dev/random by seeding it from
 (evil) TRNGs
Message-ID: <20121008012426.GB468@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Anton Mitterer <calestyo@scientia.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1349357555.3396.15.camel@fermat.scientia.net>
 <20121004224942.GA23970@thunk.org>
 <1349656891.6470.16.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349656891.6470.16.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 02:41:31AM +0200, Christoph Anton Mitterer wrote:
> I just wondered because I remembered David Shaw (one of the main
> developers from gpg) to imply[0] some time ago, that an "evil" entropy
> source would actually be a problem:

I've looked at his message, I didn't see any justification for his
concern/assertion.  So I can't really comment on it since he didn't
give any reason for his belief.

> Some notes though (guess you're the maintainer anyway):
> 1) With respect to the sources of entropy... would it make sense for the
> kernel to follow ideas from haveged[1].
> I mean we all now that especially disk-less server systems have problems
> with the current sources.
> Or is that intended to be kept in userspace?

We've made a lot of changes in how we gather entropy recently, so that
we're gathering a lot more entropy even on disk-less server systems.
We are using the time stamp counter, so in some ways we are using a
scheme which isn't that far off from haveged.  Historically,
/dev/random was created back before high resolution counters were not
always available on all CPU's, and so we depended on interrupts being
unpredictable.  What haveged does instead is to depend on cycle
counters, and count on some amount of uncertainty to cause differences
in the expected cycle counter when performing a known fixed workload.
What we are now doing is depending on the cycle counter on interrupts
which are will be at least as unpredictable and probably more so, than
haveged's fixed workload.

That's because we have an avantage of having access to the interrupt
timing information, which is something haveged doesn't have, since it
is a userspace solution.  So I think what we have right now in
/dev/random is better than what haveged has as a userspace-only
collection algorithm.

> 2) At some places, the documentation mentiones that SHA is used... any
> sense in "upgrading" to stronger/more secure (especially as it says the
> hash is used to protect the internal state of the pool) and faster
> algos?

We're not using SHA has a traditional cryptographic hash; so the
weaknesses caused by being able to find collisions in somewhat faster
than brute force aren't a problem.  We are hashing 4k bits of input to
produce 80 bits of output (we take the 160 bits output of SHA-1 and
xor them togethre to fold what we expose to the outside world to only
80 bits).  So there will always be collisions --- the pigeon hole
princple states that with 2**4096 possible inputs, and only 2**80
possible outputs, there will be definitely be collisions where
multiple inputs result in the same hash.  The trick is being able to
find all of the possible collisions --- and then being able to figure
out which one was really the one that represents the state of the
entropy pool at a particular point in time.  This is a very different
sort of analysis than simply being able to find two known inputs that
result in the same output.

So I'm not particularly worried at this point.  The other thing to
note is that the possible alternatives to SHA-1 (i.e., SHA-2 and
SHA-3) are actually slower, not faster.  So we would be giving up
performance if we were to use them.

> 3) Some places note that things are not so cryptographically strong...
> which sounds a bit worrying...

There is a specific tradeoff going in these places.  For example,
there are certain TCP hijacking attacks where so long as we can
prevent the attacker from being able to guess the next TCP sequence
number in less than say, five or ten minutes, we are fine.  We don't
need to protect this "secret" for more than a very limited amount of
time.  In addiiton, networking performance is very important.  If it
took several seconds to establish a TCP conneciton --- that would be
bad; consider what that would do for a web server!

The bottom line is that strength is not the only thing that we have to
engineer for.  If we did that for airplanes, for example, they would
never fly or require so much fuel as to be economically impractical.
Good engineering is to understand what strength is require, adding a
appropriate safety margin, and then saying, *enough*.

> 4) Were "newer" developments in PRNGs already taken into account? E.g.
> the Mersenne Twister (which is AFAIK however not cryptographically
> secure; at least in it's native form)

The problems solved by the Mersenne Twister are quite different from
the problems we are trying to solve in a cryptographic random number
generator.  PRNG's and CRNG's are very different animals.  You might
as well ask a basketball coach if they have taken into account the
latest scocer strategies...

					- Ted
