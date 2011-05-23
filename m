Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab1EWWsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:48:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab1EWWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=O5Jtpc62vwjoVZDL5EueMC0fj7iW1ZKtjwdlu43LfZDuTdAitHfgm3n/iLkP9CVCZH
         xkA+dxOWm0A5MPxrMcPQ==
Date: Mon, 23 May 2011 15:48:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, caiqian@redhat.com
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
In-Reply-To: <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105231547060.17840@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6204D.5020109@jp.fujitsu.com> <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, David Rientjes wrote:

> I already suggested an alternative patch to CAI Qian to greatly increase 
> the granularity of the oom score from a range of 0-1000 to 0-10000 to 
> differentiate between tasks within 0.01% of available memory (16MB on CAI 
> Qian's 16GB system).  I'll propose this officially in a separate email.
> 

This is an alternative patch as earlier proposed with suggested 
improvements from Minchan.  CAI, would it be possible to test this out on 
your usecase?

I'm indifferent to the actual scale of OOM_SCORE_MAX_FACTOR; it could be 
10 as proposed in this patch or even increased higher for higher 
resolution.


diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -38,6 +38,9 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+#define OOM_SCORE_MAX_FACTOR	10
+#define OOM_SCORE_MAX		(OOM_SCORE_ADJ_MAX * OOM_SCORE_MAX_FACTOR)
+
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
@@ -160,7 +163,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	if (p->flags & PF_OOM_ORIGIN) {
 		task_unlock(p);
-		return 1000;
+		return OOM_SCORE_MAX;
 	}
 
 	/*
@@ -177,32 +180,38 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	points = get_mm_rss(p->mm) + p->mm->nr_ptes;
 	points += get_mm_counter(p->mm, MM_SWAPENTS);
 
-	points *= 1000;
+	points *= OOM_SCORE_MAX;
 	points /= totalpages;
 	task_unlock(p);
 
 	/*
-	 * Root processes get 3% bonus, just like the __vm_enough_memory()
-	 * implementation used by LSMs.
+	 * Root processes get a bonus of 1% per 10% of memory used.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN)) {
+		int bonus;
+		int granularity;
+
+		bonus = OOM_SCORE_MAX / 100;		/* bonus is 1% */
+		granularity = OOM_SCORE_MAX / 10;	/* granularity is 10% */
+
+		points -= bonus * (points / granularity);
+	}
 
 	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
 	 * either completely disable oom killing or always prefer a certain
 	 * task.
 	 */
-	points += p->signal->oom_score_adj;
+	points += p->signal->oom_score_adj * OOM_SCORE_MAX_FACTOR;
 
 	/*
 	 * Never return 0 for an eligible task that may be killed since it's
-	 * possible that no single user task uses more than 0.1% of memory and
+	 * possible that no single user task uses more than 0.01% of memory and
 	 * no single admin tasks uses more than 3.0%.
 	 */
 	if (points <= 0)
 		return 1;
-	return (points < 1000) ? points : 1000;
+	return (points < OOM_SCORE_MAX) ? points : OOM_SCORE_MAX;
 }
 
 /*
@@ -314,7 +323,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			 */
 			if (p == current) {
 				chosen = p;
-				*ppoints = 1000;
+				*ppoints = OOM_SCORE_MAX;
 			} else {
 				/*
 				 * If this task is not being ptraced on exit,
