Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2JLBVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:21:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2JLBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:21:29 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Z9t4_RJo5EEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=m2RLpkhMDcQA:10 a=VwQbUJbxAAAA:8 a=6iCpALQLQkUOqRxWQvIA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121012012126.643701806@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Oct 2012 21:20:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 7/8] stomp_machine: Use mutex_trylock when called from inactive cpu
References: <20121012012024.056658930@goodmis.org>
Content-Disposition: inline; filename=0007-stomp_machine-Use-mutex_trylock-when-called-from-ina.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If the stop machinery is called from inactive CPU we cannot use
mutex_lock, because some other stomp machine invokation might be in
progress and the mutex can be contended. We cannot schedule from this
context, so trylock and loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/stop_machine.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 561ba3a..e98c70b 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -158,7 +158,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 static void queue_stop_cpus_work(const struct cpumask *cpumask,
 				 cpu_stop_fn_t fn, void *arg,
-				 struct cpu_stop_done *done)
+				 struct cpu_stop_done *done, bool inactive)
 {
 	struct cpu_stop_work *work;
 	unsigned int cpu;
@@ -175,7 +175,12 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * Make sure that all work is queued on all cpus before we
 	 * any of the cpus can execute it.
 	 */
-	mutex_lock(&stopper_lock);
+	if (!inactive) {
+		mutex_lock(&stopper_lock);
+	} else {
+		while (!mutex_trylock(&stopper_lock))
+			cpu_relax();
+	}
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
@@ -188,7 +193,7 @@ static int __stop_cpus(const struct cpumask *cpumask,
 	struct cpu_stop_done done;
 
 	cpu_stop_init_done(&done, cpumask_weight(cpumask));
-	queue_stop_cpus_work(cpumask, fn, arg, &done);
+	queue_stop_cpus_work(cpumask, fn, arg, &done, false);
 	wait_for_stop_done(&done);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -601,7 +606,7 @@ int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	cpu_stop_init_done(&done, num_active_cpus());
 	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
-			     &done);
+			     &done, true);
 	ret = stop_machine_cpu_stop(&smdata);
 
 	/* Busy wait for completion. */
-- 
1.7.10.4


