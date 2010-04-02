Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0DBPAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:00:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab0DBPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:00:37 -0400
Date: Fri, 2 Apr 2010 07:54:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
In-Reply-To: <28599.1270219574@redhat.com>
Message-ID: <alpine.LFD.2.00.1004020748540.3634@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004011310210.3707@i5.linux-foundation.org> <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331135220.c6695a51.akpm@linux-foundation.org> <4BB3BAD6.50308@zytor.com>
 <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org> <20100401102744.a4e6f24d.akpm@linux-foundation.org>  <28599.1270219574@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, David Howells wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Ahh, yes. In this case, that doesn't likely change anything. The 
> > save/restore versions of the irq-safe locks shouldn't be appreciably more 
> > expensive than the non-saving ones. And architectures that really care 
> > should have done their own per-arch optimized version anyway.
> 
> That depends on the CPU.  Some CPUs have quite expensive interrupt disablement
> instructions.  FRV does for instance; but fortunately, on the FRV, I can use
> some of the excessive quantities of conditional registers to pretend that I
> disable interrupts, and only actually do so if an interrupt actually happens.

I think you're missing the part where we're not _adding_ any irq disables: 
we're just changing the unconditional irq disable to a save-and-disable 
(and the unconditional irq enable to a restore).

So even if irq's are expensive to disable, the change from

	spin_lock_irq()

to

	spin_lock_irqsave()

won't make that code any more expensive.

> > Maybe we should even document that - so that nobody else makes the mistake 
> > x86-64 did of thinking that the "generic spinlock" version of the rwsem's 
> > is anything but a hacky and bad fallback case.
> 
> In some cases, it's actually the best way.  On a UP machine, for instance,
> where they reduce to nothing or where your only atomic instruction is an XCHG
> equivalent.

Again, you seem to think that we used to have just a plain spin_lock. Not 
so. We currently have a spin_lock_irq(), and it is NOT a no-op even on UP. 
It does that irq disable.

Anyway, I suspect that even with just an atomic xchg, you can do a better 
job at doing down_read() than using the generic spin-lock version (likely 
by busy-looping on a special "we're busy" value). But if you do want to 
use the generic spin-lock version, I doubt any architecture makes that 
irqsave version noticeable slower than the unconditional irq version.

		Linus
