Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0GVJIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab0GVJIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:08:46 -0400
Date: Thu, 22 Jul 2010 11:05:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Message-ID: <20100722090524.GA6647@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com> <20100721144944.5351c741.akpm@linux-foundation.org> <20100721222529.EFBAA400B6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721222529.EFBAA400B6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not surpized perf blaims tasklist, but I am really surpized this patch
adds 10% improvement...

On 07/21, Roland McGrath wrote:
>
> > > @@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
> > >  	struct task_struct *p, *n;
> > >  	LIST_HEAD(ptrace_dead);
> > >
> > > +	if (list_empty(&tracer->ptraced))
> > > +		return;
> > > +
> > >  	write_lock_irq(&tasklist_lock);
> > >  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
> > >  		if (__ptrace_detach(tracer, p))
>
> I think we may have tried that before.  Oleg can tell us if it's really
> safe vs a race with PTRACE_TRACEME or something like that.

Yes, this can race with ptrace_traceme(). Without tasklist_lock in
exit_ptrace(), it is possible that ptrace_traceme() starts __ptrace_link()
before it sees PF_EXITING, and completes before the result of list_add()
is visible to the exiting parent. tasklist acts as a barrier.

So, this list_empty() check needs taskslit at least for reading. But, we
are going to take it for writing right after exit_ptrace() returns, afaics
we can add this fastpatch check for free.

Uncompiled/untested.

Oleg.

 kernel/ptrace.c |   10 +++++++---
 kernel/exit.c   |    3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- x/kernel/ptrace.c
+++ x/kernel/ptrace.c
@@ -324,26 +324,30 @@ int ptrace_detach(struct task_struct *ch
 }
 
 /*
- * Detach all tasks we were using ptrace on.
+ * Detach all tasks we were using ptrace on. Called with tasklist held.
  */
 void exit_ptrace(struct task_struct *tracer)
 {
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
-	write_lock_irq(&tasklist_lock);
+	if (likely(list_empty(&tracer->ptraced)))
+		return;
+
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
-	write_unlock_irq(&tasklist_lock);
 
+	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&tracer->ptraced));
 
 	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
+
+	write_lock_irq(&tasklist_lock);
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -771,9 +771,10 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
+	write_lock_irq(&tasklist_lock);
+
 	exit_ptrace(father);
 
-	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {

