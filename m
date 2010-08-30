Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0H3Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:31:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:40554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab0H3Rb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:31:58 -0400
Message-ID: <4C7BEB00.9060801@kernel.org>
Date: Mon, 30 Aug 2010 19:31:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: caiqian@redhat.com
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1331313838.1541221283181038073.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4C7BDE6E.8030107@kernel.org>
In-Reply-To: <4C7BDE6E.8030107@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 17:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please try this one instead.  Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a2dccfc..75cdbc2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1224,6 +1224,8 @@ __acquires(&gcwq->lock)
 {
 	struct global_cwq *gcwq = worker->gcwq;
 	struct task_struct *task = worker->task;
+	static unsigned int cnt;
+	int rc;

 	while (true) {
 		/*
@@ -1232,8 +1234,11 @@ __acquires(&gcwq->lock)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
-			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+			rc = set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+			if (rc && ++cnt < 10)
+				printk("XXX set_cpus_allowed_ptr() failed w/ %d\n", rc);
+		}

 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
@@ -1985,13 +1990,16 @@ repeat:
 		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
 		struct global_cwq *gcwq = cwq->gcwq;
 		struct work_struct *work, *n;
+		bool bound;

 		__set_current_state(TASK_RUNNING);
 		mayday_clear_cpu(cpu, wq->mayday_mask);

 		/* migrate to the target cpu if possible */
 		rescuer->gcwq = gcwq;
-		worker_maybe_bind_and_lock(rescuer);
+		printk("XXX %s: rescuer dispatching to cpu%u\n", wq->name, gcwq->cpu);
+		bound = worker_maybe_bind_and_lock(rescuer);
+		printk("XXX %s: rescuer done binding, bound=%d\n", wq->name, bound);

 		/*
 		 * Slurp in all works issued via this workqueue and
@@ -3558,8 +3566,7 @@ static int __init init_workqueues(void)
 		spin_lock_init(&gcwq->lock);
 		INIT_LIST_HEAD(&gcwq->worklist);
 		gcwq->cpu = cpu;
-		if (cpu == WORK_CPU_UNBOUND)
-			gcwq->flags |= GCWQ_DISASSOCIATED;
+		gcwq->flags |= GCWQ_DISASSOCIATED;

 		INIT_LIST_HEAD(&gcwq->idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
@@ -3583,6 +3590,8 @@ static int __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker *worker;

+		if (cpu != WORK_CPU_UNBOUND)
+			gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		worker = create_worker(gcwq, true);
 		BUG_ON(!worker);
 		spin_lock_irq(&gcwq->lock);
