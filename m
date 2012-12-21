Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2LUHPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:15:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LUHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:15:22 -0500
Date: Fri, 21 Dec 2012 07:15:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: CONFIG_GENERIC_SIGALTSTACK with asm-generic/syscalls.h (was Re:
 [git pull] signal.git pile 2)
Message-ID: <20121221071518.GR4939@ZenIV.linux.org.uk>
References: <20121221002100.GM4939@ZenIV.linux.org.uk>
 <50D40088.3030304@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D40088.3030304@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 11:54:08AM +0530, Vineet Gupta wrote:
> On Friday 21 December 2012 05:51 AM, Al Viro wrote:
> > sigaltstack infrastructure + conversion for x86, alpha and um,
> > COMPAT_SYSCALL_DEFINE infrastructure.  Note that there are several
> > conflicts between "unify SS_ONSTACK/SS_DISABLE definitions" and
> > UAPI patches in mainline; resolution is trivial - just remove definitions
> > of SS_ONSTACK and SS_DISABLED from arch/*/uapi/asm/signal.h; they are
> > all identical and include/uapi/linux/signal.h contains the unified
> > variant.  Please, pull from
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
> > 
> 
> Hi Arnd,
> 
> In Linus' tree with above merged, selecting CONFIG_GENERIC_SIGALTSTACK
> is causing build issues for ARC port (and possibly others as well) which
> use asm-generic/syscalls.h due to a different prototype for
> sys_sigaltstack coming in from linux/syscalls.h
> 
> While I can band-aid ARC port by #define sys_sigaltstack before
> including asm-generic, it might be better if we conditional-ize one of
> the prototypes. Following works for me.

	TBH, the plan was to use such band-aids until all ports using
asm-generic/syscalls.h switch to generic and we drop the damn prototype
from there.  But yes, what you are suggesting would also do.

	As for asm-generic/syscalls.h, it should simply die out.  Look:
sys_sigaltstack() eventually goes to linux/syscalls.h, where it ought
to be anyway.  sys_rt_sigreturn() should be there as well - and it should
be long (void); current_pt_regs() is there for purpose...
sys_rt_sigsuspend() and and should go into linux/syscalls.h too - the
only obstacle is mips and it can simply drop its private implementation
and use the generic one.  Et cetera...

	I hope to kill it completely in the next cycle, along with quite
a few things in arch/*/include/asm/syscalls.h.  FWIW, the plan for this
cycle signal.git is to put a bunch of generic variants of syscalls into
kernel/signal.c (we have a lot of pointless code duplication, mostly
in compat ones) and start a bunch of no-rebase arch-$ARCH branches at
that point, as it had been done for kernel_thread series - i.e. safely
mergable into architecture git trees and going to Linus either that way
or through signal.git, preferably the former.  sigaltstack(2) definitely
should get unified by the end of that, and I hope to get several kilolines
of code killed in compat stuff.
