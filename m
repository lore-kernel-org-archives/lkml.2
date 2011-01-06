Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1AFQ3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:29:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39643 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1AFQ3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:29:02 -0500
Subject: Re: [RFC][PATCH 14/18] sched: Remove rq->lock from the first half
 of ttwu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110104150103.012710349@chello.nl>
References: <20110104145929.772813816@chello.nl>
	 <20110104150103.012710349@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 17:29:13 +0100
Message-ID: <1294331353.2016.378.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:59 +0100, Peter Zijlstra wrote:
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1343,8 +1343,7 @@ static void task_waking_fair(struct task
>         struct sched_entity *se = &p->se;
>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
>  
> -       lockdep_assert_held(&task_rq(p)->lock);
> -
> +       // XXX racy on 32bit
>         se->vruntime -= cfs_rq->min_vruntime;
>  } 


Best I can come up with is something like this:


Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -315,6 +315,9 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -365,6 +365,10 @@ static void update_min_vruntime(struct c
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 /*
@@ -1342,9 +1346,21 @@ static void task_waking_fair(struct task
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 min_vruntime;
 
-	// XXX racy on 32bit
-	se->vruntime -= cfs_rq->min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+
+	do {
+		min_vruntime_copy = cfs_rq->min_vruntime_copy;
+		smp_rmb();
+		min_vruntime = cfs_rq->min_vruntime;
+	} while (min_vruntime != min_vruntime_copy);
+#else
+	min_vruntime = cfs_rq->min_vruntime;
+#endif
+
+	se->vruntime -= min_vruntime;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED

