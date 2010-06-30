Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab0F3F14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 01:27:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47436 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0F3F1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 01:27:55 -0400
Date: Tue, 29 Jun 2010 22:27:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630052752.GL4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
 <20100630004027.GG4837@outflux.net>
 <20100630035609.GA16307@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630035609.GA16307@hallyn.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Tue, Jun 29, 2010 at 10:56:09PM -0500, Serge E. Hallyn wrote:
> Quoting Kees Cook (kees.cook@canonical.com):
> > Some application suites have external crash handlers that depend on
> > being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
> > Since the inferior process generally knows the PID of the debugger,
> > it can use PR_SET_PTRACER to allow a specific PID and its descendants
> > to perform the PTRACE instead of only a direct ancestor.
> > 
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > ---
> 
> Hi Kees - very nice, overall.  One little note though:

Thanks for looking it over!

> >  	rc = cap_ptrace_access_check(child, mode);
> 
> This means that if capable(CAP_SYS_PTRACE) we'll always shortcut
> here, so
> 
> > +	if (mode == PTRACE_MODE_ATTACH &&
> > +	    ptrace_scope &&
> > +	    !capable(CAP_SYS_PTRACE) &&
> > +	    !task_is_descendant(current, child) &&
> > +	    !ptracer_exception_found(current, child))
> > +		rc = -EPERM;
> 
> You don't need the CAP_SYS_PTRACE check here AFAICS.

I don't think that's true -- the capable(CAP_SYS_PTRACE) tests
are always done in the negative since we only ever abort with error
instead of forcing an early "okay" (see also __ptrace_may_access() in
kernel/ptrace.c, where capable(CAP_SYS_PTRACE) is called repeatedly while
evaluating various negative conditions).

For cap_ptrace_access_check, capable(CAP_SYS_PTRACE) is only tested if
the tracee's process permitted caps are not a subset of the tracer's.
i.e. cap_ptrace_access_check will return 0 when either cap_issubset
or capable.  In the case of normal user processes or a tracer
with greater caps, capable(CAP_SYS_PTRACE) will never be tested in
cap_ptrace_access_check.

As a result, I have to include it in the test here too.  I guess it's
arguable that I should move it to the end of the series of &&s, but it
logically doesn't really matter.

-Kees

(Interestingly, this means that having CAP_SYS_PTRACE means a process
effectively has all capabilities...)

-- 
Kees Cook
Ubuntu Security Team
