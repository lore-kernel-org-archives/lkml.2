Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1EKPgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:36:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38953 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1EKPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BAXMv8Mf3k30//6Rg5sO0p9RLqx2M0sTJB6UBQdG7qz0dRSEelYrwaf9kC3rU/svH7
         FU19NHJGkd8B57YnTMdRfrizRdeO1w4YX8L0CC8Aj2z/cXzWNuOh7rzMy+rHvkPjXO16
         /ZAT71C+pcf4dLu3jrQPhtvpy9UO/0h3hD8Is=
Date: Wed, 11 May 2011 10:08:52 +0200
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
Message-ID: <20110511080852.GA1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-7-git-send-email-tj@kernel.org>
 <20110510165545.GA30198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510165545.GA30198@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 10, 2011 at 06:55:45PM +0200, Oleg Nesterov wrote:
> IOW, if the tracee reports via ptrace_notify*, the tracee can look at
> si_pt_flags == stop-in-effect. If the tracer reports a signal, the
> tracer obviously lacks this info, hmm.

Which indicates tracee is in group stop trap.

> Probably I need more time to get used to this... But at first glance
> this looks a bit unnatural. Say, can't we simply implement
> PTRACE_GET_GROUP_STOP_STATUS request which returns this (and probably
> more) info?

I don't know.  PTRACE_GETSIGINFO seemed to already fit the bill and I
want to avoid introducing a new request if at all possible.  It sure
is a bit quirky but doesn't compromisea functionality.

> > __SI_TRAP is defined to implement copying of
> > the new field to userland.
> 
> Heh. I am shy to admit, I didn't know copy_siginfo_to_user() trims
> si_code, that is why your change is correct but I spent a lot of time
> before I was able to understand this.

Oh, don't be shy.  I scratched my head for quite a while trying to
figure out why the hell the new flag field isn't getting out to
userland.  It's an ugly piece of sh*t.  :-)

> > 		  if (!ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si)) {
> > 			  if (si.si_code) {
> > 				  stopped = !!si.si_status;
> 
> In this case this "si_code != 0" check is correct, but how can the
> tracer detect this case in general?

This was quick hack.  Proper test would look like,

	si.si_code && (si.si_pt_flags & PTRACE_SI_STOPPED)

> > @@ -540,6 +542,17 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
> > +	if ((child->ptrace & PT_SEIZED) &&
> > +	    (info->si_code & (0x7f | ~0xffff)) == (__SI_TRAP | SIGTRAP)) {
> 
> Can't we simply check (from->si_code & __SI_MASK) == __SI_TRAP ?

Right, I originally lifted the test from ptrace_notify() before adding
__SI_TRAP and forgot to update it later.  Will change.

> > +		/* report whether group stop is in effect w/ SI_STOPPED */
> > +		if (sig->group_stop_count || (sig->flags & SIGNAL_STOP_STOPPED))
> 
> We have more and more "group_stop_count || SIGNAL_STOP_STOPPED" checks,
> perhaps we should make a helper. Or at least invent the short name to
> denote the group-stopped-or-in-progress to simplify the discussions ;)

Yeah, how about group_stop_in_effect()?

> Still, this is strange. With this change ptrace_getsiginfo() reports
> the extra "volatile" info which wasn't reported by the tracee itself.
> If the tracer does PTRACE_SETSIGINFO twice in a row, it can see the
> different si_pt_flags's.

(answering to both get/setsiginfo concerns)

* I think we better block PTRACE_SETSIGINFO for non signal delivery
  traps.  It doesn't make any sense.  Let's just fail that with
  -EINVAL if PT_SEIZED.

* I don't think PTRACE_GETSIGINFO returning volatile information to be
  problematic.  The information is generated on the fly on trap
  anyway.  For non signal delivery traps, PTRACE_GETSIGINFO is
  basically (ab)using siginfo as a container for debugging
  information.  It might have been better if something else was used
  from the beginning but the damage is already done and I don't see
  too much benefit in making things pretty at this point.

Thank you.

-- 
tejun
