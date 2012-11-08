Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2KHGj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:39:58 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:51414 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2KHGj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:39:56 -0500
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 01:39:55 EST
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
To: oleg@redhat.com (Oleg Nesterov)
Date: Thu, 8 Nov 2012 17:29:35 +1100 (EST)
Cc: dvlasenk@redhat.com (Denys Vlasenko),
        mtk.manpages@gmail.com (Michael Kerrisk),
        serge.hallyn@canonical.com (Serge Hallyn),
        scarybeasts@gmail.com (Chris Evans),
        dhowells@redhat.com (David Howells),
        ebiederm@xmission.com (Eric W. Biederman),
        akpm@linux-foundation.org (Andrew Morton), u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121107150934.GA27606@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121108062935.BFF3A592024@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Oleg,

Thanks for the patch, I tried it and it works nicely!

(except that I have no "include/uapi/" directory for
"include/uapi/linux/ptrace.h", so I applied that part
of the patch to "include/linux/ptrace.h" as well).

Also, I just noticed that this new option (PTRACE_O_EXITKILL) is not
safe with ptrace(PTRACE_TRACEME)+execve, because the parent may die
before even having a chance to set PTRACE_O_EXITKILL!

However, that's easy to fix by using PTRACE_ATTACH instead.

On that other matter:

> > What I wish is that I could request (using "prctl" or whatever):
> > "If a non-privileged user sends me a SIGSTOP, then let it be converted into...",
> 
> I hope we won't do this ;) But I am not going to argue if you convince
> other people.
> 
> To me it would be better to simply allow to catch SIGSTOP, but I hope
> we won't do this too.

I don't think anyone should seriously contemplate catching SIGSTOP -
that would break so many applications, including mine.

Now about "convincing", I have that application that really needs this
feature, and I believe that others may be in the same predicament, which is:

1. The application is a SUID-root service, available to ordinary users.
2. Users who started this application are allowed at any time to signal
   or kill their instance(s) of this application.
3. It is alright for the application to be killed by SIGKILL.
4. The application catches and does something useful and positive with
   all other signals sent to it by the invoking user, including SIGTSTP,
   SIGTTIN and SIGTTOU.
5. If the application is unpreparedly stopped by SIGSTOP, which it cannot
   catch, then this may disrupt other instances of this application by
   other users (including, in my case, on other computers connected with
   the application by TCP/IP sockets).

What I ask is simple and can be so easily implemented, essentially in
"kernel/signal.c":

static int check_kill_permission(int sig, struct siginfo *info,
				 struct task_struct *t)
{
	struct pid *sid;
	int error;

	if (!valid_signal(sig))
		return -EINVAL;

	if (!si_fromuser(info))
		return 0;

