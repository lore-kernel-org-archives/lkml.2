Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2D3DBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:01:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35791 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754961Ab2D3DBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:01:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18s/ERXAuAstIEe6y9HYMfoZ/TvS2fFnNvvfbDMSK
	ui18buyip/ojAw
Message-ID: <1335754867.17899.4.camel@marge.simpson.net>
Subject: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Mon, 30 Apr 2012 05:01:07 +0200
In-Reply-To: <20120429165846.GA19054@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 18:58 +0200, Oleg Nesterov wrote: 
> On 04/29, Eric W. Biederman wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> > > Heh. Please look at http://marc.info/?l=linux-kernel&m=127687751003902
> > > and the whole thread, there are a lot more problems here.
> >
> > I don't remember seeing a leak in that conversation.
> 
> It was discussed many times ;) in particular, from the link above:
> 
> 	Note: afaics we have another problem. What if copy_process(CLONE_NEWPID)
> 	fails after pid_ns_prepare_proc() ? Who will do mntput() ?
> 
> But we all forgot about this (relatively minor) problem.
> 
> > > But this particular one looks simple iirc.
> > >
> > >> @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> > >>  	rcu_assign_pointer(p->nsproxy, new);
> > >>
> > >>  	if (ns && atomic_dec_and_test(&ns->count)) {
> > >> +		/* Handle fork() failure, unmount proc before proceeding */
> > >> +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
> > >> +			struct pid_namespace *pid_ns = ns->pid_ns;
> > >> +
> > >> +			if (pid_ns && pid_ns != &init_pid_ns)
> > >> +				pid_ns_release_proc(pid_ns);
> > >> +		}
> > >> +
> > >>  		/*
> > >>  		 * wait for others to get what they want from this nsproxy.
> > >>  		 *
> > >
> > > At first glance this looks correct. But the PF_EXITING check doesn't
> > > look very nice imho. It is needed to detect the case when the caller
> > > is copy_process()->bad_fork_cleanup_namespaces and p is not current.
> >
> > Mike's proposed change to switch_task_namespace is most definitely not
> > correct.  This will potentially get called on unshare
> 
> Yes, but please note that this change also checks "new == NULL", so I
> still think the patch is correct.
> 
> But,
> 
> > > 	 bad_fork_cleanup_namespaces:
> > > 	+	if (unlikely(clone_flags & CLONE_NEWPID))
> > > 	+		pid_ns_release_proc(...);
> > > 		exit_task_namespaces(p);
> > > 		
> > > 		
> > > code into this error path in copy_process?
> >
> > For now Oleg your minimal patch looks good.
> 
> Good.
> 
> Mike, could you please re-send the patch to akpm? Feel free to add my ack.
> I guess Eric will ack this fix too.

namespaces, pid_ns: fix leakage on fork() failure

Fork() failure post namespace creation for a child cloned with CLONE_NEWPID
leaks pid_namespace/mnt_cache due to proc being mounted during creation, but
not unmounted during cleanup.  Call pid_ns_release_proc() during cleanup.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>

 kernel/fork.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..91482b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -67,6 +67,7 @@
 #include <linux/oom.h>
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
+#include <linux/proc_fs.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1464,6 +1465,8 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
+	if (unlikely(clone_flags & CLONE_NEWPID))
+		pid_ns_release_proc(p->nsproxy->pid_ns);
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm)


