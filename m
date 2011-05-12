Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1ELRQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:16:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58832 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab1ELRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s5pg2dHUpl7tuhuEA1CFCZxB/eTx88rIwW8GS0vysO4aXyRFBijhjt0a6NDR7hmwEA
         zUH3RnAxIULoK7t+g8OkH26udRR28mXITPQMjOjTjLKuCFQ0qhD1rZnPc8iXyBSiv4Z1
         74zaK881r7xjcxQWJjVbH1my5XpntCr5o9x6M=
Date: Thu, 12 May 2011 19:15:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20110512171553.GM1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-7-git-send-email-tj@kernel.org>
 <20110510165545.GA30198@redhat.com>
 <20110511080852.GA1661@htj.dyndns.org>
 <20110512164745.GA20215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512164745.GA20215@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 06:47:45PM +0200, Oleg Nesterov wrote:
> On 05/11, Tejun Heo wrote:
> >
> > On Tue, May 10, 2011 at 06:55:45PM +0200, Oleg Nesterov wrote:
> > > IOW, if the tracee reports via ptrace_notify*, the tracee can look at
> > > si_pt_flags == stop-in-effect. If the tracer reports a signal, the
> > > tracer obviously lacks this info, hmm.
> >
> > Which indicates tracee is in group stop trap.
> 
> What do you mean?

I meant that whether group stop is in effect or not can be determined
reliably in most cases.  The only exception is signal delivery trap as
siginfo there isn't from trap but I think we can survive that.

> si_pt_flags doesn't "exist" when the tracee reports the signal or
> CLD_STOPPED. This doesn't look clean.

Sure, it ain't clean.  Fully agreed.

> > I don't know.  PTRACE_GETSIGINFO seemed to already fit the bill and I
> > want to avoid introducing a new request if at all possible.  It sure
> > is a bit quirky but doesn't compromisea functionality.
> 
> I am not sure too, but the new request is much simpler to use, and it
> is more extensible. We can report more info. Say, the state of
> JOBCTL_STOP_CONSUME or something else.

Functionality-wise, I don't think GETSIGINFO is worse.  We can add
more flags and fields there too.  It sure is cumbersome to use because
the information isn't there for signal delivery and group stop traps;
however, both aren't critical.  Debugger can simply force INTERRUPT
trap and get it there.

> > This was quick hack.  Proper test would look like,
> >
> > 	si.si_code && (si.si_pt_flags & PTRACE_SI_STOPPED)
> 
> This doesn't look right too? How can we know we can trust si_pt_flags?
> This needs some YES_YOU_CAN_CHECK_si_pt_flags(si_code), but I can't
> understand what it should do right now...

Ah, okay, you were asking how to tell si has the SIGTRAP info.  IIUC,
si_code is non-zero iff the information is generated from kernel so
testing lower bits against SIGTRAP should be good enough.  It can't
happen by user generated signals.  The only way to side step that
would be using PTRACE_SETSIGINFO - but that's the debugger shooting
its own foot.  I don't feel particularly sympathetic.

> > > We have more and more "group_stop_count || SIGNAL_STOP_STOPPED" checks,
> > > perhaps we should make a helper. Or at least invent the short name to
> > > denote the group-stopped-or-in-progress to simplify the discussions ;)
> >
> > Yeah, how about group_stop_in_effect()?
> 
> Or may me signal_stop_stopped(struct signal_struct *sig), like
> signal_group_exit/SIGNAL_GROUP_EXIT. But I am fine with
> group_stop_in_effect, probably it is more explanatorily.

Given that stop might be in progress (not complete yet), I think a
name which clearly notes that is preferable.  signal_stpo_stopped()
sounds like it's already stopped.

> > * I think we better block PTRACE_SETSIGINFO for non signal delivery
> >   traps.  It doesn't make any sense.  Let's just fail that with
> >   -EINVAL if PT_SEIZED.
> 
> Oh I agree, it does not make any sense. Should we change the current
> behaviour for PT_SEIZED? I don't really care, this looks minor.

Hmmm... I don't wanna change PTRACE_ATTACH behavior unless necessary.
The pt_flags part isn't even reported if ATTACHed.

> > * I don't think PTRACE_GETSIGINFO returning volatile information to be
> >   problematic.  The information is generated on the fly on trap
> >   anyway.
> 
> Yes. And I'd understand if si_pt_flags was filled by the tracee
> during the trap (although I do not think this makes sense) to record
> the state at the time of this trap.
> 
> But PTRACE_GETSIGINFO returns the dynamic info which reflects the
> process-wide state at the time of syscall.

Hmmm... Well, if we're gonna introduce a new request, it's gonna have
to be able to replace PTRACE_GETSIGINFO.  I don't wanna ask userland
to make two ptrace requests on each trap to tell what's going on.

Another point is that most programs would have to support pre-SEIZE
behavior as well so I'd like to avoid deviating the interface too much
if possible.

If you combine the two, we basically end up something which carries
both siginfo and something else at one go.  Its semantics can
definitely be made prettier, I agree, but I'm not sure whether the
benefits would be enough to justify a new request.  Maybe it would be.

If you can propose something sane, it would be awesome.

Thanks.

-- 
tejun
