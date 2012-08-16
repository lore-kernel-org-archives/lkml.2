Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2HPMye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:54:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39319 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2HPMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:54:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120727162038.GD12244@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	<20120727162038.GD12244@redhat.com>
Date: Thu, 16 Aug 2012 20:54:31 +0800
Message-ID: <CACVXFVO-_bP33syDr22TkX2Rsfhb6rNmUNBtsQBnnyqJxdXRyw@mail.gmail.com>
Subject: Re: lockdep trace from posix timers
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 12:20 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Jul 24, 2012 at 04:36:13PM -0400, Dave Jones wrote:
>  > Linus tree as of 5fecc9d8f59e765c2a48379dd7c6f5cf88c7d75a
>  >
>  >      Dave
>  >
>  > ======================================================
>  > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
>  > 3.5.0+ #122 Not tainted
>  > ------------------------------------------------------
>  > trinity-child2/5327 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>  > blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff8109762b>] posix_cpu_timer_del+0x2b/0xe0
>  >
>  > and this task is already holding:
>  > blocked:  (&(&new_timer->it_lock)->rlock){-.-...}, instance: ffff880143bce170, at: [<ffffffff81093d49>] __lock_timer+0x89/0x1f0
>  > which would create a new lock dependency:
>  >  (&(&new_timer->it_lock)->rlock){-.-...} -> (tasklist_lock){.+.+..}
>  >
>  > but this new dependency connects a HARDIRQ-irq-safe lock:
>  >  (&(&new_timer->it_lock)->rlock){-.-...}
>  > ... which became HARDIRQ-irq-safe at:
>
> Shall I start bisecting this ? I can trigger it very easily, but if you
> can give me a set of commits to narrow down, it'll speed up the bisection.

It should a real possible deadlock, could you test the below patch to
see if it can fix the warning?

--
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..29f6a8e 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -420,7 +420,7 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	int ret = 0;

 	if (likely(p != NULL)) {
-		read_lock(&tasklist_lock);
+		/* tasklist_lock held already in timer_delete */
 		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * We raced with the reaping of the task.
@@ -435,7 +435,6 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 				list_del(&timer->it.cpu.entry);
 			spin_unlock(&p->sighand->siglock);
 		}
-		read_unlock(&tasklist_lock);

 		if (!ret)
 			put_task_struct(p);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..222d24c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -884,15 +884,31 @@ SYSCALL_DEFINE1(timer_delete, timer_t, timer_id)
 	struct k_itimer *timer;
 	unsigned long flags;

+	/*
+	 * hold tasklist_lock to protect tsk->sighand which might be
+	 * accessed inside ->timer_del. It should be held before
+	 * timer->it_lock to avoid the below deadlock:
+	 * 	CPU0			CPU1
+	 *	lock(tasklist_lock)
+	 *				timer_delete()
+	 *					lock(timer->it_lock)
+	 *					lock(tasklist_lock)
+	 *	<timer interrupt>
+	 *		lock(timer->it_lock)
+	 */
+	read_lock(&tasklist_lock);
 retry_delete:
 	timer = lock_timer(timer_id, &flags);
-	if (!timer)
+	if (!timer) {
+		read_unlock(&tasklist_lock);
 		return -EINVAL;
+	}

 	if (timer_delete_hook(timer) == TIMER_RETRY) {
 		unlock_timer(timer, flags);
 		goto retry_delete;
 	}
+	read_unlock(&tasklist_lock);

 	spin_lock(&current->sighand->siglock);
 	list_del(&timer->list);


Thanks,
-- 
Ming Lei
