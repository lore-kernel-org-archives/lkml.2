Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1A1SaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:30:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1A1SaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:30:11 -0500
Date: Fri, 28 Jan 2011 19:29:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
Message-ID: <20110128182947.GB20056@elte.hu>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110128165455.GA18194@elte.hu>
 <20110128175532.GA26727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128175532.GA26727@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/28, Ingo Molnar wrote:
> >
> > The bug is that occasionally Ctrl-C does not get processed, and that the Ctrl-C is
> > 'lost'. It can be reproduced here by running ./test-signal several times, and
> > Ctrl-C-ing it:
> >
> >  $ ./test-signal
> >  ^C
> >  $ ./test-signal
> >  ^C^C
> >  $ ./test-signal
> >  ^C
> >
> > See that '^C^C' line? That is where i had to do Ctrl-C twice.
> 
> Reproduced.
> 
> At first glance, /bin/sh should be blamed... Hmm, probably yes,
> I even reproduced this under strace, and this is what I see
> 
> 	wait4(-1, 0x7fff388431c4, 0, NULL) = ? ERESTARTSYS (To be restarted)
> 	--- SIGINT (Interrupt) @ 0 (0) ---
> 	rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
> 	wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 9706
> 
> So, ^C is not lost, but ./test-signal doesn't want to exit.

Might be some Bash assumption or race that works under other OSs but somehow Linux 
does differently. IIRC Bash is being developed on MacOS-X.

But it's happening all the time (with yum for example - but also with makejobs, as 
Thomas has reported it) - this is simply the first time i managed to reproduce it 
with something really simple.

Thanks,

	Ingo
