Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0DARaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab0DARaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:30:09 -0400
Date: Thu, 1 Apr 2010 10:27:44 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-Id: <20100401102744.a4e6f24d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org>
References: <20100325194100.GA2364@debian>
	<20100331134048.da4e35a7.akpm@linux-foundation.org>
	<4BB3B4DB.7040904@kernel.org>
	<20100331135220.c6695a51.akpm@linux-foundation.org>
	<4BB3BAD6.50308@zytor.com>
	<alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 09:13:31 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
> > 
> > The obvious way to fix this would be to use
> > spin_lock_irqsave..spin_lock_irqrestore in __down_read as well as in the
> > other locations; I don't have a good feel for what the cost of doing so
> > would be, though.  On x86 it's fairly expensive simply because the only
> > way to save the state is to push it on the stack, which the compiler
> > doesn't deal well with, but this code isn't used on x86.
> 
> I think that's what we should just do, with a good comment both in the 
> code and the changelog. I'm not entirely happy with it, because obviously 
> it's conceptually kind of dubious to take a lock with interrupts disabled 
> in the first place, but this is not a new issue per se.
> 
> The whole bootup code is special, and we already make similar guarantees 
> about memory allocators and friends - just because it's too dang painful 
> to have some special code that does GFP_ATOMIC for early bootup when the 
> same code is often shared and used at run-time too.
> 
> So we've accepted that people can do GFP_KERNEL allocations and we won't 
> care about them if we're in the boot phase (and suspend/resume), and we 
> have that whole 'gfp_allowed_mask' thing for that.
> 
> I think this probably falls under exactly the same heading of "not pretty, 
> but let's not blow up".
> 
> So making the slow-path do the spin_[un]lock_irq{save,restore}() versions 
> sounds like the right thing. It won't be a performance issue: it _is_ the 
> slow-path, and we're already doing the expensive part (the spinlock itself 
> and the irq thing).

It's actually on the fastpath for lib/rwsem-spinlock.c.

> So ACK on the idea. Who wants to write the trivial patch and test it? 
> Preferably somebody who sees the problem in the first place - x86 should 
> not be impacted, since the irq-disabling slow-path should never be hit 
> without contention anyway (and contention cannot/mustnot happen for this 
> case).
> 
> 			Linus
