Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2KGPJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:09:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2KGPJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:09:02 -0500
Date: Wed, 7 Nov 2012 16:09:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: PT_EXITKILL (Was: pdeath_signal)
Message-ID: <20121107150934.GA27606@redhat.com>
References: <20121106152050.GA18218@sergelap> <20121106201428.9D72959201A@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106201428.9D72959201A@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add lkml/cc's)

On 11/07, Amnon Shiloh wrote:
>
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > >
> > > On 11/06, Amnon Shiloh wrote:
> > > >
> > > > What I would IDEALLY like to have is a call, probably a ptrace option,
> > > > where the parent can request: "If I am ever to terminate or be killed,
> > > > then my ptraced son MUST die as well".
> > >
> > > Perhaps this makes sense...
> > >
> > > Chris, iirc you also suggested something like this? And the patch is
> > > trivial.
> > >
> > > Oleg.
> > >
> > > --- x/kernel/ptrace.c
> > > +++ x/kernel/ptrace.c
> > > @@ -393,8 +393,12 @@ static bool __ptrace_detach(struct task_
> > >
> > >  	__ptrace_unlink(p);
> > >
> > > -	if (p->exit_state != EXIT_ZOMBIE)
> > > +	if (p->exit_state != EXIT_ZOMBIE) {
> > > +		if ((tracer->flags & PF_EXITING) &&
> > > +		    (p->ptrace & PT_KILL_IF_TRACER_EXITS))
> > > +			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);

No. This is wrong.

We should send SIGKILL before __ptrace_unlink() which clears ->ptrace.
Otherwise (in theory) the tracee can raise its capabilities in between.

Lets change exit_ptrace() to do this, see the patch at the end.

> That would be just wonderful, just what I need
> - it will solve me so much pain!

OK. Please see the untested/uncompiled (but trivial) patch below

	- it adds PTRACE_O_EXITKILL. A better name?

	- A better numeric value? Note that the new option is not equal to
	  the last-ptrace-option << 1. Because currently all options have
	  the event, and the new one starts the eventless group. 1 << 16
	  means we have the room for 8 more events.

	- it needs the convincing changelog for akpm

> Speaking of things I need, here is another:
>
> I have a SUID-root service, which ordinary users can launch.
> This service keeps its original real-UID so that its calling user
> can send it signals, which is fine because it catches them all and
> handles them appropriately.
>
> It is not even a problem if the user kills my service using SIGKILL
> (because that closes all its external sockets), but my service is
> helpless against a SIGSTOP because it cannot be caught and stopping
> the service in an abrupt, non-orderly fashion might disrupt other users.
> (currently I solve this by having another central service watch all instances
> of my service periodically

Well, this central service can ptrace them and nack SIGSTOP... I agree
this doesn't look nice too, but:

> What I wish is that I could request (using "prctl" or whatever):
> "If a non-privileged user sends me a SIGSTOP, then let it be converted into...",

I hope we won't do this ;) But I am not going to argue if you convince
other people.

To me it would be better to simply allow to catch SIGSTOP, but I hope
we won't do this too.

Oleg.


--- x/include/uapi/linux/ptrace.h
+++ x/include/uapi/linux/ptrace.h
@@ -73,7 +73,10 @@
 #define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
 #define PTRACE_O_TRACESECCOMP	(1 << PTRACE_EVENT_SECCOMP)
 
-#define PTRACE_O_MASK		0x000000ff
+/* eventless options */
+#define PTRACE_O_EXITKILL	(1 << 16)
+
+#define PTRACE_O_MASK		(0x000000ff | PTRACE_O_EXITKILL)
 
 #include <asm/ptrace.h>
 
--- x/include/linux/ptrace.h
+++ x/include/linux/ptrace.h
@@ -32,6 +32,8 @@
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 #define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
 
+#define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
+
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
--- x/kernel/ptrace.c
+++ x/kernel/ptrace.c
@@ -457,6 +457,9 @@ void exit_ptrace(struct task_struct *tra
 		return;
 
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
+		if (unlikely(p->ptrace & PT_EXITKILL))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
+
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}

