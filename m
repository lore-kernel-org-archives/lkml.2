Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2JNTYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:24:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43689 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2JNTYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:24:05 -0400
Date: Sun, 14 Oct 2012 20:24:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [revert request for commit 9fff2fa] Re: [git pull] signals pile 3
Message-ID: <20121014192402.GZ2616@ZenIV.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
 <20121014164020.GV2616@ZenIV.linux.org.uk>
 <CACTFLAOpcLtHNx-TCHQkUOPNAkTO8EgDhbyZSGQ9ag+Wu_cNRw@mail.gmail.com>
 <20121014172640.GW2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014172640.GW2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 06:26:40PM +0100, Al Viro wrote:
> and the last 3 make no sense whatsoever.  Note that on normal execve() we'll
> be going through the syscall return, so the userland will see 0 in there,
> no matter what do we do here.  Theoretically, it might've been done for
> ptrace sake (it will be able to observe the values in those registers before
> the tracee reaches userland),

Except that it won't be able to see what start_thread() puts in r0 either;
on successful exceve(2) we will store return value of sys_execve() (i.e. 0)
in regs->ARM_r0 before we get to any of the places where it could have
examine the sucker.  So what was that assignment for?  And as far as I can
see, ARM ELF ABI says that general register values on process startup are
undefined, so r1 and r2 assignments also seem to be pointless.  OTOH, they
predate the ELF conversion by quite a but - that code had been there since
1.x times, when we used to use a.out...  In any case, they were *not* going
to be usable as main() arguments - zero argc would make userland rather
unhappy.  I don't have arm libc sources from those times, but I'd expect
it to have all those suckers read from userland stack...

Russell, could you recall what those had been about?  I'm not sure if that
had been oopsable that far back (again, oops scenario is userland stack
page getting swapped out before we get to start_thread(), leading to
direct read from an absent page in start_thread() by plain ldr, without
anything in exception table about that insn), but it looks very odd
regardless of that problem.
