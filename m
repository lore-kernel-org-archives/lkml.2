Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068Ab0FBFBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:01:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604Ab0FBFBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:01:33 -0400
Date: Tue, 1 Jun 2010 21:56:52 -0700 (PDT)
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
In-Reply-To: <201006021239.42006.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006012150070.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org> <201006021239.42006.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> OK, this might be worthwhile.  Take the very first mail you sent:
> 
>    Hmm. That does seem to be buggy.  We can't just drop and re-take the lock: 
>    that may make sense internally as far as resolve_symbol() itself is 
>    concerned, but the caller will its own local variables, and some of those 
>    will no longer be valid if the lock was dropped. 
> 
> The implication here is that that I don't know locking, and that this was
> done without thought or care.  In fact, I did worry about it and decided it
> was less risky than a locking reduction given my limited cycles (indeed,
> it has been slightly).

Well, part of the context here is that the commit had been bisected as 
being buggy. It turns out the bug was a different issue, but at the same 
time, it very much looked like the locking was simply known a-priori to be 
buggy. No?

And I do agree with the notion that it might have been a "simpler hack for 
a quick fix", and potentially less risky (due to being more targeted to 
the particular problem), when it then causes oopses, the default 
explanation is that the dubious locking trick really was broken. No?

>    That commit also changes the return value semantics of "use_module()", 
>    which is an exported interface where the only users seem to be 
>    out-of-kernel (the only in-kernel use is in kernel/module.c itself). That 
>    seems like a really really bad idea too.
> 
> Again with the implication that this was done without consideration.

No. The implication was that it's wrong to do and a bad idea. Anything 
else is just you reading things into it.

It's an exported interface, and you changed it with no real reason. 
Whether you then talked to users or not is immaterial.

You could easily have just changed the _internal_ thing, and exported the 
unchanged interface.

Even your second version is just very confused. It renames it, but then 
exports the renamed version. What does that help? It still means that the 
external module - for no good reason - needs to have basically a 
source-level version number check.

Why?

It's still unclear to me. No reason for that exported interface change 
seems to exist.

			Linus
