Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2DYRvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:51:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37336 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2DYRvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:51:22 -0400
Date: Wed, 25 Apr 2012 18:51:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425175113.GI6871@ZenIV.linux.org.uk>
References: <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120425030659.GE6871@ZenIV.linux.org.uk>
 <20120425123746.GA15560@redhat.com>
 <20120425125042.GF6871@ZenIV.linux.org.uk>
 <20120425130329.GA16413@redhat.com>
 <20120425133238.GG6871@ZenIV.linux.org.uk>
 <20120425145239.GA21386@redhat.com>
 <20120425154611.GA23672@redhat.com>
 <20120425161002.GH6871@ZenIV.linux.org.uk>
 <20120425170230.GA24977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425170230.GA24977@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 07:02:30PM +0200, Oleg Nesterov wrote:

> And there is another case:
> 
> 	syscall interrupted, it returns ERESTARTSYS.
> 
> 	do_signal() sees no signal, restarts the syscall
> 
> 	!SA_RESTART comes before we return to user-mode
> 
> This doesn't really differ from sigsuspend/ERESTARTNOHAND we discussed
> before.

... and dealt with the same way:
	NEED_RESTART flag is set the first time around
	no handler for the first signal, so we do nothing else
	handler is found for the second signal
	NEED_RESTART flag is present, so
		we clear NEED_RESTART
		we look at errno and see ERESTARTSYS
		we check sa_flags and see !SA_RESTART
		we set return value to -EINTR and proceed to set sigframe up
	on the exit to userland we see NEED_RESTART not set, so off we go
I think I hadn't been clear enough; here's pseudocode for what I meant

do_signal()
{
	if (we have any business doing restarts)
		// note: we won't get here on subsequent calls of do_signal()
		// due to the checks above; same logics that currently prevents
		// double restarts
		set NEED_RESTART flag
	sig = get_signal_to_deliver(...)
	if (sig) {
		if (NEED_RESTART set) {
			clear NEED_RESTART
			same thing we do at that spot now - restart or EINTR
			handle_signal(...)
			...
			return;
		}
	}
	/* no handler */
	if (test_and_clear_...(RESTORE_SIGMASK))
		set_current_blocked(&current->saved_sigmask);
}
and in asm glue, *after* checking for SIGPENDING/NOTIFY_RESUME, check
NEED_RESTART and if it's set do what we currently do for restarts on
handlerless signal.

BTW, if we combine that with ERESTART_RESTARTBLOCK trick on arm/parisc/unicore,
there won't be much work to do for restarts in that case; in x86ese it
would be simply
	if (regs->ax == -ERESTART_RESTARTBLOCK)
		set_thread_flag(TIF_EMULATE_RESTART_SYSCALL)
	regs->ax = regs->orig_ax;
	regs->ip -= 2;
all of that conditional on TS_NEED_RESTART...
