Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1ELQti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044Ab1ELQtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:49:36 -0400
Date: Thu, 12 May 2011 18:47:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org
Subject: Re: [PATCH 06/11] ptrace: make group stop state visible via
	PTRACE_GETSIGINFO
Message-ID: <20110512164745.GA20215@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-7-git-send-email-tj@kernel.org> <20110510165545.GA30198@redhat.com> <20110511080852.GA1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511080852.GA1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> On Tue, May 10, 2011 at 06:55:45PM +0200, Oleg Nesterov wrote:
> > IOW, if the tracee reports via ptrace_notify*, the tracee can look at
> > si_pt_flags == stop-in-effect. If the tracer reports a signal, the
> > tracer obviously lacks this info, hmm.
>
> Which indicates tracee is in group stop trap.

What do you mean?

si_pt_flags doesn't "exist" when the tracee reports the signal or
CLD_STOPPED. This doesn't look clean.

> > Probably I need more time to get used to this... But at first glance
> > this looks a bit unnatural. Say, can't we simply implement
> > PTRACE_GET_GROUP_STOP_STATUS request which returns this (and probably
> > more) info?
>
> I don't know.  PTRACE_GETSIGINFO seemed to already fit the bill and I
> want to avoid introducing a new request if at all possible.  It sure
> is a bit quirky but doesn't compromisea functionality.

I am not sure too, but the new request is much simpler to use, and it
is more extensible. We can report more info. Say, the state of
JOBCTL_STOP_CONSUME or something else.

> > > 		  if (!ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si)) {
> > > 			  if (si.si_code) {
> > > 				  stopped = !!si.si_status;
> >
> > In this case this "si_code != 0" check is correct, but how can the
> > tracer detect this case in general?
>
> This was quick hack.  Proper test would look like,
>
> 	si.si_code && (si.si_pt_flags & PTRACE_SI_STOPPED)

This doesn't look right too? How can we know we can trust si_pt_flags?
This needs some YES_YOU_CAN_CHECK_si_pt_flags(si_code), but I can't
understand what it should do right now...

> > > +		/* report whether group stop is in effect w/ SI_STOPPED */
> > > +		if (sig->group_stop_count || (sig->flags & SIGNAL_STOP_STOPPED))
> >
> > We have more and more "group_stop_count || SIGNAL_STOP_STOPPED" checks,
> > perhaps we should make a helper. Or at least invent the short name to
> > denote the group-stopped-or-in-progress to simplify the discussions ;)
>
> Yeah, how about group_stop_in_effect()?

Or may me signal_stop_stopped(struct signal_struct *sig), like
signal_group_exit/SIGNAL_GROUP_EXIT. But I am fine with
group_stop_in_effect, probably it is more explanatorily.

> > Still, this is strange. With this change ptrace_getsiginfo() reports
> > the extra "volatile" info which wasn't reported by the tracee itself.
> > If the tracer does PTRACE_SETSIGINFO twice in a row, it can see the
> > different si_pt_flags's.
>
> (answering to both get/setsiginfo concerns)
>
> * I think we better block PTRACE_SETSIGINFO for non signal delivery
>   traps.  It doesn't make any sense.  Let's just fail that with
>   -EINVAL if PT_SEIZED.

Oh I agree, it does not make any sense. Should we change the current
behaviour for PT_SEIZED? I don't really care, this looks minor.

> * I don't think PTRACE_GETSIGINFO returning volatile information to be
>   problematic.  The information is generated on the fly on trap
>   anyway.

Yes. And I'd understand if si_pt_flags was filled by the tracee
during the trap (although I do not think this makes sense) to record
the state at the time of this trap.

But PTRACE_GETSIGINFO returns the dynamic info which reflects the
process-wide state at the time of syscall.

Oleg.

