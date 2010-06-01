Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0FAFWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:22:12 -0400
Received: from ozlabs.org ([203.10.76.45]:48693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab0FAFWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:22:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Tue, 1 Jun 2010 14:52:05 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011051.25636.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011452.06843.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 12:54:18 pm Linus Torvalds wrote:
> I'm sorry, but that's simply not good enough. We do not do ad-hoc locking 
> "just becuse it works". Locking is too damn easy to get wrong, and "one 
> person knows how the locking works" is not an excuse for anything at all.

You asked who the hell knew what the results were.

You couldn't figure it out, so you shotgunned an innocent patch, which papered
over the real problem.

> > See, this I agree with, but you could have said this in far fewer words and
> > much more politely.
> 
> Why? Why does "locking is crap" need any politeness? And why is it wrong 
> to explain at length exactly _why_ our module locking is a piece of sh*t?
> 
> So explain why I should be more polite, or more terse?

How about this:

"I hate this patch.  It makes already-ugly locking in module.c awful, and I
can't see that it's correct.  Why not just reduce the locking to cover
the minimum needed?"

Getting email from you is the least fun part of kernel hacking, and that
sucks.  It's never "this code sucks, let's make it better", and always
"your code sucks and you're wrong" :(

> > As posted, I had a patch to clean up the locking.  Seems you ignored it.
> 
> Umm. That patch was not the original one that I objected to, is it?

Nope, but you didn't respond to it either.

> I do agree with your 1/2, btw, the one you posted under protest after I 
> pointed out that the locking was crap. I was just explaining _why_ the 
> locking was crap, and what the problem was to Andrew. 

Ugly as dropping the lock was, it was in some ways less ambitious than
either patch.  I understand that you disagree.

> I happen to also think that my solution to the problem is actually better 
> and more straightforward than your one is.

I don't think so, for several reasons.

(1) You no longer print out which module you gave up waiting for.
(2) You now need that code complexity for !CONFIG_MODULE_UNLOAD.
(3) It's obviously *not* straightforward otherwise you'd see why it's buggy.
(4) The fast booting nutters want more parallelism in module loading anyway.
(5) The locking *is* getting hairy (we drop it once already), and my patch
    makes that more explicit and clearer.

> > No, those modules could still fail init.
> 
> Umm. Which I took care of.

No, you didn't.

Prior to your patch, noone could get a reference on a module before it had
done init.  So when init fails, we simply free the module.

Now, you've changed that with your grab-and-check-later code.  And you can't
fix it for the !CONFIG_MODULE_UNLOAD, because there are no reference counts
for that case.

> I posted the damn series. Your next email even claims that my first one in 
> the series (the bigger one) was a nice cleanup.

I was being polite.  In practice, it added lines of code for no real win,
but hey, you obviously needed some positive feedback or something.

> You didn't comment on the 
> second one, apparently because you're too embarrassed to admit you were 
> wrong, and it wasn't all that 'wrong, complex, and fundamentally broken' 
> to begin with. 

No, Linus.  Difficult as it is, I always try to frankly and publicly admit
when I was wrong.  I'm sure you've experienced this in the past.

I didn't respond to it because you'd said "if we can't fix the
locking, we should try...".

I fixed the locking, so what gain in pointing out your mistakes?

Hope that helps,
Rusty.
