Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1FBVJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:09:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52868 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1FBVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=f9oAP0ez6y6E2f2f0qTTLSZnXika6+znqj6mbY5XgaqEb8jmaMAkMJhaiF02CBpTvg
         06EcItoYVjqTZzs346dEBnqzN9HhAjvMiSgzQk3WL7g5QP0N9GJpkHoGPdi7xISWSz8q
         yo6D4yEIF3Z1jbyIBQWiYhPB4SD5Te/dzxDUA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Thu, 2 Jun 2011 23:09:44 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <20110602123105.GD10410@mtj.dyndns.org> <20110602182744.GA21705@redhat.com>
In-Reply-To: <20110602182744.GA21705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106022309.44663.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 June 2011 20:27, Oleg Nesterov wrote:
> Hi Tejun,
> 
> On 06/02, Tejun Heo wrote:
> >
> > I've tested threaded one and INTERRUPT immediate re-triggering and at
> > least the apparent cases work fine.  I've re-generated the git tree on
> > top of 3.0-rc1 with the updated patches.
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize
> 
> Everything looks fine to me.
> 
> I feel we can cleanup this code a little bit, but we can do this later.
> 
> Only one thing. I think it makes sense to discuss the idea from Denys,
> 
> > * Which signo to use in exit_code on STOP traps.
> 
> Yes. other pending issues can be solved later.
> 
> So,
> 
> 	static void ptrace_do_notify(int exit_code, int why)
> 	{
> 		info.si_signo = SIGTRAP;
> 		info.si_code = __SI_TRAP | exit_code;
> 
> 		if ((current->ptrace & PT_SEIZED) &&
> 		    (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED)) {
> 			info.si_pt_flags |= PTRACE_SI_STOPPED;
> 			info.si_signo = current->jobctl & JOBCTL_STOP_SIGMASK;
> 			WARN_ON_ONCE(!info.si_signo);
> 		}
> 
> 	}
> 
> Can't we set si_pt_flags only if PTRACE_EVENT_STOP? Afaics, this
> should be enough to support the jobctl tracking.
> 
> If yes, then can't we encode si_pt_flags in task->exit_code which
> is "visible" to wait?
> 
> IOW, ptrace_do_notify(PTRACE_EVENT_STOP) path should use
> 
> 	exit_code = signr | PTRACE_EVENT_STOP<<8;
> 
> and signr is roughly calculated as
> 
> 	if (group_stop_count || SIGNAL_STOP_STOPPED)
> 		signr = jobctl & JOBCTL_STOP_SIGMASK;
> 	else if (JOBCTL_TRAP_NOTIFY)
> 		signr = SIGCONT;
> 	else
> 		signr =  SIGTRAP; // PTRACE_INTERRUPT
> 
> In this case we can avoid all siginfo changes. The tracer does wait(status)
> anyway, it can see the state without GETSIGINFO. The only problem, the tracer
> should be careful to avoid the confusion with ptrace_signal(), it should
> check status & (PTRACE_EVENT_STOP << 16).
> 
> What do you think?

This should alleviate Linus' concerns that we are suffering from unnecessary
featuritis - that we invent API which is significantly different
from existing one, and as such users will not use it.

Existing API doesn't use GETSIGINFO data per se to distinguish group-stop from
signal-delivery-stop, it uses the fact that GETSIGINFO fails on group-stop.
(Well, arguably it's not a "designed" API, more like "accidentally created API",
but nevertheless it exists right now). Oleg's proposal means that the new way
may be makde to work very similarly.

The less we deverge in handling of group-stop from existing API while fixing it,
the better. If the only thing strace needs to change is to issue PTRACE_LISTEN
instead of PTRACE_CONT on group-stop, then it's wonderful.

I understand that this patchset doesn't do exactly that yet, but it appears
it can be achieved relatively easy by a future change. Don't take this
as a request to respin the patchset yet again.

-- 
vda