	error = audit_signal_info(sig, t); /* Let audit system see the signal */
	if (error)
		return error;

+	if (sig == SIGSTOP && (t->flags & PF_NO_SIGSTOP) && !capable(CAP_KILL))
+		return -EPERM;
+
	if (!same_thread_group(current, t) &&
	    !kill_ok_by_cred(t)) {
		switch (sig) {
...

In addition, only the super-user (or CAP_SYS_ADMIN, etc.) should be
allowed to set/reset PF_NO_SIGSTOP (and if taking up a precious PF_xxx
flag is a problem, then the flag could be somewhere else).

Thanks,
Amnon.


Oleg Nesterov wrote:
> 
> (add lkml/cc's)
> 
> On 11/07, Amnon Shiloh wrote:
> >
> > > Quoting Oleg Nesterov (oleg@redhat.com):
> > > >
> > > > On 11/06, Amnon Shiloh wrote:
> > > > >
> > > > > What I would IDEALLY like to have is a call, probably a ptrace option,
> > > > > where the parent can request: "If I am ever to terminate or be killed,
> > > > > then my ptraced son MUST die as well".
> > > >
> > > > Perhaps this makes sense...
> > > >
> > > > Chris, iirc you also suggested something like this? And the patch is
> > > > trivial.
> > > >
> > > > Oleg.
> > > >
> > > > --- x/kernel/ptrace.c
> > > > +++ x/kernel/ptrace.c
> > > > @@ -393,8 +393,12 @@ static bool __ptrace_detach(struct task_
> > > >
> > > >  	__ptrace_unlink(p);
> > > >
> > > > -	if (p->exit_state != EXIT_ZOMBIE)
> > > > +	if (p->exit_state != EXIT_ZOMBIE) {
> > > > +		if ((tracer->flags & PF_EXITING) &&
> > > > +		    (p->ptrace & PT_KILL_IF_TRACER_EXITS))
> > > > +			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
> 
> No. This is wrong.
> 
> We should send SIGKILL before __ptrace_unlink() which clears ->ptrace.
> Otherwise (in theory) the tracee can raise its capabilities in between.
> 
> Lets change exit_ptrace() to do this, see the patch at the end.
> 
> > That would be just wonderful, just what I need
> > - it will solve me so much pain!
> 
> OK. Please see the untested/uncompiled (but trivial) patch below
> 
> 	- it adds PTRACE_O_EXITKILL. A better name?
> 
> 	- A better numeric value? Note that the new option is not equal to
> 	  the last-ptrace-option << 1. Because currently all options have
> 	  the event, and the new one starts the eventless group. 1 << 16
> 	  means we have the room for 8 more events.
> 
> 	- it needs the convincing changelog for akpm
> 
> > Speaking of things I need, here is another:
> >
> > I have a SUID-root service, which ordinary users can launch.
> > This service keeps its original real-UID so that its calling user
> > can send it signals, which is fine because it catches them all and
> > handles them appropriately.
> >
> > It is not even a problem if the user kills my service using SIGKILL
> > (because that closes all its external sockets), but my service is
> > helpless against a SIGSTOP because it cannot be caught and stopping
> > the service in an abrupt, non-orderly fashion might disrupt other users.
> > (currently I solve this by having another central service watch all instances
> > of my service periodically
> 
> Well, this central service can ptrace them and nack SIGSTOP... I agree
> this doesn't look nice too, but:
> 
> > What I wish is that I could request (using "prctl" or whatever):
> > "If a non-privileged user sends me a SIGSTOP, then let it be converted into...",
> 
> I hope we won't do this ;) But I am not going to argue if you convince
> other people.
> 
> To me it would be better to simply allow to catch SIGSTOP, but I hope
> we won't do this too.
> 
> Oleg.
> 
> 
> --- x/include/uapi/linux/ptrace.h
> +++ x/include/uapi/linux/ptrace.h
> @@ -73,7 +73,10 @@
>  #define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
>  #define PTRACE_O_TRACESECCOMP	(1 << PTRACE_EVENT_SECCOMP)
>  
> -#define PTRACE_O_MASK		0x000000ff
> +/* eventless options */
> +#define PTRACE_O_EXITKILL	(1 << 16)
> +
> +#define PTRACE_O_MASK		(0x000000ff | PTRACE_O_EXITKILL)
>  
>  #include <asm/ptrace.h>
>  
> --- x/include/linux/ptrace.h
> +++ x/include/linux/ptrace.h
> @@ -32,6 +32,8 @@
>  #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
>  #define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
>  
> +#define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
> +
>  /* single stepping state bits (used on ARM and PA-RISC) */
>  #define PT_SINGLESTEP_BIT	31
>  #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
> --- x/kernel/ptrace.c
> +++ x/kernel/ptrace.c
> @@ -457,6 +457,9 @@ void exit_ptrace(struct task_struct *tra
>  		return;
>  
>  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
> +		if (unlikely(p->ptrace & PT_EXITKILL))
> +			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
> +
>  		if (__ptrace_detach(tracer, p))
>  			list_add(&p->ptrace_entry, &ptrace_dead);
>  	}
> 
> 

