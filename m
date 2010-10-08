Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0JHFhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:37:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab0JHFhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:37:01 -0400
Date: Fri, 8 Oct 2010 06:36:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Maciej W. Rozycki" <macro@codesourcery.com>
Cc: David Daney <ddaney@caviumnetworks.com>, Al Viro <viro@ftp.linux.org.uk>,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 3/5] mips: sanitize restart logics
Message-ID: <20101008053656.GU19804@ZenIV.linux.org.uk>
References: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk>
 <4CA38538.8000007@caviumnetworks.com>
 <alpine.DEB.1.10.1009300218380.25860@tp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1009300218380.25860@tp.orcam.me.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 02:50:17AM +0100, Maciej W. Rozycki wrote:
> On Wed, 29 Sep 2010, David Daney wrote:
>  Not exactly.  These GNU C library functions rely on the magic value of 
> "1" there to recognise contexts they created themselves and which must 
> therefore be handled by themselves internally (these contexts are not 
> complete and only preserve the call-saved registers as specified by the 
> respective MIPS ABIs, and are therefore unsafe to be passed to the 
> rt_sigreturn(2) syscall).  All the other values, including of course "0", 
> are not treated specially and the context is passed to rt_sigreturn(2) as 
> usually.  This only matters in cases where e.g. setcontext(3) is used to 
> exit from or return to a signal handler.

Nothing has changed in that respect; setup_sigcontext() (and its counterparts)
do _not_ use regs->regs[0].  Note
        err |= __put_user(0, &sc->sc_regs[0]);
        for (i = 1; i < 32; i++)
                err |= __put_user(regs->regs[i], &sc->sc_regs[i]);
in there.  The whole point of ->regs[0] uses (both original and modified)
is that $0 is constant 0 and thus the kernel is free to use that member
of pt_regs to indicate that syscall restart might be needed.  So's libc,
for that matter (to distinguish between sigreturn and setcontext ones).
When sigframe is created we still discard the value - the fragment above
is not modified at all.

BTW, with original code regs->regs[0] *can* be 1, if you are leaving syscall
with -EINVAL.  It won't reach the userland, though.
