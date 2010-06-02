Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0FBDJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:09:46 -0400
Received: from ozlabs.org ([203.10.76.45]:52082 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0FBDJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:09:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 12:39:40 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021239.42006.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 12:28:31 am Linus Torvalds wrote:
> 
> On Tue, 1 Jun 2010, Rusty Russell wrote:
> >
> > > So explain why I should be more polite, or more terse?
> > 
> > How about this:
> > 
> > "I hate this patch.  It makes already-ugly locking in module.c awful, and I
> > can't see that it's correct.  Why not just reduce the locking to cover
> > the minimum needed?"
> 
> Umm. Did you read the first few emails I sent out on this thread 
> originally?

OK, this might be worthwhile.  Take the very first mail you sent:

   Hmm. That does seem to be buggy.  We can't just drop and re-take the lock: 
   that may make sense internally as far as resolve_symbol() itself is 
   concerned, but the caller will its own local variables, and some of those 
   will no longer be valid if the lock was dropped. 

The implication here is that that I don't know locking, and that this was
done without thought or care.  In fact, I did worry about it and decided it
was less risky than a locking reduction given my limited cycles (indeed,
it has been slightly).

   That commit also changes the return value semantics of "use_module()", 
   which is an exported interface where the only users seem to be 
   out-of-kernel (the only in-kernel use is in kernel/module.c itself). That 
   seems like a really really bad idea too.

Again with the implication that this was done without consideration.  I keep
that exported as a courtesy to the ksplice team, but I never intended to let
that shackle internal changes even slightly. And I think it's wrong to even
start down that path (though I changed the name for you in the recent patches)

   So I think reverting it is definitely the right thing to do. The commit 
   seems fundamentally broken. And having modules do request_module() in 
   their init functions has always been invalid anyway, so that excuse 
   doesn't really seem to be a reason to do anything crazy like this either.

The code is "fundamentally broken" and "crazy".  The purpose of the patch
was "invalid anyway".

You managed to accuse me four times of being an incompetent and downright
crazy maintainer in your first three paragraphs of the first mail!

> They were actually _politer_ than your suggestion above (no 
> crap mentioned), and did exactly what you ask for.

My example quote entirely lacked accusations of incompetence; the only
implications are:
(1) Hey, I might be wrong, maybe I just didn't spend enough time on it.
(2) Otherwise, here's what I'd do, you're smart enough to run with it if
    it makes sense or explain why I'm barking up the wrong tree.

See Andrew Morton's correspondence for how his "maybe I'm dumb but" tone
is used to brutal effect...

> I would like to note that your original "fix things by dropping the lock" 
> patch that I hated so much had this exact bug too. Making this a good 
> example of _why_ it's basically always wrong to drop locks in the middle - 
> even if you claimed you knew and understood the locking.

And I would like to note that it didn't :)  It grabbed references only on
completed modules.

It still had that find_module race, but the kset error actually it.  The
lock reduction patch needs that fixed.

> So I do hope we can agree to call the module locking "total and utter 
> crap", ok? 

OK.  And I agree that I was too cautious here; I should have taken the time
to fix locking once and for all.  That's much easier to do when there's a
Linus yelling at you about it.

> And yes, my code was crap too. I wrote it for the MODULE_UNLOAD case, and 
> only added a comment saying the !unload case was broken, but didn't look 
> at just _how_ broken it was. My bad.

Oh no, your code was broken for UNLOAD too.

And sloppy; you would have got a checklist reply email if you had mailed it
anonymously :)

Thanks for the consideration,
Rusty.
