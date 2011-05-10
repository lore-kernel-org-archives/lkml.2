Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1EJRNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 13:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1EJRNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 13:13:04 -0400
Date: Tue, 10 May 2011 19:11:06 +0200
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
Message-ID: <20110510171106.GA32637@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-7-git-send-email-tj@kernel.org> <20110510165545.GA30198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510165545.GA30198@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Oleg Nesterov wrote:
>
> > @@ -540,6 +542,17 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
> >
> >  	error = 0;
> >  	*info = *child->last_siginfo;
> > +
> > +	/*
> > +	 * If reporting ptrace trap for a seized tracee, enable reporting
> > +	 * of info->si_pt_flags.
> > +	 */
> > +	if ((child->ptrace & PT_SEIZED) &&
> > +	    (info->si_code & (0x7f | ~0xffff)) == (__SI_TRAP | SIGTRAP)) {
>
> Can't we simply check (from->si_code & __SI_MASK) == __SI_TRAP ?
>
> > +		/* report whether group stop is in effect w/ SI_STOPPED */
> > +		if (sig->group_stop_count || (sig->flags & SIGNAL_STOP_STOPPED))
>
> We have more and more "group_stop_count || SIGNAL_STOP_STOPPED" checks,
> perhaps we should make a helper. Or at least invent the short name to
> denote the group-stopped-or-in-progress to simplify the discussions ;)
>
>
> Still, this is strange. With this change ptrace_getsiginfo() reports
> the extra "volatile" info which wasn't reported by the tracee itself.
> If the tracer does PTRACE_SETSIGINFO twice in a row, it can see the
                     ^^^^^^^^^^^^^^^^^
                     PTRACE_GETSIGINFO
> different si_pt_flags's.

Forgot to mention... Probably we can ignore this but the tracer can
set/clear __SI_TRAP via PTRACE_SETSIGINFO, after that PTRACE_GETSIGINFO
changes its behaviour.

Oleg.

