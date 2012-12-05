Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2LESjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:39:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38903 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2LESjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:39:24 -0500
Date: Wed, 5 Dec 2012 18:39:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/44] Meta Linux Kernel Port
Message-ID: <20121205183923.GY4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <20121205171131.GV4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205171131.GV4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 05:11:32PM +0000, Al Viro wrote:
> On Wed, Dec 05, 2012 at 04:08:18PM +0000, James Hogan wrote:
> 
> > other work not included:
> > * switch to generic kernel_{thread,execve} (will be posted separately to
> >   aid review)
> 
> > other changes:
> ...
> > * switch to generic sys_execve
> 
> ... which should've broken your kernel_execve().

BTW, one general note: lose the magical 7th argument.  In the few syscalls
that do need pt_regs, you can bloody well use current_pt_regs() instead;
it's what, (register & constant) + constant?  Passing it as explicit
argument is saving at most two arithmetical insns on those syscalls.
Moreover, for fork/clone/vfork we really don't need it until copy_thread();
one of the changes in -next kills passing pt_regs * to do_fork() and through
all that call chain (furthermore, if you make that
	childregs->ctx.AX[0].U0 = ALIGN(usp, 8);
in copy_thread() conditional on usp != 0, you can go with generic
variants from kernel/fork.c; again, see linux-next for examples of that).
What's left?  sigreturn and sigaltstack?

Seriously, drop that struct pt_regs *; it makes things uglier, (slightly)
hurts the syscall overhead and doesn't help the few syscalls that even
look at that argument.
