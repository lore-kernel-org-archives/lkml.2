Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab1ESQ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:57:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62334 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab1ESQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rvuX8jsx9l4ygvLuGqGjxiukrRIs5QuX1eqWmH8JQlC012gvJa4rLB6CzzBcU/Fsnm
         tufc8W/7xa05BTlhsPzcJ8w+fT9pjJOUBCkvvfh9evqFbQ1xrXtqY4GCVUg6yLVNn053
         +KTkDje4kozUHHEP7GXPol3TXWSfRCySKNDPs=
Date: Thu, 19 May 2011 18:57:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110519165722.GP627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-11-git-send-email-tj@kernel.org>
 <20110519163246.GF17265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519163246.GF17265@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, May 19, 2011 at 06:32:46PM +0200, Oleg Nesterov wrote:
> > +static void ptrace_trap_notify(struct task_struct *t)
> > +{
> > +	siginfo_t *si = t->last_siginfo;
> > +
> > +	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
> > +	assert_spin_locked(&t->sighand->siglock);
> > +
> > +	/*
> > +	 * @t is being ptraced and new SEIZE behavior is in effect.
> > +	 * Schedule sticky trap which will clear on the next GETSIGINFO.
> > +	 */
> > +	t->jobctl |= JOBCTL_TRAP_NOTIFY;
> 
> This is also set by do_signal_stop(). Cleared by PTRACE_GETSIGINFO.
> 
> How can this work? Doesn't this mean PTRACE_GETSIGINFO becomes mandatory
> before PTRACE_CONT? IOW, unless the tracee does PTRACE_GETSIGINFO to clear
> this bit, PTRACE_CONT just leads to another trap, no?

Yes, group stop state change raises a sticky trap condition which is
cleared by GETSIGINFO.

> > +	if (task_is_traced(t) && si && si->si_code == PTRACE_STOP_SI_CODE) {
> 
> OK, this PTRACE_STOP_SI_CODE check is clear. But the same check in
> ptrace_check_attach() looks confusing, why can't we set BLOCK_NOTIFY
> unconditionally?

It's an optimization.  If we set the flag, we'll have to acquire
siglock and clear it before returning to userland.  Setting
BLOCK_NOTIFY isn't necessary unless tracee is in TRAP_STOP, so...

> > +		t->jobctl |= JOBCTL_TRAPPING;
> > +		if (!(t->jobctl & JOBCTL_BLOCK_NOTIFY))
> > +			signal_wake_up(t, true);
> 
> Could you please remind me why we can't avoid the awful ptrace_wait_trapping()
> in do_wait() paths? Assuming that ptrace_check_attach() does this. I got lost
> a bit.

Please consider the following scenario.

1. Tracee is in group stop and stops at TRAP_STOP notifying the
   tracer.

2. Tracer does WNOWAIT wait(2) and determines that the tracee is
   trapped in TRAP_STOP.

3. Something generates SIGCONT which finishes the group stop and
   triggers the notification re-trapping.

4. While tracee is re-trapping, tracer issues WNOHANG wait(2)
   expecting it to succeed but the tracee could be RUNNING for re-trap
   thus failing WNOHANG wait(2).

> So. The tracee reports PTRACE_EVENT_STOP, debugger issues a lot of PTRACE_
> requests. The tracee can report another trap "in between". Looks confusing...
> Perhaps I need to get used to it.

Yes, and the reported trap doesn't interfere with wait(2) or ptrace
requests.  Trapping is the only event notification mechanism available
from tracee to tracer and we already have interface to wait and poll
them, so I think it makes sense to use it.

Thank you.

-- 
tejun
