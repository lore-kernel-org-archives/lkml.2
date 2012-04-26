Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2DZNxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab2DZNxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:53:54 -0400
Date: Thu, 26 Apr 2012 15:52:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120426135255.GA15600@redhat.com>
References: <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk> <20120425130329.GA16413@redhat.com> <20120425133238.GG6871@ZenIV.linux.org.uk> <20120425145239.GA21386@redhat.com> <20120425154611.GA23672@redhat.com> <20120425161002.GH6871@ZenIV.linux.org.uk> <20120425170230.GA24977@redhat.com> <20120425175113.GI6871@ZenIV.linux.org.uk> <20120426091519.49eef9aa@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426091519.49eef9aa@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Martin Schwidefsky wrote:
>
> On Wed, 25 Apr 2012 18:51:13 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> > do_signal()
> > {
> > 	if (we have any business doing restarts)
> > 		// note: we won't get here on subsequent calls of do_signal()
> > 		// due to the checks above; same logics that currently prevents
> > 		// double restarts
> > 		set NEED_RESTART flag
> > 	sig = get_signal_to_deliver(...)
> > 	if (sig) {
> > 		if (NEED_RESTART set) {
> > 			clear NEED_RESTART
> > 			same thing we do at that spot now - restart or EINTR
> > 			handle_signal(...)
> > 			...
> > 			return;
> > 		}
> > 	}
> > 	/* no handler */
> > 	if (test_and_clear_...(RESTORE_SIGMASK))
> > 		set_current_blocked(&current->saved_sigmask);
> > }
> > and in asm glue, *after* checking for SIGPENDING/NOTIFY_RESUME, check
> > NEED_RESTART and if it's set do what we currently do for restarts on
> > handlerless signal.
>
> You need to be careful with inferior calls there. gdb likes to play games
> with the registers inside the get_signal_to_deliver call, it wants to be
> able to jump out of an interrupted system call, do its inferior call in
> the debugee and then return to the interrupted system call.

Ah.

> You would have to to read, modify & restore the NEED_RESTART flag in gdb
> over an inferior call.

I am not sure, but perhaps this is not really needed...

But at least this means that "if (we have any business doing restarts)"
above is meaningless before get_signal_to_deliver().


And I am confused, off-topic question... How it is possible to
"then return to the interrupted system call" if that system call
returned -ERESTART_RESTARTBLOCK but the inferior call in turn
does the system call which changes restart_block->fn/etc ?

Oleg.

