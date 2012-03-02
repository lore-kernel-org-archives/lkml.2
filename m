Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306Ab2CBPhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:37:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab2CBPg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:36:59 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=iqH1YQEIiWMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=0DtkhaoAg2pSKGPVn9IA:9 a=4tUZVHvCoqhFIeNa9DYA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330702617.25686.265.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Date: Fri, 02 Mar 2012 10:36:57 -0500
In-Reply-To: <alpine.LFD.2.02.1203021618330.2742@ionos>
References: <20120301185527.064629423@goodmis.org>
	  <20120301190346.172835662@goodmis.org>
	  <alpine.LFD.2.02.1203021518501.2742@ionos>
	 <1330701323.25686.260.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203021618330.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 16:20 +0100, Thomas Gleixner wrote:

> Already queued. I'd say #4 is a bug fix as well, though I
> fundamentally hate the ass backwards semantics of that new function.

It is a bug fix, but I don't like it either. Note, that the patch didn't
update the pin_current_cpu() code, which would have to be done too (to
be a full fix).

But I was also thinking that as a work around, as we plan on changing
this code anyway. Instead of adding a new API which is ass backwards,
just encompass the cpu_hotplug.lock instead. Something like this:

Not tested nor complied.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Yes this is ugly, but at least we don't introduce an ass backwards
semantic.

diff --git a/kernel/cpu.c b/kernel/cpu.c
index fa40834..c25b5ff 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -46,7 +46,12 @@ static int cpu_hotplug_disabled;
 
 static struct {
 	struct task_struct *active_writer;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* Makes the lock keep the task's state */
+	spinlock_t lock;
+#else
 	struct mutex lock; /* Synchronizes accesses to refcount, */
+#endif
 	/*
 	 * Also blocks the new readers during
 	 * an ongoing cpu hotplug operation.
@@ -58,6 +63,14 @@ static struct {
 	.refcount = 0,
 };
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define hotplug_lock() spin_lock(&cpu_hotplug.lock)
+# define hotplug_unlock() spin_unlock(&cpu_hotplug.lock)
+#else
+# define hotplug_lock() mutex_lock(&cpu_hotplug.lock)
+# define hotplug_lock() mutex_unlock(&cpu_hotplug.lock)
+#endif
+
 struct hotplug_pcp {
 	struct task_struct *unplug;
 	int refcount;
@@ -87,8 +100,8 @@ retry:
 		return;
 	}
 	preempt_enable();
-	mutex_lock(&cpu_hotplug.lock);
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_lock();
+	hotplug_unlock();
 	preempt_disable();
 	goto retry;
 }
@@ -161,9 +174,9 @@ void get_online_cpus(void)
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	hotplug_lock();
 	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
 
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
@@ -172,10 +185,10 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	hotplug_lock();
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
 
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
@@ -207,11 +220,11 @@ static void cpu_hotplug_begin(void)
 	cpu_hotplug.active_writer = current;
 
 	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
+		hotplug_lock();
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
+		hotplug_unlock();
 		schedule();
 	}
 }
@@ -219,7 +232,7 @@ static void cpu_hotplug_begin(void)
 static void cpu_hotplug_done(void)
 {
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
 }
 
 #else /* #if CONFIG_HOTPLUG_CPU */


