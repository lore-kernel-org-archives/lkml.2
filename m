Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2DYRFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:05:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab2DYRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:05:08 -0400
Date: Wed, 25 Apr 2012 19:02:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425170230.GA24977@redhat.com>
References: <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120425030659.GE6871@ZenIV.linux.org.uk> <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk> <20120425130329.GA16413@redhat.com> <20120425133238.GG6871@ZenIV.linux.org.uk> <20120425145239.GA21386@redhat.com> <20120425154611.GA23672@redhat.com> <20120425161002.GH6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425161002.GH6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Al Viro wrote:
>
> On Wed, Apr 25, 2012 at 05:46:11PM +0200, Oleg Nesterov wrote:
> >
> > 	--- x/arch/x86/kernel/signal.c
> > 	+++ x/arch/x86/kernel/signal.c
> > 	@@ -711,6 +711,13 @@ handle_signal(unsigned long sig, siginfo
> > 				regs->ax = regs->orig_ax;
> > 				regs->ip -= 2;
> > 				break;
> > 	+
> > 	+		case -EINTR:
> > 	+			break;
> > 	+
> > 	+		default:
> > 	+			if (regs->orig_ax == NR_eintr)
> > 	+				regs->ax = NR_eintr;
> > 			}
> > 		}
> > 	
> > 	@@ -791,6 +798,7 @@ static void do_signal(struct pt_regs *re
> > 			case -ERESTARTSYS:
> > 			case -ERESTARTNOINTR:
> > 				regs->ax = regs->orig_ax;
> > 	+			regs->orig_ax = NR_eintr;
> > 				regs->ip -= 2;
> > 				break;
> > 	
> >
> > this ignores ERESTART_RESTARTBLOCK for simplicity.
>
> Ehh...  You do realize that it's that simple only on architectures that
> have syscall number in a register?

No, I do not ;) I simply know nothing about other architectures.

> Take a look at e.g. insert_restart_trampoline()
> in arch/parisc/kernel/signal.c

Will do. Not sure I will be able to undestand it though. And btw I still
didn't look at the signal patches in your tree, I've just returned from
vacation today.

> I'm not sure that SA_RESTART case is actually worth bothering with -

Neither me. But,

> AFAICS, your mechanism won't cover SA_RESTART/SA_RESTART/!SA_RESTART
> combinations anyway,

Confused. The hack above doesn't even try to cover this case (and it is
obviously wrong in ERESTARTSYS/NOINTR case), I only tried to illustrate
the idea.

> 	syscall interrupted
> 		SA_RESTART signal arrives, handler1 entered
> 			!SA_RESTART signal arrives, handler2 entered
> 			handler2 returns
> 		hander1 returns
> 	syscall restarts

And there is another case:

	syscall interrupted, it returns ERESTARTSYS.

	do_signal() sees no signal, restarts the syscall

	!SA_RESTART comes before we return to user-mode

This doesn't really differ from sigsuspend/ERESTARTNOHAND we discussed
before.

Oleg.

