Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2BKX1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:27:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49723 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2BKX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:27:44 -0500
Date: Sat, 11 Feb 2012 23:27:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: hexagon: signal handling bugs
Message-ID: <20120211232740.GM23916@ZenIV.linux.org.uk>
References: <20110817163457.878854582@codeaurora.org>
 <20110817163521.165013232@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817163521.165013232@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1) unless I'm seriously misreading hexagon vm_entry.S, once we'd
called do_notify_resume, we do *not* recheck if there's more work to
be done.  In particular, if we'd got more signals pending - e.g. from
SIGSEGV we'd got while trying to set a sigframe up.  That's not a good
thing for a lot of reasons.  Note that once that is fixed, you'll need
to make sure that restart logics is applied only *once* - not for subsequent
sigframes.

	2) sigreturn should *NOT* be restartable at all, or you'll get
a lot of hard-to-reproduce fun.  AFAICS, the right thing to do would
be to set ->syscall_nr to something negative, not __NR_rt_sigreturn in there
(and return regs->r00 instead of 0, to avoid the check in do_trap0).
Reason: suppose you have e.g. a loop that runs through different values in
r00.  No syscalls in it.  A signal comes and gets treated on the way
out of kernel after the next e.g. timer interrupt.  We save the values
of registers into a sigframe and go into the handler.  Another signal
comes; the next time we reach the kernel is when we get to rt_sigreturn().
There we
	* have registers restored from on-stack sigframe
	* have ->syscall_nr set to __NR_rt_sigreturn
	* hit handle_signal() on the way out
	* check ->r00; note that this is the value we have just restored
from sigframe.  If it happens to be -ERESTARTNOHAND, silently replace it
with -EINTR.  And eventually return to clueless userland.
Result: if timer interrupt happens when the userland loop goes through
-ERESTARTNOHAND, the value of r00 is clobbered upon return from signal handler.
Fun debugging that kind of bugs: priceless...

	3) on sigreturn we need to set current->restart_block.fn; hexagon
doesn't do that.

	4) altstack can overflow; you don't check that.  See
commit 83bd01024b1fdfc41d9b758e5669e80fca72df66
Author: Roland McGrath <roland@redhat.com>
Date:   Wed Jan 30 13:30:06 2008 +0100
for an analog.

	5) try_to_freeze() has no business being called in do_signal();
let get_signal_to_deliver() handle that.

I don't have any access to hardware *or* cross-toolchain, so all I can do
here is RTFS and review.  For #2..#5 I would not be afraid to post untested
patches (they are essentially trivial), but #1 is well beyond my arrogance
threshold - messing in assembler glue on an architecture I don't know *and*
can't test...  Sorry.
