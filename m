Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0FAPD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:03:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab0FAPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:03:54 -0400
Date: Tue, 1 Jun 2010 07:58:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006011452.06843.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011051.25636.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org> <201006011452.06843.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Rusty Russell wrote:
>
> > So explain why I should be more polite, or more terse?
> 
> How about this:
> 
> "I hate this patch.  It makes already-ugly locking in module.c awful, and I
> can't see that it's correct.  Why not just reduce the locking to cover
> the minimum needed?"

Umm. Did you read the first few emails I sent out on this thread 
originally? They were actually _politer_ than your suggestion above (no 
crap mentioned), and did exactly what you ask for. Let me quote the one 
where I suggested tightening the lock, for example (along with saying that 
I don't want to see pointless semantic changes):

   I'm not re-applying it with the pointless semantic changes that are 
   visible to modules. It doesn't matter if they were informed, if it means 
   that they'll then just have some odd version dependency and add crazy 
   "#if LINUX_VERSION" tests that aren't even exact.
   
   I also wonder exactly what that module_mutex() actually ends up 
   protecting. 99% of load_module() seems to be stuff that is purely about 
   local issues. Maybe we could tighten the actual lock section to just the
   parts that actually expose the vmalloc'ed area to others?
   
   It's generally pointless releasing a lock in the middle - that just makes 
   the lock even less valid. If it's valid to just release the lock (without 
   some retry logic starting everything from the beginning), it likely the 
   lock shouldn't have been held there in the first place.

See? How bad was that? 

> Getting email from you is the least fun part of kernel hacking, and that
> sucks.  It's never "this code sucks, let's make it better", and always
> "your code sucks and you're wrong" :(

See above. That wasn't what I said. That "you're wrong" was what I got to 
when I got frustrated with you for complaining about me actually trying to 
fix it.

And "crap locking" only came up in the long explanation to Andrew about 
what the original problem was, and why the EBUSY error wasn't a problem. 
And we all know the module locking was/is crap. You must have known it 
too, since you apparently had a "fix up locking" patch from before.

So what was so bad about calling the locking crap? Really?

So yes, we both get frustrated here. But read the thread again, Rusty, and 
look who it is that actually starts complaining about other peoples code. 
I called the locking crap, you're the one who called something "wrong, 
complex and fundamentally broken".

Kettle. Pot. Black.

> > I do agree with your 1/2, btw, the one you posted under protest after I 
> > pointed out that the locking was crap. I was just explaining _why_ the 
> > locking was crap, and what the problem was to Andrew. 
> 
> Ugly as dropping the lock was, it was in some ways less ambitious than
> either patch.  I understand that you disagree.

I agree with "less ambitious". But I'd also call it "papering over bad 
code", or "making bad locking much worse" or "likely introduce new and 
even more subtle problems".

In fact, I might even go so far as using "crap".

Because it really is fundamentally wrong to drop a lock in the middle of 
an operation. It may _work_, but it certainly doesn't make the code 
better.

The thing is, when we have a problem in some code, we should try to make 
sure that the fixed code is _better_ than the old code. Not just fix the 
symptoms. Fix the underlying _reason_ for why the bug happened in the 
first place.

And the underlying reason the bug happened is (I think we both agree) 
simply that the locking was broken. Your patch fixed the symptoms, yes, 
but it did so by making the locking _worse_. That's why I hated it. I 
really don't think it was a good approach. 

And I do think you agree in the end, and know that's true.

> > I happen to also think that my solution to the problem is actually better 
> > and more straightforward than your one is.
> 
> I don't think so, for several reasons.
> 
> (1) You no longer print out which module you gave up waiting for.
> (2) You now need that code complexity for !CONFIG_MODULE_UNLOAD.
> (3) It's obviously *not* straightforward otherwise you'd see why it's buggy.
> (4) The fast booting nutters want more parallelism in module loading anyway.
> (5) The locking *is* getting hairy (we drop it once already), and my patch
>     makes that more explicit and clearer.

I agree with 1-2, and even had a comment about #2 pointing that out, and 
thinking that it would be good for other reasons (ie /proc/modules).

And as to #4, the "wait for everything after the fact" is actually the 
faster approach, although in practice it probably doesn't matter (you'd 
hope that modules depending on other modules that are still busy loading 
is such a rare case that it does _not_ matter whether you wait for them to 
load serially or batched up).

And as to #5, I would not actually suggest that we do "wait later _or_ fix 
the locking", I'd do both. It really isn't a either-or situation, Rusty.

So I don't think those ones matter.

HOWEVER. 

But as to #3, I think you bring up an interesting issue:

> Prior to your patch, noone could get a reference on a module before it had
> done init.  So when init fails, we simply free the module.
> 
> Now, you've changed that with your grab-and-check-later code.  And you can't
> fix it for the !CONFIG_MODULE_UNLOAD, because there are no reference counts
> for that case.

I agree. And you're right, we'd have to move even more code from the 
MODULE_UNLOAD case into !MODULE_UNLOAD to fix it. At which point I do 
agree that if we want to keep !MODULE_UNLOD (and I do think we do), my 
approach really doesn't work. Or we'd basically make !MODULE_UNLOAD a 
pointless exercise where unloading is not allowed, but we still do 
everything else the same way.

So I do agree that your later two-patch series is the way to go.

I would like to note that your original "fix things by dropping the lock" 
patch that I hated so much had this exact bug too. Making this a good 
example of _why_ it's basically always wrong to drop locks in the middle - 
even if you claimed you knew and understood the locking.

So I do hope we can agree to call the module locking "total and utter 
crap", ok? 

And it really wasn't a personal complaint about your prowess. Crap locking 
(or code in general) is crap, but calling the code crap shouldn't be 
something you take personally. Especially not when there are various valid 
historical reasons _why_ it is all crap. 

And yes, my code was crap too. I wrote it for the MODULE_UNLOAD case, and 
only added a comment saying the !unload case was broken, but didn't look 
at just _how_ broken it was. My bad.

			Linus
