Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1ESKTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:19:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1ESKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CHUYLXxK7sO6tmInANAp8D6Fq+2boXLXUNxWf8J1y70ogKYDFz/Pu0LdPALpY7Jdw0
         f+L0N7Xnhzn3AShpnRrtGziec1gTh44s0od9TG66K3SSFc3ZZVcmPsh1QMRN4vSIqp/g
         CPOCqt445Z1DnOg8EArZwW189H2+me/SzSrXc=
Date: Thu, 19 May 2011 12:19:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 02/10] job control: introduce JOBCTL_TRAP_STOP and use
 it for group stop trap
Message-ID: <20110519101930.GC627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-3-git-send-email-tj@kernel.org>
 <20110518164814.GA28848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518164814.GA28848@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, May 18, 2011 at 06:48:14PM +0200, Oleg Nesterov wrote:
> > Although this adds an unlock-relocking between checking of
> > JOBCTL_STOP_PENDING and actually trapping for STOP, this doesn't
> > affect correctness.
> 
> Well, I think it does affect. Although the problem is minor.
> 
> > ptrace_stop() already had conditional unlock-relocking
> 
> Yes, but ptrace_stop() can't send the CLD_STOPPED notfication before
> the tracee is ready for do_wait(WNOHANG). Contrary, get_signal_to_deliver()
> can if we race with SIGCONT.

That CLD_STOPPED notification is actually for continuation (although
it's indistinguishible from actual stopped notification) and as such
the ptracer has to query the tracee state after the notification
signal and can't expect it to be in TRACED.  Please consider the
following scenario.

1. thread t1 and t2.  t1 is ptraced.  Both running.

2. SIGSTOP delivered by t2.  Group stop starts.

3. SIGCONT is generated before t1 participates.

4. t1 will enter get_signal_to_deliver() and deliver CLD_STOPPED but
   won't trap.

So, I don't think this affects correctness.  The above can happen if
both t1 and t2 are attached by the same ptracer.  What changes is that
it now may happen with single thread too.  We can put STOP trap before
CONTINUED notification but I don't think that's necessary.

> > While at it, add proper function comment to do_signal_stop() and make
> > it return bool.
> > ...
> >
> > + * RETURNS:
> > + * %false if group stop is already cancelled and nothing happened.  %true
> > + * if participated in group stop.
> 
> Well, the traced task didn't participate yet... Nevermind.

Eh, should have read this earlier.  :-)

> So far I can't really understand why do we have both JOBCTL_TRAP_STOP and
> and JOBCTL_TRAPPING... Please ignore, I didn't read other patches yet.

JOBCTL_TRAP_STOP is the renamed JOBCTL_TRAP_INTERRUPT.  It's a trap
condition while TRAPPING is synchronization flag to protect -> TRACED
transitions.  JOBCTL_TRAP_STOP might not be the best name, but it
isn't INTERRUPT trap anymore JOBCTL_TRAP_GROUP_STOP or
JOBCTL_TRAP_GSTOP seemed a bit inconsistent with other flags.

> Hmm. And afaics there is a bug in do_signal_stop(), after
> "[PATCH 6/9] job control: make task_clear_jobctl_pending() clear TRAPPING automatically"
> ->jobctl &= ~JOBCTL_STOP_SIGMASK is no longer safe. We can clear _TRAPPING
> without wakeup.

Hmmm?  ->jobctl &= ~JOBCTL_STOP_SIGMASK clears lower sixteen bits.
All the flags including TRAPPING live in the upper sixteen bits.

Thank you.

-- 
tejun
