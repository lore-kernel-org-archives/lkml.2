Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2D2EMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 00:12:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35838 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2D2EML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 00:12:11 -0400
Date: Sun, 29 Apr 2012 05:12:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429041205.GY6871@ZenIV.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427233235.GQ6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 12:32:35AM +0100, Al Viro wrote:
> On Sat, Apr 28, 2012 at 12:15:26AM +0100, Al Viro wrote:
> 
> > I think all such architectures need that check lifted to do_notify_resume()
> > (and the rest needs it killed, of course).  Including x86, by the look
> > of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
> > !user_mode(regs), but I'm not entirely sure of that.  arm is in about the
> > same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
> > there like that (they all check it in the asm glue).  mips probably might,
> > unless I'm misreading their ret_from_fork()...  Fun.
> 
> 	Speaking of user_mode() oddities - may I politely inquire what had
> been smoked to inspire this (in arch/s390/kernel/signal.c):
>         /* This is the legacy signal stack switching. */
>         else if (!user_mode(regs) &&
>                  !(ka->sa.sa_flags & SA_RESTORER) &&
>                  ka->sa.sa_restorer) {
>                 sp = (unsigned long) ka->sa.sa_restorer;
>         }
> especially when all paths leading to that come through do_signal() that does
>         if (!user_mode(regs))
>                 return;
> on the same regs.  It had been like that since 2.3.99pre8 when s390 went
> into the tree...  It looks vaguely similar to i386
>                         /* This is the legacy signal stack switching. */
>                         if ((regs->ss & 0xffff) != __USER_DS &&
>                                 !(ka->sa.sa_flags & SA_RESTORER) &&
>                                         ka->sa.sa_restorer)
>                                 sp = (unsigned long) ka->sa.sa_restorer;
> but there the code is at least not unreachable...

While we are at it, can we *ever* reach do_signal() (nevermind deep in its
guts) with !user_mode(regs)?
AFAICS, for 31bit possible paths are:
do_signal()
	<- sysc_sigpending
		<- sysc_work
			<- sysc_tif, having checked for user_mode(%r11)
	<- io_sigpending
		<- io_work_tif
			<- io_work_user
				<- io_work, having checked for user_mode(%r11)

and identical for 64bit.  *All* paths into do_signal() go through
        tm      __PT_PSW+1(%r11),0x01   # returning to user ?
and proceed towards do_signal() only if the bit is set.  Which is precisely
what user_mode(%r11) is...

What the hell is going on in that code?
