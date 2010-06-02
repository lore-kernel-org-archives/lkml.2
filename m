Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab0FBFwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:52:40 -0400
Received: from ozlabs.org ([203.10.76.45]:40944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0FBFwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:52:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 15:22:34 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Tim Abbott <tabbott@ksplice.com>
References: <201005252300.07739.rjw@sisk.pl> <201006021239.42006.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006012150070.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006012150070.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021522.35784.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 02:26:52 pm Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Rusty Russell wrote:
> > 
> > OK, this might be worthwhile.  Take the very first mail you sent:
> > 
> >    Hmm. That does seem to be buggy.  We can't just drop and re-take the lock: 
> >    that may make sense internally as far as resolve_symbol() itself is 
> >    concerned, but the caller will its own local variables, and some of those 
> >    will no longer be valid if the lock was dropped. 
> > 
> > The implication here is that that I don't know locking, and that this was
> > done without thought or care.  In fact, I did worry about it and decided it
> > was less risky than a locking reduction given my limited cycles (indeed,
> > it has been slightly).
> 
> Well, part of the context here is that the commit had been bisected as 
> being buggy. It turns out the bug was a different issue, but at the same 
> time, it very much looked like the locking was simply known a-priori to be 
> buggy. No?

Hmm, you're still missing it.  Let me try again.

You weren't the best person to make the call.  That didn't occur to you, did
it?

Subsystem maintainers aren't just patch monkeys, we collect all the metadata
which informs these decisions.  Without that, you wandered in, came to the
obvious conclusion, and were wrong.

Really grating is the arrogant lack of respect for that knowledge combined
with your multiple mistakes since then due to your lack of it.  See below.

> >    That commit also changes the return value semantics of "use_module()", 
> >    which is an exported interface where the only users seem to be 
> >    out-of-kernel (the only in-kernel use is in kernel/module.c itself). That 
> >    seems like a really really bad idea too.
> > 
> > Again with the implication that this was done without consideration.
> 
> No. The implication was that it's wrong to do and a bad idea. Anything 
> else is just you reading things into it.
> 
> It's an exported interface, and you changed it with no real reason. 
> Whether you then talked to users or not is immaterial.
> 
> You could easily have just changed the _internal_ thing, and exported the 
> unchanged interface.

I *genuinely* thought our policy with out-of-tree code was to smother
out-of-tree code with absolute apathy so they'll get sick of riding the
churn.

Still, easy to avoid in this case.

> Even your second version is just very confused. It renames it, but then 
> exports the renamed version. What does that help?

This *almost* looks like an honest "hey, I don't understand this".

But no, "very confused" already assumes you're right.  You do ask if it
helps...

> It still means that the  external module - for no good reason - needs to
> have basically a  source-level version number check.

...and go on to assume it doesn't.  I must be really confused, right?

Or maybe, I know something you don't about the code I maintain.

We have infrastructure to look up symbols dynamically: symbol_get().

Sure, they have to adapt their code, but now they can maintain their own
damn wrapper, *and* they'll discover the change as soon as they try to
build their module against the new kernel.

I'd go so far as to say it's clever...
Rusty.
