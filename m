Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab0FAEFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:05:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab0FAEFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:05:14 -0400
Date: Mon, 31 May 2010 21:00:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
In-Reply-To: <201006011312.22198.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1005312051390.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org> <201006011107.35722.rusty@rustcorp.com.au> <201006011312.22198.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Rusty Russell wrote:
> 
> But this is ugly:
> 
> > +       use = kmalloc(sizeof(*use), GFP_ATOMIC);
> > +       if (!use) {
> > +               printk("%s: out of memory loading\n", a->name);
> > +               module_put(b);
> > +               return 0;
> 
> The module_get is in the caller, but the module_put is here on failure.
> Don't half split-out a function like this.

I agree. That happened as part of moving the code around mostly 
mechanically, but you're right, that fixup is better done in the caller 
that did the get.

Also, looking at it, I don't think that should be GFP_ATOMIC. I wonder why 
it is. I don't think we should have recursion issues with memory freeing 
needing new modules due to IO/filesystem accesses, but maybe there are 
cases like that. But again, that was just moving old code around.

And with the old "use_module()" having done a wait, we can't have had 
people calling this from atomic contexts. So I wonder where that 
GFP_ATOMIC comes from. It goes all the way back to the original in-kernel 
module loader code in 2002 according to git.

Oh. And back then, it was inside a "modlist_lock". And that lock is long 
gone, but the GFP_ATOMIC remains.

Of course, it's a small data structure, and there aren't many of them, so 
nobody would ever notice. It's just an oddity right now.

Anyway, modified patch looks fine to me.

		Linus
