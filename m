Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162756Ab2GLXQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:16:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162642Ab2GLXET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:04:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stuart Hayes <Stuart_Hayes@Dell.com>, Len Brown <len.brown@intel.com>
Subject: [ 29/68] acpi_pad: fix power_saving thread deadlock
Date: Thu, 12 Jul 2012 16:02:03 -0700
Message-Id: <20120712175038.044800951@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_pad.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -36,6 +36,7 @@
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
+static DEFINE_MUTEX(round_robin_lock);
 
 static unsigned long power_saving_mwait_eax;
 
@@ -107,7 +108,7 @@ static void round_robin_cpu(unsigned int
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;
 
-	mutex_lock(&isolated_cpus_lock);
+	mutex_lock(&round_robin_lock);
 	cpumask_clear(tmp);
 	for_each_cpu(cpu, pad_busy_cpus)
 		cpumask_or(tmp, tmp, topology_thread_cpumask(cpu));
@@ -116,7 +117,7 @@ static void round_robin_cpu(unsigned int
 	if (cpumask_empty(tmp))
 		cpumask_andnot(tmp, cpu_online_mask, pad_busy_cpus);
 	if (cpumask_empty(tmp)) {
-		mutex_unlock(&isolated_cpus_lock);
+		mutex_unlock(&round_robin_lock);
 		return;
 	}
 	for_each_cpu(cpu, tmp) {
@@ -131,7 +132,7 @@ static void round_robin_cpu(unsigned int
 	tsk_in_cpu[tsk_index] = preferred_cpu;
 	cpumask_set_cpu(preferred_cpu, pad_busy_cpus);
 	cpu_weight[preferred_cpu]++;
-	mutex_unlock(&isolated_cpus_lock);
+	mutex_unlock(&round_robin_lock);
 
 	set_cpus_allowed_ptr(current, cpumask_of(preferred_cpu));
 }


