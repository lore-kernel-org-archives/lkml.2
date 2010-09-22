Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0IVTE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:04:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0IVTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:04:26 -0400
Date: Wed, 22 Sep 2010 20:04:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100922190423.GE19804@ZenIV.linux.org.uk>
References: <20100922.111019.200357319.davem@davemloft.net>
 <20100922183200.GC19804@ZenIV.linux.org.uk>
 <AANLkTi=DWk2_=wMqcM1jgJEuNRj_ni2OkM3osYCUg57Y@mail.gmail.com>
 <20100922185328.GD19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922185328.GD19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 07:53:28PM +0100, Al Viro wrote:

> Um, no.  You've *already* called get_signal_to_deliver().  There had been
> no SIGSEGV in sight.  You happily went on to set a sigframe for e.g.
> SIGHUP, but ran out of stack.  At that point you get force_sigsegv()
> from handle_signal().  _NOW_ you have a pending SIGSEGV; whether you'll
> be able to handle it (e.g. if your SIGSEGV handler is set to run on
> altstack) or not, you won't get to it until you call get_signal_to_deliver()
> again.  Which requires do_signal() to run.
> 
> Sure, it will be the first one to be picked, but we need to try and pick
> _something_ to get it.

PS: on something like x86 that'll happen before we return to userland,
since the glue on syscall exit does that:

int_signal:
        testl $_TIF_DO_NOTIFY_MASK,%edx
        jz 1f
        movq %rsp,%rdi          # &ptregs -> arg1
        xorl %esi,%esi          # oldset -> arg2
        call do_notify_resume
1:      movl $_TIF_WORK_MASK,%edi
int_restore_rest:
        RESTORE_REST
        DISABLE_INTERRUPTS(CLBR_NONE)
        TRACE_IRQS_OFF
        jmp int_with_check

and int_with_check leads back to int_signal if _TIF_SIGPENDING is still set.

That kind of looping happens on everything except sparc and that's exactly
the difference I'm talking about.  On sparc the sucker manages to escape
to userland with SIGSEGV still pending.  Try it and you'll see - simple
signal(SIGHUP, something) + munmap a little bit under your %sp +
raise(SIGHUP), then look at the resulting coredump...  On sparc you'll
get that SIGSEGV later; in fact, putting write(1, "ouch\n", 5); after
that raise() has a good chance of saying ouch before it dumps core.
