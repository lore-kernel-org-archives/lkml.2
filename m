Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2D3IHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:07:06 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:52839 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2D3IHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:07:02 -0400
Date: Mon, 30 Apr 2012 10:06:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120430100637.299b67b3@de.ibm.com>
In-Reply-To: <20120429041205.GY6871@ZenIV.linux.org.uk>
References: <20120424072617.GB6871@ZenIV.linux.org.uk>
	<20120426183742.GA324@redhat.com>
	<20120426231942.GJ6871@ZenIV.linux.org.uk>
	<20120427172444.GA30267@redhat.com>
	<20120427184528.GL6871@ZenIV.linux.org.uk>
	<20120427202002.8ED632C0BF@topped-with-meat.com>
	<20120427211244.GO6871@ZenIV.linux.org.uk>
	<20120427212729.652542C0AF@topped-with-meat.com>
	<20120427231526.GP6871@ZenIV.linux.org.uk>
	<20120427233235.GQ6871@ZenIV.linux.org.uk>
	<20120429041205.GY6871@ZenIV.linux.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12043008-8372-0000-0000-000002686E2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2012 05:12:05 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, Apr 28, 2012 at 12:32:35AM +0100, Al Viro wrote:
> > On Sat, Apr 28, 2012 at 12:15:26AM +0100, Al Viro wrote:
> > 
> > > I think all such architectures need that check lifted to do_notify_resume()
> > > (and the rest needs it killed, of course).  Including x86, by the look
> > > of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
> > > !user_mode(regs), but I'm not entirely sure of that.  arm is in about the
> > > same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
> > > there like that (they all check it in the asm glue).  mips probably might,
> > > unless I'm misreading their ret_from_fork()...  Fun.
> > 
> > 	Speaking of user_mode() oddities - may I politely inquire what had
> > been smoked to inspire this (in arch/s390/kernel/signal.c):
> >         /* This is the legacy signal stack switching. */
> >         else if (!user_mode(regs) &&
> >                  !(ka->sa.sa_flags & SA_RESTORER) &&
> >                  ka->sa.sa_restorer) {
> >                 sp = (unsigned long) ka->sa.sa_restorer;
> >         }
> > especially when all paths leading to that come through do_signal() that does
> >         if (!user_mode(regs))
> >                 return;
> > on the same regs.  It had been like that since 2.3.99pre8 when s390 went
> > into the tree...  It looks vaguely similar to i386
> >                         /* This is the legacy signal stack switching. */
> >                         if ((regs->ss & 0xffff) != __USER_DS &&
> >                                 !(ka->sa.sa_flags & SA_RESTORER) &&
> >                                         ka->sa.sa_restorer)
> >                                 sp = (unsigned long) ka->sa.sa_restorer;
> > but there the code is at least not unreachable...
> 
> While we are at it, can we *ever* reach do_signal() (nevermind deep in its
> guts) with !user_mode(regs)?
> AFAICS, for 31bit possible paths are:
> do_signal()
> 	<- sysc_sigpending
> 		<- sysc_work
> 			<- sysc_tif, having checked for user_mode(%r11)
> 	<- io_sigpending
> 		<- io_work_tif
> 			<- io_work_user
> 				<- io_work, having checked for user_mode(%r11)
> 
> and identical for 64bit.  *All* paths into do_signal() go through
>         tm      __PT_PSW+1(%r11),0x01   # returning to user ?
> and proceed towards do_signal() only if the bit is set.  Which is precisely
> what user_mode(%r11) is...
> 
> What the hell is going on in that code?

Cut-copy-paste from x86. You are correct that do_signal is only ever called
with user_mode(regs) == 1. This allows us to remove the !user_mode() check
in do_signal and the SA_RESTORER thingy in get_sigframe. I once contemplated
to remove the SA_RESTORER option altogether, because a user space restorer
does not make much sense for s390. The user space restorer needs to 
1) restore all registers, and 2) branch back to the interrupted code.
For 2) we need a register which makes 1) impossible to do.
I still have that patch lying around on my hard drive.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

