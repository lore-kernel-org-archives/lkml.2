Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1BKOmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:42:09 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754068Ab1BKOmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:42:07 -0500
Date: Fri, 11 Feb 2011 15:41:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, roland@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
Message-ID: <20110211144155.GD3920@ucw.cz>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110128165455.GA18194@elte.hu>
 <20110128175532.GA26727@redhat.com>
 <20110128182947.GB20056@elte.hu>
 <20110205203422.GA12443@redhat.com>
 <20110207130841.GA16054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207130841.GA16054@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > set_job_status_and_cleanup() notice wait_sigint_received and send
> > SIGINT to itself (termsig_handler (SIGINT)), but somehow it assumes
> > that the last foreground job should be terminated by SIGINT too:
> >
> > 	 else if (wait_sigint_received && (WTERMSIG (child->status) == SIGINT) &&
> >
> > Then the next wait_for() clears wait_sigint_received and bash
> > looses ^C
> 
> IOW.
> 
> Now that it is clear what happens, the test-case becomes even more
> trivial:
> 
> 	bash-4.1$ ./bash -c 'while true; do /bin/true; done'
> 	^C^C
> 
> needs 4-5 attempts on my machine.

Huh, this happened so often to me that I assumed it is a feature
:-(. Reproducible on both up arm and 4way x86...

Ok, it would be very good to get it fixed.


									Pavel

> --- bash-4.1/jobs.c~ctrlc_exit_race	2011-02-07 13:52:48.000000000 +0100
> +++ bash-4.1/jobs.c	2011-02-07 13:55:30.000000000 +0100
> @@ -3299,7 +3299,7 @@ set_job_status_and_cleanup (job)
>  	 signals are sent to process groups) or via kill(2) to the foreground
>  	 process by another process (or itself).  If the shell did receive the
>  	 SIGINT, it needs to perform normal SIGINT processing. */
> -      else if (wait_sigint_received && (WTERMSIG (child->status) == SIGINT) &&
> +      else if (wait_sigint_received /*&& (WTERMSIG (child->status) == SIGINT)*/ &&
>  	      IS_FOREGROUND (job) && IS_JOBCONTROL (job) == 0)
>  	{
>  	  int old_frozen;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
