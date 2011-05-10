Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1EJQ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab1EJQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:57:51 -0400
Date: Tue, 10 May 2011 18:55:45 +0200
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
Message-ID: <20110510165545.GA30198@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> Ptracer can detect tracee entering group stop by watching for the
> group stop trap; however, there is no reliable way to find out when
> group stop ends - SIGCONT may be processed by another thread and
> signal delivery is blocked while tracee is trapped.

Confused.

> This patch adds siginfo.si_pt_flags and uses PTRACE_SI_STOPPED flag to
> indicate whether group stop is in effect or not.  While tracee is
> trapped for anything other than signal delivery and group stop itself,
> tracer can use PTRACE_GETSIGINFO to access this information.  Note
> that it's only available if tracee was seized.

IOW, if the tracee reports via ptrace_notify*, the tracee can look at
si_pt_flags == stop-in-effect. If the tracer reports a signal, the
tracer obviously lacks this info, hmm.

Probably I need more time to get used to this... But at first glance
this looks a bit unnatural. Say, can't we simply implement
PTRACE_GET_GROUP_STOP_STATUS request which returns this (and probably
more) info?

> Later patches will deal with
> notification and trap transition.

OK, probably I'll understand the intent later.

> __SI_TRAP is defined to implement copying of
> the new field to userland.

Heh. I am shy to admit, I didn't know copy_siginfo_to_user() trims
si_code, that is why your change is correct but I spent a lot of time
before I was able to understand this.

>   int main(int argc, char **argv)
>   {
> 	  pid_t tracee, tracer;
> 	  int i;
>
> 	  tracee = fork();
> 	  if (!tracee)
> 		  while (1)
> 			  nanosleep(&ts1s, NULL);
>
> 	  tracer = fork();
> 	  if (!tracer) {
> 		  int last_stopped = 0, stopped;
> 		  siginfo_t si;
>
> 		  ptrace(PTRACE_SEIZE, tracee, NULL,
> 			 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
> 	  repeat:
> 		  waitid(P_PID, tracee, NULL, WSTOPPED);
>
> 		  if (!ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si)) {
> 			  if (si.si_code) {
> 				  stopped = !!si.si_status;

In this case this "si_code != 0" check is correct, but how can the
tracer detect this case in general?

> @@ -540,6 +542,17 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
>
>  	error = 0;
>  	*info = *child->last_siginfo;
> +
> +	/*
> +	 * If reporting ptrace trap for a seized tracee, enable reporting
> +	 * of info->si_pt_flags.
> +	 */
> +	if ((child->ptrace & PT_SEIZED) &&
> +	    (info->si_code & (0x7f | ~0xffff)) == (__SI_TRAP | SIGTRAP)) {

Can't we simply check (from->si_code & __SI_MASK) == __SI_TRAP ?

> +		/* report whether group stop is in effect w/ SI_STOPPED */
> +		if (sig->group_stop_count || (sig->flags & SIGNAL_STOP_STOPPED))

We have more and more "group_stop_count || SIGNAL_STOP_STOPPED" checks,
perhaps we should make a helper. Or at least invent the short name to
denote the group-stopped-or-in-progress to simplify the discussions ;)


Still, this is strange. With this change ptrace_getsiginfo() reports
the extra "volatile" info which wasn't reported by the tracee itself.
If the tracer does PTRACE_SETSIGINFO twice in a row, it can see the
different si_pt_flags's.

Oleg.

