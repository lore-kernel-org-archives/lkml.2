Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2GASZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:25:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46966 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071Ab2GASQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:36 -0400
Message-Id: <20120701172013.334132912@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Hayes <Stuart_Hayes@Dell.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 47/48] acpi_pad: fix power_saving thread deadlock
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <Stuart_Hayes@Dell.com>

commit 5f1601261050251a5ca293378b492a69d590dacb upstream.

The acpi_pad driver can get stuck in destroy_power_saving_task()
waiting for kthread_stop() to stop a power_saving thread.  The problem
is that the isolated_cpus_lock mutex is owned when
destroy_power_saving_task() calls kthread_stop(), which waits for a
power_saving thread to end, and the power_saving thread tries to
acquire the isolated_cpus_lock when it calls round_robin_cpu().  This
patch fixes the issue by making round_robin_cpu() use its own mutex.

https://bugzilla.kernel.org/show_bug.cgi?id=42981

Signed-off-by: Stuart Hayes <Stuart_Hayes@Dell.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/acpi_pad.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index a43fa1a..1502c502 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -36,6 +36,7 @@
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
+static DEFINE_MUTEX(round_robin_lock);
 
 static unsigned long power_saving_mwait_eax;
 
@@ -107,7 +108,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;
 
-	mutex_lock(&isolated_cpus_lock);
+	mutex_lock(&round_robin_lock);
 	cpumask_clear(tmp);
 	for_each_cpu(cpu, pad_busy_cpus)
 		cpumask_or(tmp, tmp, topology_thread_cpumask(cpu));
@@ -116,7 +117,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	if (cpumask_empty(tmp))
 		cpumask_andnot(tmp, cpu_online_mask, pad_busy_cpus);
 	if (cpumask_empty(tmp)) {
-		mutex_unlock(&isolated_cpus_lock);
+		mutex_unlock(&round_robin_lock);
 		return;
 	}
 	for_each_cpu(cpu, tmp) {
@@ -131,7 +132,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	tsk_in_cpu[tsk_index] = preferred_cpu;
 	cpumask_set_cpu(preferred_cpu, pad_busy_cpus);
 	cpu_weight[preferred_cpu]++;
-	mutex_unlock(&isolated_cpus_lock);
+	mutex_unlock(&round_robin_lock);
 
 	set_cpus_allowed_ptr(current, cpumask_of(preferred_cpu));
 }


