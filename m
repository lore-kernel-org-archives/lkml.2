Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2GESff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:35:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40710 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2GESfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <1341511933-11169-8-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu> <1341511933-11169-8-git-send-email-tytso@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 11:35:12 -0700
X-Google-Sender-Auth: 4IRbqid-QEyIt9k8VB8D5Wgp-bI
Message-ID: <CA+55aFxk3eViz1-CuuHf8xxTgLth376K_cOKAtAj0waXAz+GWg@mail.gmail.com>
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:12 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Create a new function, get_random_bytes_arch() which will use the
> architecture-specific hardware random number generator if it is
> present.  Change get_random_bytes() to not use the HW RNG, even if it
> is avaiable.

This is horrible, I think. NAK NAK NAK.

If Intel's rng really isn't trustworthy, they'll get a *huge* black
eye for it. It would be a total PR disaster for Intel, so they have
huge incentives to be trustworthy.

And in the meantime, your patch now slows things down for no obvious
reason, and gives randomness that is *pracitcally* worse because you
have some theoretical concerns that seem really unlikely to begin
with.

Christ, we *know* that our nonblocking pool isn't perfect either.
That's why all the changes in the first place. It's *more* likely that
somebody cracks our nonblocking pool on embedded devices where
interrupts may be pretty predictable than that Intel's RNG is not
trustworthy - and crackable.

So don't do this. It's stupid.

If you really don't trust the intel rng, and have some *reason* not to
trust it, there's a perfectly fine solution to that:

 - add a flag (that is *off* by default, so that it doesn't hurt
normal people) to go to "extra scary mode"

 - in extra scary mode, you *still* use the hwrng, but you never give
the data as-is, you mix it into the nonblocking pool *first*, and then
extract.

In absolutely *no* case is it acceptable to say "we don't trust the hw
rng, so we won't use it at all, and instead use our known nonblocking
pool that we can't guarantee is random either".

Really.

I absolutely *detest* patches like this that make *practical* security
worse, in the name of some idiotic theoretical worry that nobody has
any reason to believe is real.

If "get_random_bytes()" doesn't use the hw rng when it exists, it is
broken. It's that simple.

              Linus
