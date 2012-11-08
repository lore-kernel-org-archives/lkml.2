Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2KHMsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:48:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2KHMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:48:15 -0500
Date: Thu, 8 Nov 2012 13:48:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: PF_NO_SIGSTOP (Was: PT_EXITKILL)
Message-ID: <20121108124853.GC20917@redhat.com>
References: <20121107150934.GA27606@redhat.com> <20121108062935.BFF3A592024@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108062935.BFF3A592024@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Amnon Shiloh wrote:
>
> > > What I wish is that I could request (using "prctl" or whatever):
> > > "If a non-privileged user sends me a SIGSTOP, then let it be converted into...",
> >
> > I hope we won't do this ;) But I am not going to argue if you convince
> > other people.
> >
> > To me it would be better to simply allow to catch SIGSTOP, but I hope
> > we won't do this too.
>
> I don't think anyone should seriously contemplate catching SIGSTOP -
> that would break so many applications, including mine.
>
> Now about "convincing", I have that application that really needs this
> feature, and I believe that others may be in the same predicament, which is:
>
> 1. The application is a SUID-root service, available to ordinary users.
> 2. Users who started this application are allowed at any time to signal
>    or kill their instance(s) of this application.

Is this the only reason why this service keeps its original real-UID?
(see below)

> 3. It is alright for the application to be killed by SIGKILL.
> 4. The application catches and does something useful and positive with
>    all other signals sent to it by the invoking user, including SIGTSTP,
>    SIGTTIN and SIGTTOU.
> 5. If the application is unpreparedly stopped by SIGSTOP, which it cannot
>    catch, then this may disrupt other instances of this application by
>    other users (including, in my case, on other computers connected with
>    the application by TCP/IP sockets).
>
> What I ask is simple and can be so easily implemented, essentially in
> "kernel/signal.c":
>
> static int check_kill_permission(int sig, struct siginfo *info,
> 				 struct task_struct *t)
> {
> ...
> +	if (sig == SIGSTOP && (t->flags & PF_NO_SIGSTOP) && !capable(CAP_KILL))
                               ^^^^^^^^^^^^^^^^^^^^^^^^
No, this is not enough. At least PF_NO_SIGSTOP should be per-process,
not per-thread. But I agree, it is simpe to implement.

So once again, no need to convince me ;) I try to never argue with
the new features, even if personally I do not really like this idea.
If someone acks your idea I will be happy to help with the patch.


And I have another idea... Not that I like it very much, but it looks
simple and maybe useful.

What if we introduce SA_NOSECURITY? So that if an application does

	sa.sa_flags = SA_NOSECURITY | ...;

	sigaction(SIG, &sa, NULL);

then sys_kill/etc bypasses security checks.

This way your service can run as root and still recieve the signals
from the ordinary users. Yes, except SIGKILL/SIGSTOP.

Oleg.

