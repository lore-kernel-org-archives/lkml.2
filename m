Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1FQTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1FQTKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:10:51 -0400
Date: Fri, 17 Jun 2011 21:08:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#4
Message-ID: <20110617190837.GA18917@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <201106031125.16071.pedro@codesourcery.com> <20110616083828.GJ8141@htj.dyndns.org> <201106161056.17798.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161056.17798.pedro@codesourcery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Pedro Alves wrote:
>
> On Thursday 16 June 2011 09:38:28, Tejun Heo wrote:
> > On Fri, Jun 03, 2011 at 11:25:15AM +0100, Pedro Alves wrote:
> > > It'd be _very_ useful for x86 (and others) to have
> > > something like TRAP_BRKPT for int3.  Both for ptracers
> > > and in-process self debuggers.
> > >
> > > I'd be super happy to be told we have that already
> > > in recent kernels and I missed it.  :-)
> >
> > Unfortunately, AFAICS, x86 doesn't have it nor is there a generic
> > mechanism, but this should be solvable without disrupting existing
> > users.
>
> Hmm, looks like there was an earlier attempt:
>
> <http://lkml.indiana.edu/hypermail/linux/kernel/0809.2/1898.html>
>
> Reading that thread, there were some minor revisions, but I didn't
> see any objection.  It seems that patch made it 2.6.28 (the only
> sources I have handy), as I see get_si_code calls in arch/x86/kernel/traps.c,
> and arch/x86/include/asm/traps.h.

Yes, this works (I think). But this handles the X86_EFLAGS_TF case, for
example PTRACE_SINGLESTEP.

> But, I'm running 2.6.38, x86-64, and
>
> #include <stdio.h>
> #include <string.h>
> #include <signal.h>
>
> static void
> handler (int sig, siginfo_t *info, void *context)
> {
>   printf ("si_code = %x\n", info->si_code);
> }
>
> int
> main (void)
> {
>   struct sigaction action;
>
>   memset (&action, 0, sizeof (action));
>   action.sa_sigaction = handler;
>   action.sa_flags |= SA_SIGINFO;
>   sigaction (SIGTRAP, &action, NULL);
>
>   asm volatile ("int3");
>
>   return 0;
> }
>
> still prints:
>
> $ ./trap
> si_code = 80

Yes. do_int3() simply calls force_sig(SIGTRAP). Trivial to change, I think.

Oleg.

