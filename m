Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2CLTG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:06:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab2CLTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:06:26 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=fBzF5iKUyvoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GBhLJ1p4cjeliqP90SAA:9 a=PS2_3D2WbZL-iRpi1AcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331579183.25686.656.camel@gandalf.stny.rr.com>
Subject: [PATCH RT] hack: Workaround to mtrr sleeping function called from
 atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark@redhat.com>, Carsten Emde <cbe@osadl.org>
Date: Mon, 12 Mar 2012 15:06:23 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After adding my (unacceptable) CPU hotplug patchset on top of 3.2.9-rt17
I hit this bug:


        <3>BUG: sleeping function called from invalid context
        at /home/rostedt/work/git/linux-rt.git/kernel/rtmutex.c:1264
        <3>in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/1
        2 locks held by swapper/1/0:
         #0:  (stop_cpus_mutex){......}, at: [<ffffffff8108f1da>]
        stop_machine_from_inactive_cpu+0x5e/0xd4
         #1:  (stopper_lock){......}, at: [<ffffffff8108ee75>]
        queue_stop_cpus_work+0x79/0xce
        Pid: 0, comm: swapper/1 Not tainted 3.2.9-test-rt17+ #30
        Call Trace:
         [<ffffffff8103374f>] __might_sleep+0xf6/0xfb
         [<ffffffff814281f1>] rt_mutex_lock+0x21/0x34
         [<ffffffff81428a87>] _mutex_lock+0x3c/0x43
         [<ffffffff8108ee75>] ? queue_stop_cpus_work+0x79/0xce
         [<ffffffff8108ee75>] queue_stop_cpus_work+0x79/0xce
         [<ffffffff8108f21c>] stop_machine_from_inactive_cpu+0xa0/0xd4
         [<ffffffff810169b6>] ? mtrr_restore+0x4a/0x4a
         [<ffffffff81016fd8>] mtrr_ap_init+0x5a/0x5c
         [<ffffffff814175eb>] identify_secondary_cpu+0x19/0x1b
         [<ffffffff81419e5f>] smp_store_cpu_info+0x3c/0x3e
         [<ffffffff8141a242>] start_secondary+0xf9/0x1d2
        

I wrote the following patch to work around this bug and currently the
hotplug stress test is still chugging along just fine :-)

Note, I expect this patch to be unacceptable too, but I'm posting it for
those that might be interested.

It should probably be commented too. The gist is that if the
queue_stop_cpus_work() is called from an inactive CPU (one coming on
line) it does a spin lock on the stopper_lock instead of grabbing it. I
haven't looked too deeply if this would cause deadlocks, because
honestly, I think this patch sucks :-p


-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 561ba3a..899dc12 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -158,7 +158,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 static void queue_stop_cpus_work(const struct cpumask *cpumask,
 				 cpu_stop_fn_t fn, void *arg,
-				 struct cpu_stop_done *done)
+				 struct cpu_stop_done *done, int inactive)
 {
 	struct cpu_stop_work *work;
 	unsigned int cpu;
@@ -175,7 +175,11 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * Make sure that all work is queued on all cpus before we
 	 * any of the cpus can execute it.
 	 */
-	mutex_lock(&stopper_lock);
+	if (inactive)
+		while (!mutex_trylock(&stopper_lock))
+			cpu_relax();
+	else
+		mutex_lock(&stopper_lock);
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
@@ -188,7 +192,7 @@ static int __stop_cpus(const struct cpumask *cpumask,
 	struct cpu_stop_done done;
 
 	cpu_stop_init_done(&done, cpumask_weight(cpumask));
-	queue_stop_cpus_work(cpumask, fn, arg, &done);
+	queue_stop_cpus_work(cpumask, fn, arg, &done, 0);
 	wait_for_stop_done(&done);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -601,7 +605,7 @@ int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	cpu_stop_init_done(&done, num_active_cpus());
 	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
-			     &done);
+			     &done, 1);
 	ret = stop_machine_cpu_stop(&smdata);
 
 	/* Busy wait for completion. */



