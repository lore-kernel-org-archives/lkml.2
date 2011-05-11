Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1EKPtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:49:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47764 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1EKPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eTodDqanCoa2Ot6TVlzNAT+k3jV+EDG+HzARZxLtpie1rP+D4AXdfMExfnHLfVNiXA
         4Aqee7cxJYI135ATGzWCMuYsRpVgN12Q0v5Zia5yWthSblRNYnqMIo67ag7V9xJSMK1j
         AgndmfXeKWotogNPqoSnvLCjY34JUvkm2I2dI=
Date: Wed, 11 May 2011 11:05:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110511090551.GC1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <201105110037.34051.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105110037.34051.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Wed, May 11, 2011 at 12:37:34AM +0200, Denys Vlasenko wrote:
> > When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> > is set, which triggers INTERRUPT trap but is sticky until the next
> > PTRACE_GETSIGINFO.
> 
> Why INTERRUPT trap? For group stops, we already have perfectly working
> way to detect such a stop.

Debugger may continue tracee and put it in a different trap.  In such
cases, group stop may be initiated and lifted multiple times while a
tracee is trapped.  It's much nicer to have symmetric notifications in
those cases.

Also, we might end up adding more status flags to si_pt_flags and it's
much better to be able to say "INTERRUPT becomes and stays pending
until the next GETSIGINFO if any of these flags may have chagned" than
"if XXX change from x to y, or YYY changes to x to y or y to x,
... blah blah".

> Can we just add a "group cont" notification which looks like
> a waitpid result with WIFCONTINUED(waitpid_status) == 1 to the tracer?

Consider the following scenario.

1. A syscall traced tracee enters group stop while returning from a
   syscall.  Tracer is notified.

2. SIGCONT generated.  Tracee is woken up and wait state is generated.

3. Tracee traps for syscall completion before tracer has chance to
   wait(2).

4. Oops, continued wait state lost.

Note that generation of another trap can't be used to determine end of
group stop.  It might already have been PTRACE_CONT'd.

This happens because wait states don't queue and shows why edge (or
instance) notifications are usually worse than level ones.  Think
about RT signals which are jokes.

> > Re-trapping is used only for group stop and INTERRUPT traps.  If
> > tracer wants to get notified about group stop, it either leaves tracee
> > in the initial group stop trap or puts it into INTERRUPT trap.  When
> > INTERRUPT trap is scheduled while tracee is already in a trap,
> 
> Sane tracer has no need to do PTRACE_INTERRUPT on a tracee
> which is already stopped (for whatever reason): it already knows
> it's stopped, and why. PTRACE_INTERRUPT is useful to cleanly stop
> _running_ tracees.

1. User wants to continue stopped task to investigate.

2. Investigation done, now the user wants to wait for the end of group
   stop which will happen externally.

3. Regardless of the current trap tracee is in, debugger can schedule
   INTERRUPT and be sure that tracee will trap into INTERRUPT without
   returning to userland and that it will be notified of group stop
   state changes.

According to you, the above use case is insane, which might be true
but I don't really care.  I still want to have gdb which knows how to
do the above.

Thanks.

-- 
tejun
