Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2KHOGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:06:00 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:36752 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2KHOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:05:59 -0500
Subject: Re: PF_NO_SIGSTOP (Was: PT_EXITKILL)
To: oleg@redhat.com (Oleg Nesterov)
Date: Fri, 9 Nov 2012 01:05:58 +1100 (EST)
Cc: torvalds@linux-foundation.org (Linus Torvalds),
        dvlasenk@redhat.com (Denys Vlasenko),
        mtk.manpages@gmail.com (Michael Kerrisk),
        serge.hallyn@canonical.com (Serge Hallyn),
        scarybeasts@gmail.com (Chris Evans),
        dhowells@redhat.com (David Howells),
        ebiederm@xmission.com (Eric W. Biederman),
        akpm@linux-foundation.org (Andrew Morton), u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121108124853.GC20917@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121108140558.345D9592017@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> Is this the only reason why this service keeps its original real-UID?
> (see below)

Allowing the user who invoked my service to send it signals is the main
reason for keeping the original real-UID, but not the only one.

> What if we introduce SA_NOSECURITY? So that if an application does
> 
> 	sa.sa_flags = SA_NOSECURITY | ...;
> 
> 	sigaction(SIG, &sa, NULL);
> 
> then sys_kill/etc bypasses security checks.
> 
> This way your service can run as root and still recieve the signals
> from the ordinary users. Yes, except SIGKILL/SIGSTOP.

Well, I see two more problems here:
1. I actually would like to be able to receive SIGKILL - it is legitimate
   and not uncommon for the calling user to kill the service.
   (also to stop it, but they can use SIGTSTP just the same,
    then the service may suspend itself in an orderly fashion)
2. I must not allow OTHER users to signal the service.
   - I suppose this can be handled in most cases by checking the "si_uid"
   field of the siginfo, but a user may kill a process if either their
   real-uid or effective-uid allows it, so "si_uid" may not show it if
   they are different (then I would discard the signal and the killer
   will not even receive an EPERM error).

> > +	if (sig == SIGSTOP && (t->flags & PF_NO_SIGSTOP) && !capable(CAP_KILL))
>                                ^^^^^^^^^^^^^^^^^^^^^^^^
> No, this is not enough. At least PF_NO_SIGSTOP should be per-process,
> not per-thread. But I agree, it is simpe to implement.

Oh, I didn't think of that because my service is not multi-threaded.
As far as I am concerned, I don't care whether it is per-process or
per-thread, but I agree: if you stop just one thread in a critical
section or in the middle of a mutex operation, the other threads are
not going to be that happy...

Whether per-process or per-thread, this should be easier to implement
and have a clearer interface than "SA_NOSECURITY".

Best Regards,
Amnon.


> On 11/08, Amnon Shiloh wrote:
> >
> > > > What I wish is that I could request (using "prctl" or whatever):
> > > > "If a non-privileged user sends me a SIGSTOP, then let it be converted into...",
> > >
> > > I hope we won't do this ;) But I am not going to argue if you convince
> > > other people.
> > >
> > > To me it would be better to simply allow to catch SIGSTOP, but I hope
> > > we won't do this too.
> >
> > I don't think anyone should seriously contemplate catching SIGSTOP -
> > that would break so many applications, including mine.
> >
> > Now about "convincing", I have that application that really needs this
> > feature, and I believe that others may be in the same predicament, which is:
> >
> > 1. The application is a SUID-root service, available to ordinary users.
> > 2. Users who started this application are allowed at any time to signal
> >    or kill their instance(s) of this application.
> 
> Is this the only reason why this service keeps its original real-UID?
> (see below)
> 
> > 3. It is alright for the application to be killed by SIGKILL.
> > 4. The application catches and does something useful and positive with
> >    all other signals sent to it by the invoking user, including SIGTSTP,
> >    SIGTTIN and SIGTTOU.
> > 5. If the application is unpreparedly stopped by SIGSTOP, which it cannot
> >    catch, then this may disrupt other instances of this application by
> >    other users (including, in my case, on other computers connected with
> >    the application by TCP/IP sockets).
> >
> > What I ask is simple and can be so easily implemented, essentially in
> > "kernel/signal.c":
> >
> > static int check_kill_permission(int sig, struct siginfo *info,
> > 				 struct task_struct *t)
> > {
> > ...
> > +	if (sig == SIGSTOP && (t->flags & PF_NO_SIGSTOP) && !capable(CAP_KILL))
>                                ^^^^^^^^^^^^^^^^^^^^^^^^
> No, this is not enough. At least PF_NO_SIGSTOP should be per-process,
> not per-thread. But I agree, it is simpe to implement.
> 
> So once again, no need to convince me ;) I try to never argue with
> the new features, even if personally I do not really like this idea.
> If someone acks your idea I will be happy to help with the patch.
> 
> 
> And I have another idea... Not that I like it very much, but it looks
> simple and maybe useful.
> 
> What if we introduce SA_NOSECURITY? So that if an application does
> 
> 	sa.sa_flags = SA_NOSECURITY | ...;
> 
> 	sigaction(SIG, &sa, NULL);
> 
> then sys_kill/etc bypasses security checks.
> 
> This way your service can run as root and still recieve the signals
> from the ordinary users. Yes, except SIGKILL/SIGSTOP.
> 
> Oleg.
> 
> 

