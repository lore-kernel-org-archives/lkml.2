Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1EORkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:40:07 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:57697 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751048Ab1EORkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:40:05 -0400
Date: Sun, 15 May 2011 19:39:40 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace: implement
 PTRACE_INTERRUPT]
Message-ID: <20110515173940.GA26241@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <20110515161000.GE31855@host1.jankratochvil.net>
 <20110515163523.GH23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515163523.GH23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Sun, 15 May 2011 18:35:23 +0200, Tejun Heo wrote:
> On Sun, May 15, 2011 at 06:10:00PM +0200, Jan Kratochvil wrote:
> > But having to PTRACE_INTERRUPT the tracee before PTRACE_DETACH has no
> > advantage, it is just a performance (see transparent tracking of 10000+ thread
> > 	https://lkml.org/lkml/2011/5/15/115
> > ) problem and also getting it correct.  As when one wait()s and gets
> > WIFSTOPPED one needs to respawn to signal otherwise the signal gets lost on
> > PTRACE_ATTACH.  How to respawn it?  By PTRACE_INTERRUPT with DATA==signal?
> > Or PTRACE_CONT with DATA==signal?  With rapid signalling of the tracee the
> > debugger may never have a chance to correctly quit.  Handling other cases
> > transparently for the original parent also may not be fully clear.
[...]
> Hmmm... you seem to be a bit confused about different ptrace traps
> (again, a lot of this probably stems from incorrect manpage).  They
> don't interact with each other that way and there is no correctness
> issue (if there is, it's a but and should be fixed) of
> INTERRUPT+DETACH compared to DETACH without interrupt.  The only
> difference is performance, so let's concentrate on that.

Here is a naive approach to PTRACE_DETACH with current kernels requiring
inferior to be stopped.  You can see it FAILs.  Still I think it is offtopic
problem for this specific patchset but it still should be fixed in ptrace:

#include <unistd.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <stdio.h>
#include <stdlib.h>
static int status;
static pid_t child;
void
handler (int signo)
{
  puts ("PASS");
  exit (0);
}
/* Ensure CHILD is stopped even if it is running now - for PTRACE_DETACH.  */
void
stop_child_for_detach (void)
{
  kill (child, SIGCONT);	/* To be PTRACE_INTERRUPT in the future.  */
  /* The problem - here a signal may get lost.  */
  wait (&status);
}
int
main (void)
{
  child = fork ();
  switch (child)
    {
    case 0:
      signal (SIGUSR2, handler);
      ptrace (PTRACE_TRACEME, 0, NULL, NULL);
      raise (SIGUSR1);
      puts ("FAIL");
      exit (1);
    default:
      wait (&status);
      /* Sent by arbitrary external program.  */
      kill (child, SIGUSR2);
      /* Comment out for PTRACE_DETACH not requiring stopped tracee.  */
#if 1
      ptrace (PTRACE_CONT, child, NULL, NULL);
      stop_child_for_detach ();
#endif
      ptrace (PTRACE_DETACH, child, NULL, NULL);
    }
  return 0;
}


> The reason why I'm reluctant to drop trapped requirement from both
> SEIZE and DETACH is that removing those synchronization points opens
> up a lot of corner cases.

They are either (currently) in the userland or they would be in the kernel.


Thanks,
Jan
