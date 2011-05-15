Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab1EOQ0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:26:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab1EOQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R3KAlIiiFuV1YLVx6kspAvV46qlmmQatBqRDsFeTS1HgeeNfr8U0Rd2xIzE5Zm4Bx6
         RoHT10rX3JB14+ccu6ECGAUpfpWf/rYJBe8L+Zow48gls1XLn/rv1M8H8thnTGNxppp5
         fGMa/hqV3Vc1XA5SJujQq6KntvvpbYKbYFs2o=
Date: Sun, 15 May 2011 18:26:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110515162630.GG23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515155602.GD31855@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Sun, May 15, 2011 at 05:56:02PM +0200, Jan Kratochvil wrote:
> It was already addressed by me before so I will give more reasons:
> 	https://lkml.org/lkml/2011/3/1/309

Hmmm... I don't think the argument given in the message is valid.  The
new trap doesn't have any side effect (other than possible syscall
restart (or -EINTR failure) and performance overhead) so there
wouldn't be any problem from correctness POV and the code to SEIZE and
establish initial state would be simple.

> GDB already has mode `set observer on' (in this case we are interested in its
> part `set may-interrupt off') - see: $ info '(gdb)Observer Mode'
> 	# If you want to [...] observe program behavior without any chance of
> 	# disruption by GDB
> This is an increasingly requested feature as one of the ways of monitoring.

Hmmm... transparency.  Other than signal_wakeup (syscall restart /
-EINTR), there is no side effect of SEIZE - from transparency POV,
this should be considered fully transparent.  signal_wakeup can happen
anytime even without signals.  It's an integral part of the
programming interface.  I don't know.  Maybe.

> There are also requests to handle applications using 10000+ threads, which
> currently have problems with GDB.  One can imagine a needless
> waitpid+PTRACE_CONT is not a help.

Yeap, performance could be a legitimate concern but then again I'm not
sure here either - the whole thing is quite slow and not trapping on
SEIZE might not amount to all that much.  Again, maybe.

How long does it take to attach to / detach from 10000+ threads?  If
you don't do it serially, it shouldn't take that long.

> > Which trap will happen isn't fixed.  If other trap conditions exist (signal
> > delivery or group stop), they might be taken; otherwise, a trap with
> > exit_code SIGTRAP | (PTRACE_EVENT_INTERRUPT << 8) is taken.
> 
> What if PTRACE_INTERRUPT is called by tracer only after the tracee has stopped
> on a signal delivery?  It should be ignored in such case - as the first signal
> will not be PTRACE_EVENT_INTERRUPT.  (Sorry if you have stated it somewhere.)

I think you're somewhat confused here.  Well, ptrace manpage is pretty
confused too.  Those are different traps.  You can tell them apart
from userland and it doesn't matter which order or how many times
INTERRUPT occurs.

Thanks.

-- 
tejun
