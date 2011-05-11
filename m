Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1EKQao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:30:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58919 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab1EKQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w9ObSga924utljCGwFLosaq2I8ypxJzxEkEdsfvRbU8MHSaEEgGiiEZCA+AjZRidHd
         naZokuAzhoyU999QN7SPNgk3vbj2619hMiljxFy2qdkcxUnqi1zfTHHRfdQXrPv8thHl
         z+U/UovSD2a5/lpftiz+Q4Ee1DnmF3TZ7NlXw=
Date: Wed, 11 May 2011 11:19:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110511091955.GD1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105102359.58900.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, May 10, 2011 at 11:59:58PM +0200, Denys Vlasenko wrote:
> Tejun, why exactly do you want userspace to always see INTERRUPT stop?
> 
> If tracer did ptrace(PTRACE_INTERRUPT), it wants tracee to stop.
> It then goes to waitpid, and whatever stop it sees, it handles.
> I don't see any problem if it instead happens to see, say, a signal delivery
> stop, and no INTERRUPT stop after that, ever. No information is lost.
> 
> Therefore, we can merge SEIZE and INTERRUPT bits into one
> (or drop SEIZE bit altogether, if we decide that SEIZE doesn't stop).

First of all, I think it's cleaner that way - if you ask for
INTERRUPT, you get an INTERRUPT.  Secondly, because INTERRUPT trap is
special regarding retrapping notifications and there will be cases
where debugger wants to put a tracee into INTERRUPT trap and it will
be pretty annoying to do that safely if INTERRUPT disappears on each
trap and/or INTERRUPT doesn't work if tracee is already trapped.

> Then, NOTIFY bit.
> Tejun, let us know why did you design group stop notification
> in a "sticky" way. Is it because of some races with SIGSTOP/SIGCONT?
> From userspace POV, it's not obvious why we can't just have
> *one* INTERRUPT stop (that is, non-sticky one) every time there
> is a group stop state change. Tracer can retrieve status via
> GETSIGINFO just like as provided by your patch, but it doesn't
> absolutely has to: it can simply CONT the tracee.

Design like that is fragile like hell.  Going back to the debugging
stopped tracee case I talked about in another reply, let's say
debugger issues PTRACE_CONT at the same time SIGCONT is generated.
Tracee will continue execution and debugger would believe that the
trap was continued by it and be oblivious about the SIGCONT which
raced with PTRACE_CONT.

> (
> No, a bit different. Not
> "every time there is a group stop state change"
> but
> "every time there is a SIGCONT which releases tracee from group stop"
> - because group stop notification is _already_ delivered
> to the tracer, even by the current kernel's code,
> and it is already detectable (by observing that GETSIGINFO
> fails on it) and we can avoid changing this.
> )
> Therefore, NOTIFY bit is also not needed. Only INTERRUPT bit is.
> Unless I miss something...

As I replied in another message, group stop may also be initiated
while a tracee is INTERRUPT trapped.

Those different TRAP bits are invisible to userland.  The only changes
visible from userland are new ptrace requests - PTRACE_SEIZE and
PTRACE_INTERRUPT, and a new trap condition - PTRACE_EVENT_INTERRUPT.

PTRACE_EVENT_INTERRUPT traps are mostly side-effect-less and I'm
planning on documenting specifically that it may seem spurious and the
debugger should only rely on the information obtained from GETSIGINFO.

> Another note: even though PTRACE_INTERRUPT solves the problem that
> PTRACE_DETACH of a running tracee was butt-ugly thing to do correctly,
> the "new" way is still a bit ugly: tracer needs PTRACE_INTERRUPT,
> waitpid, and only then PTRACE_DETACH. Why not go all the way
> and make PTRACE_DETACH work on running tracee too?

I don't think I'll change that.  It's only three syscall sequence -
INTERRUPT, wait(STOPPED) and DETACH which will always work reliably
(unless tracee gets killed or something).  It might be nice but
ultimately unnecessary and pre-SEIZE ptrace would have to be supported
for a very long time anyway so I don't see much point in deviating
DETACH behavior when there is no new capability to gain by doing so.

Thank you.

-- 
tejun
