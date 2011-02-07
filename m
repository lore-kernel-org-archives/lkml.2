Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1BGNRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1BGNRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:17:00 -0500
Date: Mon, 7 Feb 2011 14:08:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
Message-ID: <20110207130841.GA16054@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110128165455.GA18194@elte.hu> <20110128175532.GA26727@redhat.com> <20110128182947.GB20056@elte.hu> <20110205203422.GA12443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205203422.GA12443@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Oleg Nesterov wrote:
>
> On 01/28, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > On 01/28, Ingo Molnar wrote:
> > > >
> > > > The bug is that occasionally Ctrl-C does not get processed, and that the Ctrl-C is
> > > > 'lost'. It can be reproduced here by running ./test-signal several times, and
> > > > Ctrl-C-ing it:
> > > >
> > > >  $ ./test-signal
> > > >  ^C
> > > >  $ ./test-signal
> > > >  ^C^C
> > > >  $ ./test-signal
> > > >  ^C
> > > >
> > > > See that '^C^C' line? That is where i had to do Ctrl-C twice.
> > >
> > > Reproduced.
> > >
> > > At first glance, /bin/sh should be blamed... Hmm, probably yes,
> > > I even reproduced this under strace, and this is what I see
> > >
> > > 	wait4(-1, 0x7fff388431c4, 0, NULL) = ? ERESTARTSYS (To be restarted)
> > > 	--- SIGINT (Interrupt) @ 0 (0) ---
> > > 	rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
> > > 	wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 9706
> > >
> > > So, ^C is not lost, but ./test-signal doesn't want to exit.
> >
> > Might be some Bash assumption or race that works under other OSs but somehow Linux
> > does differently. IIRC Bash is being developed on MacOS-X.
> >
> > But it's happening all the time (with yum for example - but also with makejobs, as
> > Thomas has reported it) - this is simply the first time i managed to reproduce it
> > with something really simple.
>
> OK, I seem to understand what happens. Of course I am not sure, I never
> looked into these sources before...
>
> Suppose that jctl ^C races with the normal child exit. In this case
> waitchld() sets child->status = status (zero in this case) and calls
> set_job_status_and_cleanup().
>
> set_job_status_and_cleanup() notice wait_sigint_received and send
> SIGINT to itself (termsig_handler (SIGINT)), but somehow it assumes
> that the last foreground job should be terminated by SIGINT too:
>
> 	 else if (wait_sigint_received && (WTERMSIG (child->status) == SIGINT) &&
>
> Then the next wait_for() clears wait_sigint_received and bash
> looses ^C

IOW.

Now that it is clear what happens, the test-case becomes even more
trivial:

	bash-4.1$ ./bash -c 'while true; do /bin/true; done'
	^C^C

needs 4-5 attempts on my machine.

The patch below fixes the problem, but most probably it is not
correct. Although I don't understand the point of "status == SIGINT"
check, we already checked this job is dead. But I won't pretend I
really understand this code.

Oleg.

--- bash-4.1/jobs.c~ctrlc_exit_race	2011-02-07 13:52:48.000000000 +0100
+++ bash-4.1/jobs.c	2011-02-07 13:55:30.000000000 +0100
@@ -3299,7 +3299,7 @@ set_job_status_and_cleanup (job)
 	 signals are sent to process groups) or via kill(2) to the foreground
 	 process by another process (or itself).  If the shell did receive the
 	 SIGINT, it needs to perform normal SIGINT processing. */
-      else if (wait_sigint_received && (WTERMSIG (child->status) == SIGINT) &&
+      else if (wait_sigint_received /*&& (WTERMSIG (child->status) == SIGINT)*/ &&
 	      IS_FOREGROUND (job) && IS_JOBCONTROL (job) == 0)
 	{
 	  int old_frozen;

