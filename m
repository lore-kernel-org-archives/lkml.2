Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1FQSdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab1FQSds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:33:48 -0400
Date: Fri, 17 Jun 2011 20:31:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 4/5] ptrace: implement TRAP_NOTIFY and use it for group
	stop events
Message-ID: <20110617183118.GA8375@redhat.com>
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <1308043218-23619-5-git-send-email-tj@kernel.org> <20110616195138.GB14786@redhat.com> <20110617151236.GI2611@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617151236.GI2611@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Thu, Jun 16, 2011 at 09:51:38PM +0200, Oleg Nesterov wrote:
> > I already applied this series. But somehow I have the fuzzy feeling we
> > can simplify JOBCTL_TRAP_NOTIFY/JOBCTL_TRAP_STOP logic later. No, I can't
> > explain what I mean ;)
>
> Heh, yeah, please go ahead.
>
> > One question,
> >
> > > @@ -1797,8 +1824,10 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> > >  	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
> > >  		gstop_done = task_participate_group_stop(current);
> > >
> > > -	/* any trap clears pending STOP trap */
> > > +	/* any trap clears pending STOP trap, STOP trap clears NOTIFY */
> > >  	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
> > > +	if (info && info->si_code >> 8 == PTRACE_EVENT_STOP)
> > > +		task_clear_jobctl_pending(current, JOBCTL_TRAP_NOTIFY);
> >
> > OK, but can't we check why == CLD_STOPPED instead of PTRACE_EVENT_STOP?
>
> Yeap, sure.  The reason why I used PTRACE_EVENT_STOP was because
> PTRACE_LISTEN needs the same test and it doesn't have access to @why.
> Maybe it's better to create ptrace_is_trap_stop(si)?

Sure, PTRACE_EVENT_STOP have to look at info (although we could add
another JOBCTL_ bit). But since ptrace_stop() checks CLD_STOPPED anyway
we could do

	if (why == CLD_STOPPED) {
		if (current->jobctl & JOBCTL_STOP_PENDING)
			gstop_done = task_participate_group_stop(current);
		task_clear_jobctl_pending(current, JOBCTL_TRAP_NOTIFY);
	}

as a microcleanup. OK, please forget, this is minor.

> > In fact, can't we move all code above under 'if (why == CLD_STOPPED)' ?
> > JOBCTL_TRAP_STOP can't be set otherwise, no? I am almost sure I missed
> > something though.
>
> JOBCTL_TRAP_STOP should also be cleared on CLD_TRAPPED traps.

Yes, this is clear

> ie. If
> the ptracer does PTRACE_INTERRUPT

Ah, indeed, I forgot about PTRACE_INTERRUPT. Thanks.

Oleg.

