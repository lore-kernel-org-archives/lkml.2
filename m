Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2DZNXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab2DZNXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:23:05 -0400
Date: Thu, 26 Apr 2012 15:22:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120426132203.GA14401@redhat.com>
References: <20120425030659.GE6871@ZenIV.linux.org.uk> <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk> <20120425130329.GA16413@redhat.com> <20120425133238.GG6871@ZenIV.linux.org.uk> <20120425145239.GA21386@redhat.com> <20120425154611.GA23672@redhat.com> <20120425161002.GH6871@ZenIV.linux.org.uk> <20120425170230.GA24977@redhat.com> <20120425175113.GI6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425175113.GI6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Al Viro wrote:
>
> do_signal()
> {
> 	if (we have any business doing restarts)
> 		// note: we won't get here on subsequent calls of do_signal()
> 		// due to the checks above; same logics that currently prevents
> 		// double restarts
> 		set NEED_RESTART flag
> 	sig = get_signal_to_deliver(...)
> 	if (sig) {
> 		if (NEED_RESTART set) {
> 			clear NEED_RESTART
> 			same thing we do at that spot now - restart or EINTR
> 			handle_signal(...)
> 			...
> 			return;
> 		}
> 	}
> 	/* no handler */
> 	if (test_and_clear_...(RESTORE_SIGMASK))
> 		set_current_blocked(&current->saved_sigmask);
> }

OK,

> and in asm glue,

Ah. So we are going to change the ret_from_sys_call-like code.

> check
> NEED_RESTART and if it's set do what we currently do for restarts on
> handlerless signal.

and probably we should clear NEED_RESTART?

OK, thanks, I am starting to understand.

However. Perhaps I missed something, but this doesn't look 100% correct.
Although even _if_ I am right I guess this is pure theoretical problem.

Suppose that we restart the syscall which returned ERESTARTNOHAND. I mean,
the task has already returned to the user-mode and CPU is going to execute
the syscall insn.

What if, say, reschedule interrupt comes before the task enters the kernel
again? The new signal can come before this task returns to the user-mode,
ret_from_intr: will notice it and it is still possible to run a signal
handler before re-entering the syscall.

No?

Oleg.

