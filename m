Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1G3Xqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:46:37 -0400
Received: from science.horizon.com ([71.41.210.146]:40491 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751433Ab1G3Xqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:46:32 -0400
Date: 30 Jul 2011 19:46:30 -0400
Message-ID: <20110730234630.7270.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, mpm@selenic.com,
        tytso@mit.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fact is, even if you worry about some back door for the NSA, or
> some theoretical lack of perfect 32-bit randomness, we can pretty much
> depend on it. We still do our own hashing on top of whatever entropy
> we get out of rdrand, and we would still have all our other stuff.
> Plus the instruction is public and testable - if Intel did something
> wrong, they'll be *very* embarrassed.
> 
> In other words, there's absolutely no reason not to use it, and allow
> us to get away from /dev/random running out of entropy. We absolutely
> should use it for bootup randomness (where we currently are somewhat
> weak), and I absolutely disagree that it should be made into more of a
> driver abstraction.

I agree with your second paragraph, but disagree violently with your
first: Intel provide no way to test their RNG, and the AES-based whitener
makes it completely private and UNtestable.

Intel go into details about the hardware's boot-up self-test, but then
provide no way to access that self-test information, much less check up
on it.

I can feed all zeros into the described whitener and get output that is
not possible to distinguish from random, without access to the secret
initial state.  That's the whole point of a cipher, and AES is a very
good cipher!

The only technically difficult thing about implementing a back door
is ensuring that the output sequence doesn't repeat each power cycle.
You need just enough entropy or nonce to get that.

As long as you can achieve that, getting caught is actually quite unlikely.

Consider a sample implementation: implement it exactly as described,
except:
- Make the hardware known answer test (or, more specifically,
  the state of the DRBG after the KAT) the backdoor secret, and
- Suppress all but the first 40 bits of entropy from the hardware
  entropy source, replacing it with a fixed pattern (e.g. all zero).

An attacker who knows the secret needs to brute-force the 40 bits plus
the number of RDRND reads to be able to predict the RDRAND outout.

Someone who doesn't can ony detect the fiddle by power-cycling the
hardware a million times and looking for duplicate outputs.  (Birthday
attack on the amount of seed entropy.)

Even a small amount of persistent storage makes things more difficult.
For example, an 8-bit counter that usually survives power cycles replaces
the 40-bit birthday attack with 256 32-bit birthday attacks, requiring
256 * 2^16 = 2^24 power-cycles to find a collision.  While making an
attacker's job easier after they've brute-forced 40+ bits once.


I don't think it's *likely* that Intel have done this, but given the
about of National Security bullshit the U.S. government is throwing
around these days, I'm less than 10 bits certain that they haven't.


A much more verifiable way would be to provide access to the raw hardware
generator, and enough hardware documentation to predict how its output
varies with environmental conditions (temperature, supply voltage, clock
speed, x-rays, ...) and lot-to-lot.  It would be extremely difficult
to produce a deterministic (i.e. back-door-able) generator with the
same sensitivities.
