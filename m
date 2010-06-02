Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0FBNyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:54:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab0FBNyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:54:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] oom: remove PF_EXITING check completely
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100601201843.GA20732@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com>
Message-Id: <20100602200732.F518.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 22:54:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/01, KOSAKI Motohiro wrote:
> >
> > > I'd like to add a note... with or without this, we have problems
> > > with the coredump. A thread participating in the coredumping
> > > (group-leader in this case) can have PF_EXITING && mm, but this doesn't
> > > mean it is going to exit soon, and the dumper can use a lot more memory.
> >
> > Sure. I think coredump sould do nothing if oom occur.
> > So, merely making PF_COREDUMP is bad idea? I mean
> >
> > task-flags		allocator
> > ------------------------------------------------
> > none			N/A
> > TIF_MEMDIE		allow to use emergency memory.
> > 			don't call page reclaim.
> > PF_COREDUMP		N/A
> > TIF_MEMDIE+PF_COREDUMP	disallow to use emergency memory.
> > 			don't call page reclaim.
> >
> > In other word, coredump path makes allocation failure if the task
> > marked as TIF_MEMDIE.
> 
> Perhaps... But where should TIF_MEMDIE go this case? Let me clarify.
> 
> Two threads, group-leader L and its sub-thread T. T dumps the code.
> In this case both threads have ->mm != NULL, L has PF_EXITING.
> 
> The first problem is, select_bad_process() always return -1 in this
> case (even if the caller is T, this doesn't matter).
> 
> The second problem is that we should add TIF_MEMDIE to T, not L.
> 
> This is more or less easy. For simplicity, let's suppose we removed
> this PF_EXITING check from select_bad_process().

Today, I've thought to make some bandaid patches for this issue. but
yes, I've reached the same conclusion.

If we think multithread and core dump situation, all fixes are just
bandaid. We can't remove deadlock chance completely.

The deadlock is certenaly worst result, then, minor PF_EXITING optimization
doesn't have so much worth.


==============================================================
Subject: [PATCH] oom: remove PF_EXITING check completely

PF_EXITING is wrong check if the task have multiple threads. This patch
removes it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/oom_kill.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 9e7f0f9..b06f8d1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -302,24 +302,6 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
 
-		/*
-		 * This is in the process of releasing memory so wait for it
-		 * to finish before killing some other task by mistake.
-		 *
-		 * However, if p is the current task, we allow the 'kill' to
-		 * go ahead if it is exiting: this will simply set TIF_MEMDIE,
-		 * which will allow it to gain access to memory reserves in
-		 * the process of exiting and releasing its resources.
-		 * Otherwise we could get an easy OOM deadlock.
-		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
-			if (p != current)
-				return ERR_PTR(-1UL);
-
-			chosen = p;
-			*ppoints = ULONG_MAX;
-		}
-
 		points = badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
@@ -436,15 +418,6 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
 
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just set TIF_MEMDIE so it can die quickly
-	 */
-	if (p->flags & PF_EXITING) {
-		__oom_kill_process(p, mem, 0);
-		return 0;
-	}
-
 	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
 					message, task_pid_nr(p), p->comm, points);
 
-- 
1.6.5.2



