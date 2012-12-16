Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2LPAa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 19:30:28 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:38644 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2LPAa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 19:30:27 -0500
Date: Sat, 15 Dec 2012 19:30:20 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-ID: <20121216003020.GC9016@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
	Kees Cook <keescook@chromium.org>
References: <50C72800.20508@chronox.de>
 <20121212164321.a01c5641.akpm@linux-foundation.org>
 <50C98764.6050104@chronox.de>
 <50CB63A9.80409@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB63A9.80409@chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 06:36:41PM +0100, Stephan Mueller wrote:
> >> That patch is about one week from a mainline merge, btw.
> > Initially I was also thinking about get_random_int. But stack protection
> > depends on non-predictable numbers to ensure it cannot be defeated. As
> > get_random_int depends on MD5 which is assumed to be broken now, I
> > discarded the idea of using get_random_int.

The original use of get_random_int() was for applications where the
speed impact of using a heavierweight cryptographic primitive was not
something which could be tolerated.

However, the strength of get_random_int() is actually pretty good.
Note that we never expose the full MD5 hash; we only export the first
32-bits of the hash.   So even if you ignore the effects of:

	hash[0] += current->pid + jiffies + get_cycles();

What we effectively have is a deterministic RNG which is using MD5,
where the secret "key" is an initially seeded random value, and the
state counter is the MD5 hash accumulator, where we only expose the
first 32-bits with each turn of the crank.  Now, MD5 has been cracked,
but it's been cracked as a cryptographic checksum --- that is, given a
particular MD5 hash, it is possible to find an input value which will
result in that hash.  That doesn't necessarily mean that it can be
possible to take a stream of numbers produced by using the MD5 core in
this particular RNG configuration, and determine the secret value used
for the RNG (a collision attack allows you to find a possible input
value; that value may not be the one used as the secret).

That being said, it's not a question which has been studied
extensively by cryptographers, and so I can easily see how people
might be paranoid about whether this approach is good enough.

In the case of initializing 16 bits of randomness passed to userspace
after a exec(), performance is presumably not as important, so if
someone wanted to use something that was stronger from a
certificational point of view than get_random_int(), that's certainly
understandable.  However, it's not clear to me that replicating the
full /dev/random pool infrastructure if you're never going to mix in
any additional randomness is the best way to go about things.

What I would do instead is use an AES-based cryptographic random
number generator.  That is, at boot time, grab enough randomness to
for an AES key, and then use that key to create a cryptographic random
number generator by encrypting a counter with said AES key.  This is a
cryptographic primitive which has been very carefully studied, and for
architectures where you have a hardware support for AES (including
ARMv8, Power 7, Sparc T4, as well as x86 processors with the AES-NI
instructions), this will be much faster and require much less memory
and CPU resources than replicating the /dev/urandom infrastructure.

Whether or not we really need this level of paranoia for hardening
stack randomization I'll leave for someone else to decide.
Personally, my philosophy is if someone has managed to get
unprivileged shell acess, trying to protect against a privilege
escalation attack is largely hopeless on most Linux systems.  The name
of the game is to protect against someone who does not yet have the
ability to run arbitrary unprivileged code on the system of interest.
In that case, the attacker isn't going to be able to get access to the
output of get_random_int(), so even if there was a cryptographic
weakness where an attacker who had access to the get_random_int()
output stream could guess the internal state of the MD5-based RNG, in
the case of a remote attacker, they wouldn't have access to the output
of the RNG in the first place.

Regards,

						- Ted
