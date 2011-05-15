Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab1EORZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:25:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62776 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1EORZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ftIpPn7HUOAWocCKGwtsekH5vtigvUGLgypJcEjVw2tiXZb2ZVdoglX0YlO1rgAakD
         c4rgcrZz1MabZidb1du8qIdftKrH4vOJWCeEmBELNW6FepvQ6hZfBINXdY0f3xQ8rKX/
         UNSNR/Su9yy7BNY3CHJdsAotgz8EqPKti0fSw=
Date: Sun, 15 May 2011 19:25:05 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110515172505.GL23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515171512.GA24047@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 07:15:12PM +0200, Jan Kratochvil wrote:
> On Sun, 15 May 2011 18:26:30 +0200, Tejun Heo wrote:
> > the code to SEIZE and establish initial state would be simple.
> 
> In normal case yes; but one needs to handle all the corner cases when the
> first signal is not INTERRUPT; which one usually does not handle as during
> development (=in normal cases) it is always INTERRUPT.
> 
> Such thing is even difficult to test in QA testcases as in some cases one just
> cannot reproduce the (in current case) non-SIGSTOP signal arriving as first
> one.

Understood.  AFAICS, there will be two different initial traps
(they're not signals!) which can happen - signal delivery trap and
INTERRUPT (renamed to STOP) trap.  We should be able to exclude signal
delivery trap from happening as the first trap.  Oleg, can you think
of other traps which could happen right after SEIZE?

Maybe this is best solved with a test case which can reliably trigger
different initial traps sites?

> > How long does it take to attach to / detach from 10000+ threads?  If
> > you don't do it serially, it shouldn't take that long.
> 
> It is not (such) a problem it takes time.  It is a problem it stops the tracee
> for a moment which completely changes the tracee's racy behavior one tries to
> debug.

Okay, timing artifacts.  Yes, it is a valid point but I'm still not
sure.  Let's think about it.

> > You can tell them apart from userland and it doesn't matter which order or
> > how many times INTERRUPT occurs.
> 
> I must know in which order they come to know when the tracee is still stopped
> and I collect the signals to be displayed to the user and at which moment
> there are no more signals in the queue and I start waiting on the debuggee
> which started running.
> 
> Otherwise I can workaround it by various waitpid(NOHANG)s but it is better if
> the ordering and when INTERRUPT is / is not reported is well defined.

Hmmm... you should be able to tell that without resorting to WNOHANG
or depending on order of traps.  That's the goal anyway.  I'm a bit
confused tho.  What do you mean by "the tracee is still stopped"?
Tracee is always stopped (or rather trapped) after reporting a trap.

Thanks.

-- 
tejun
