Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2DYQKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:10:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab2DYQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:10:08 -0400
Date: Wed, 25 Apr 2012 17:10:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425161002.GH6871@ZenIV.linux.org.uk>
References: <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120425030659.GE6871@ZenIV.linux.org.uk>
 <20120425123746.GA15560@redhat.com>
 <20120425125042.GF6871@ZenIV.linux.org.uk>
 <20120425130329.GA16413@redhat.com>
 <20120425133238.GG6871@ZenIV.linux.org.uk>
 <20120425145239.GA21386@redhat.com>
 <20120425154611.GA23672@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425154611.GA23672@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 05:46:11PM +0200, Oleg Nesterov wrote:
> OK, I didn't really try to think, and somehow I simply can't wake up today.
> But perhaps we can do something the following? We add the new syscall
> 
> 	sys_eintr(void)
> 	{
> 		return -EINTR;
> 	}
> 
> (perhaps not strictly needed, perhaps we can reuse sys_restart_syscal)
> 
> Now,
> 
> 	--- x/arch/x86/kernel/signal.c
> 	+++ x/arch/x86/kernel/signal.c
> 	@@ -711,6 +711,13 @@ handle_signal(unsigned long sig, siginfo
> 				regs->ax = regs->orig_ax;
> 				regs->ip -= 2;
> 				break;
> 	+
> 	+		case -EINTR:
> 	+			break;
> 	+
> 	+		default:
> 	+			if (regs->orig_ax == NR_eintr)
> 	+				regs->ax = NR_eintr;
> 			}
> 		}
> 	 
> 	@@ -791,6 +798,7 @@ static void do_signal(struct pt_regs *re
> 			case -ERESTARTSYS:
> 			case -ERESTARTNOINTR:
> 				regs->ax = regs->orig_ax;
> 	+			regs->orig_ax = NR_eintr;
> 				regs->ip -= 2;
> 				break;
> 	 
> 
> this ignores ERESTART_RESTARTBLOCK for simplicity.

Ehh...  You do realize that it's that simple only on architectures that
have syscall number in a register?  arm/parisc/unicore32 have really
painful code dealing with restart_syscall(2); building trampoline on
stack and all such...  Take a look at e.g. insert_restart_trampoline()
in arch/parisc/kernel/signal.c (BTW, it doesn't check for put_user()
failures while building that thing).

FWIW, I wonder if e.g. arm would be better off with the following
trick: new flag added to _TIF_SYSCALL_WORK, with __sys_trace checking
it and if it's set, clearing it and simulating sys_restart_syscall().
ERESTART_RESTARTBLOCK would become practically identical to ERESTARTNOHAND,
except that if we decide to restart it we would set the flag.  All the
trampoline crap goes away that way and restart logics gets simpler on
any platform doing that kind of thing.

I'm not sure that SA_RESTART case is actually worth bothering with -
AFAICS, your mechanism won't cover SA_RESTART/SA_RESTART/!SA_RESTART
combinations anyway, and I'm not at all sure that we _want_ to change
user-visible behaviour.  Basically, you have
	syscall interrupted
		SA_RESTART signal arrives, handler1 entered
			!SA_RESTART signal arrives, handler2 entered
			handler2 returns
		hander1 returns
	syscall restarts
and to get behaviour independent of relative timing of those two signals
you'd have to replace the last one with "syscall fails with EINTR".
It's a user-visible change and I'm not at all sure that we won't break
userland code with it.
