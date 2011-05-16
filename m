Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1EPMIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:08:55 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:34662 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221Ab1EPMIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:08:54 -0400
Date: Mon, 16 May 2011 14:08:22 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace: implement
 PTRACE_INTERRUPT]
Message-ID: <20110516120822.GA10469@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <20110515161000.GE31855@host1.jankratochvil.net>
 <20110515163523.GH23665@htj.dyndns.org>
 <20110515173940.GA26241@host1.jankratochvil.net>
 <20110516090125.GP23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516090125.GP23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 11:01:25 +0200, Tejun Heo wrote:
> On Sun, May 15, 2011 at 07:39:40PM +0200, Jan Kratochvil wrote:
> > #include <unistd.h>
> > #include <sys/wait.h>
> > #include <sys/ptrace.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > static int status;
> > static pid_t child;
> > void
> > handler (int signo)
> > {
> >   puts ("PASS");
> >   exit (0);
> > }
> > /* Ensure CHILD is stopped even if it is running now - for PTRACE_DETACH.  */
> > void
> > stop_child_for_detach (void)
> > {
> >   kill (child, SIGCONT);	/* To be PTRACE_INTERRUPT in the future.  */
> >   /* The problem - here a signal may get lost.  */
> >   wait (&status);
> > }
> > int
> > main (void)
> > {
> >   child = fork ();
> >   switch (child)
> >     {
> >     case 0:
> >       signal (SIGUSR2, handler);
> >       ptrace (PTRACE_TRACEME, 0, NULL, NULL);
> >       raise (SIGUSR1);
> >       puts ("FAIL");
> >       exit (1);
> >     default:
> >       wait (&status);
> >       /* Sent by arbitrary external program.  */
> >       kill (child, SIGUSR2);
> >       /* Comment out for PTRACE_DETACH not requiring stopped tracee.  */
> > #if 1
> >       ptrace (PTRACE_CONT, child, NULL, NULL);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> You can lose signal here.

Not here but there should be PTRACE_CONT in stop_child_for_detach.

That SIGUSR1 was intended to be dropped - it was there just to get stopped by
PTRACE_TRACEME.


> You must check which trap happened why and then take action accordingly.
> Argh... we really need better documentation of ptrace behaviors and traps.

We could misunderstand each other here.  Sure I know where is the problem.
Just demonstration that writing correct `stop_child_for_detach' is not easy
and naive programmer may write it looking right and working right during
development but in fact it will break debuggees in corner cases.


> Nope.  What userland is currently dealing with isn't that type of
> conditions.  It's dealing with nasty side effects of implied and
> required signals, which will be removed with the new interface.

They won't as there will be new INTERRUPT event and when one wants to trap it
one has to deal with various signals coming before or after it.


> Those attach/detach sync points are currently in the kernel and wouldn't
> change with the proposed updates.  You're suggesting to remove them.

I am suggesting not to introduce the existing pain into new API.


Thanks,
Jan
