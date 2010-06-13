Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0FMRPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 13:15:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0FMRPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 13:15:21 -0400
Date: Sun, 13 Jun 2010 19:13:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: uninterruptible CLONE_VFORK (Was: oom: Make coredump interruptible)
Message-ID: <20100613171337.GA12159@redhat.com>
References: <20100604112721.GA12582@redhat.com> <20100609195309.GA6899@redhat.com> <20100613175547.616F.A69D9226@jp.fujitsu.com> <20100613155354.GA8428@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100613155354.GA8428@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Oleg Nesterov wrote:
>
> On 06/13, KOSAKI Motohiro wrote:
> >
> > But, again, I have no objection to your patch. because I really hope to
> > fix coredump vs oom issue.
>
> Yes, I think this is important.

Oh. And another problem, vfork() is not interruptible too. This means
that the user can hide the memory hog from oom-killer. But let's forget
about oom.

Roland, any reason it should be uninterruptible? This doesn't look good
in any case. Perhaps the pseudo-patch below makes sense?

Oleg.

--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -1359,6 +1359,26 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
+// ---------------------------------------------------
+// THIS SHOULD BE USED BY mm_release/coredump_wait/etc
+// ---------------------------------------------------
+void complete_vfork_done(struct task_struct *tsk)
+{
+	struct completion *vfork = xchg(tsk->vfork_done, NULL);
+	if (vfork)
+		complete(vfork);
+}
+
+static wait_for_vfork_done(struct task_struct *child, struct completion *vfork)
+{
+	if (!wait_for_completion_killable(vfork))
+		return;
+	if (xchg(child->vfork_done, NULL) != NULL)
+		return;
+	// the child has already read ->vfork_done and it should wake us up
+	wait_for_completion(vfork);
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
@@ -1433,6 +1453,7 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
+			get_task_struct(p);
 		}
 
 		audit_finish_fork(p);
@@ -1462,7 +1483,8 @@ long do_fork(unsigned long clone_flags,
 
 		if (clone_flags & CLONE_VFORK) {
 			freezer_do_not_count();
-			wait_for_completion(&vfork);
+			wait_for_vfork_done(p, &vfork);
+			put_task_struct(p),
 			freezer_count();
 			tracehook_report_vfork_done(p, nr);
 		}

