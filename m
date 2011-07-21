Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1GULOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 07:14:05 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:38320 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1GULOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 07:14:01 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGiS0PFRQd
X-RZG-CLASS-ID: mo00
Date: Thu, 21 Jul 2011 13:13:58 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: purpose of WARN_ON in kernel/workqueue.c:worker_enter_idle()
Message-ID: <20110721111357.GA17725@aepfle.de>
References: <20110718161518.GA8128@aepfle.de>
 <20110721073828.GY3455@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110721073828.GY3455@htj.dyndns.org>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, Tejun Heo wrote:

> On Mon, Jul 18, 2011 at 06:15:18PM +0200, Olaf Hering wrote:
> > whats the purpose of "WARNING: at kernel/workqueue.c:1217 worker_enter_idle()"?
> > I put some debug in the function, cpu is always 1, nr_workers is either
> > 2 or 3, current_work is NULL.
> > Is there some real bug lurking thats worth to track down?
> 
> Oh yeah, that means workqueue worker accounting went out of sync which
> may lead to workqueue hang which usually means dead system.  Can you
> please print out what goes out of sync?  ie. print gcwq->nr_workers,
> nr_idle and get_gcwq_nr_running(gcwq->cpu)?

Whit my silly debug patch below I got this output, which is also in the
posted dmesg output:

[   43.376143] worker_enter_idle: c 1 3           (null)
[  821.936288] worker_enter_idle: c 1 2           (null)
[ 1068.816239] worker_enter_idle: c 1 2           (null)
[ 1167.136160] worker_enter_idle: c 1 3           (null)
[ 1220.896745] worker_enter_idle: c 1 3           (null)
[ 1280.176207] worker_enter_idle: c 1 3           (null)
[ 1304.820106] worker_enter_idle: c 1 3           (null)
[ 2091.140542] worker_enter_idle: c 1 3           (null)
[ 2275.856762] worker_enter_idle: c 1 3           (null)
[ 2382.976445] worker_enter_idle: c 1 2           (null)
[ 2387.696067] worker_enter_idle: c 1 2           (null)


> Also, it would be helpful to enable and record workqueue events (grep
> workqueue /sys/kernel/debug/tracing/available_events).  It should
> allow us what led to the condition.

I will enable these options and report back.


---
 kernel/workqueue.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -1192,6 +1192,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 static void worker_enter_idle(struct worker *worker)
 {
 	struct global_cwq *gcwq = worker->gcwq;
+	int cpu;
 
 	BUG_ON(worker->flags & WORKER_IDLE);
 	BUG_ON(!list_empty(&worker->entry) &&
@@ -1213,8 +1214,23 @@ static void worker_enter_idle(struct wor
 		wake_up_all(&gcwq->trustee_wait);
 
 	/* sanity check nr_running */
+#if 0
 	WARN_ON_ONCE(gcwq->nr_workers == gcwq->nr_idle &&
 		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
+#else
+	cpu = atomic_read(get_gcwq_nr_running(gcwq->cpu));
+	if (gcwq->nr_workers == gcwq->nr_idle && cpu) {
+		void *func;
+		struct work_struct *cw = worker->current_work;
+		func = cw ? cw->func : NULL;
+		printk("%s: c %x %x %p", __func__, cpu, gcwq->nr_workers, func);
+		if (func)
+			print_symbol("%s\n",(unsigned long)func);
+		else
+			printk("\n");
+		WARN_ON_ONCE(1);
+	}
+#endif
 }
 
 /**
