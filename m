Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2BUALe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:11:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22355 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2BUALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:11:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: pasik@iki.fi
Cc: xen-devel@lists.xensource.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@novell.com,
        kevin.tian@intel.com, ke.yu@intel.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen/processor-passthru: Support vCPU != pCPU - aka dom0_max_vcpus
Date: Mon, 20 Feb 2012 19:07:47 -0500
Message-Id: <1329782868-1696-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329782868-1696-1-git-send-email-konrad.wilk@oracle.com>
References: <20120214183006.GJ12984@reaktio.net>
 <1329782868-1696-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F42E124.0049,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By enumerating the ACPI CPU ID - similar to how sprocessor_core
does it - we can extract those values and provide them to the
hypervisor. For this to work, we need to wean ourself off the
cpumask type macros as they are keyed to nr_cpu_ids (which in
turn is reset to cpu_online_cpus()). We convert the framework
to use a bitmap and set the ACPI ID in it instead of the APIC ID.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/processor-passthru.c |  129 ++++++++++++++++++++++++++++++++------
 1 files changed, 110 insertions(+), 19 deletions(-)

diff --git a/drivers/xen/processor-passthru.c b/drivers/xen/processor-passthru.c
index abfcbe4..9ca2965 100644
--- a/drivers/xen/processor-passthru.c
+++ b/drivers/xen/processor-passthru.c
@@ -14,14 +14,6 @@
  *
  */
 
-/*
- *  Known limitations
- *
- * The driver can only handle up to  for_each_possible_cpu().
- * Meaning if you boot with dom0_max_cpus=X it will _only_ parse up to X
- * processors.
- */
-
 #include <linux/cpumask.h>
 #include <linux/cpufreq.h>
 #include <linux/kernel.h>
@@ -46,8 +38,15 @@ MODULE_PARM_DESC(off, "Inhibit the hypercall.");
 static int no_hypercall;
 module_param_named(off, no_hypercall, int, 0400);
 
-static DEFINE_MUTEX(processors_done_mutex);
-static DECLARE_BITMAP(processors_done, NR_CPUS);
+static DEFINE_MUTEX(acpi_ids_mutex);
+
+/*
+ * Don't think convert this to cpumask_var_t or use cpumask_bit - as those are
+ * keyed of cpu_present which can be less than what we want to put in
+ */
+#define NR_ACPI_CPUS NR_CPUS
+#define MAX_ACPI_BITS (BITS_TO_LONGS(NR_ACPI_CPUS))
+static unsigned long *acpi_ids_done;
 
 #define POLL_TIMER msecs_to_jiffies(5000 /* 5 sec */)
 static struct task_struct *xen_processor_thread;
@@ -249,13 +248,13 @@ static int xen_push_pxx_to_hypervisor(struct acpi_processor *_pr)
  * so that there is only one caller. This is so that we won't
  * race with the CPU hotplug code.
  */
-static int xen_process_data(struct acpi_processor *_pr, int cpu)
+static int xen_process_data(struct acpi_processor *_pr)
 {
 	int err = 0;
 
-	mutex_lock(&processors_done_mutex);
-	if (cpumask_test_cpu(cpu, to_cpumask(processors_done))) {
-		mutex_unlock(&processors_done_mutex);
+	mutex_lock(&acpi_ids_mutex);
+	if (__test_and_set_bit(_pr->acpi_id, acpi_ids_done)) {
+		mutex_unlock(&acpi_ids_mutex);
 		return -EBUSY;
 	}
 	if (_pr->flags.power)
@@ -264,14 +263,76 @@ static int xen_process_data(struct acpi_processor *_pr, int cpu)
 	if (_pr->performance && _pr->performance->states)
 		err |= xen_push_pxx_to_hypervisor(_pr);
 
-	cpumask_set_cpu(cpu, to_cpumask(processors_done));
-	mutex_unlock(&processors_done_mutex);
+	mutex_unlock(&acpi_ids_mutex);
 	return err;
 }
 
+/*
+ * Do not convert this to cpumask_var_t as that structure is limited to
+ * nr_cpu_ids and we can go beyound that.
+ */
+static unsigned long *acpi_id_present;
+
+static acpi_status
+xen_acpi_id_present(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	u32 acpi_id;
+	acpi_status status;
+	acpi_object_type acpi_type;
+	unsigned long long tmp;
+	union acpi_object object = { 0 };
+	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
+
+	status = acpi_get_type(handle, &acpi_type);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	switch (acpi_type) {
+	case ACPI_TYPE_PROCESSOR:
+		status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			return AE_OK;
+		acpi_id = object.processor.proc_id;
+		break;
+	case ACPI_TYPE_DEVICE:
+		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
+		if (ACPI_FAILURE(status))
+			return AE_OK;
+		acpi_id = tmp;
+		break;
+	default:
+		return AE_OK;
+	}
+	if (acpi_id > NR_ACPI_CPUS) {
+		WARN_ONCE(1, "There are %d ACPI processors, but kernel can only do %d!\n",
+		     acpi_id, NR_ACPI_CPUS);
+		return AE_OK;
+	}
+	__set_bit(acpi_id, acpi_id_present);
+
+	return AE_OK;
+}
+static unsigned int xen_enumerate_acpi_id(void)
+{
+	unsigned int n = 0;
+
+	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX,
+			    xen_acpi_id_present, NULL, NULL, NULL);
+	acpi_get_devices("ACPI0007", xen_acpi_id_present, NULL, NULL);
+
+	mutex_lock(&acpi_ids_mutex);
+	if (!bitmap_equal(acpi_id_present, acpi_ids_done, MAX_ACPI_BITS))
+		n = bitmap_weight(acpi_id_present, MAX_ACPI_BITS);
+	mutex_unlock(&acpi_ids_mutex);
+
+	return n;
+}
+
 static int xen_processor_check(void)
 {
 	struct cpufreq_policy *policy;
+	struct acpi_processor *pr_backup;
 	int cpu;
 
 	policy = cpufreq_cpu_get(smp_processor_id());
@@ -282,15 +343,40 @@ static int xen_processor_check(void)
 	for_each_online_cpu(cpu) {
 		struct acpi_processor *_pr;
 
-		_pr = per_cpu(processors, cpu);
+		_pr = per_cpu(processors, cpu /* APIC ID */);
 		if (!_pr)
 			continue;
 
-		(void)xen_process_data(_pr, cpu);
+		if (!pr_backup) {
+			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+			memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
+		}
+		(void)xen_process_data(_pr);
 	}
 	put_online_cpus();
 
 	cpufreq_cpu_put(policy);
+
+	/* All online CPUs have been processed at this stage. Now verify
+	 * whether in fact "online CPUs" == physical CPUs.
+	 */
+	acpi_id_present = kcalloc(MAX_ACPI_BITS, sizeof(unsigned long), GFP_KERNEL);
+	if (!acpi_id_present)
+		goto err_out;
+	memset(acpi_id_present, 0, MAX_ACPI_BITS * sizeof(unsigned long));
+
+	if (xen_enumerate_acpi_id() && pr_backup) {
+		for_each_set_bit(cpu, acpi_id_present, MAX_ACPI_BITS) {
+			pr_backup->acpi_id = cpu;
+			/* We will get -EBUSY if it has been programmed already. */
+			(void)xen_process_data(pr_backup);
+		}
+	}
+	kfree(acpi_id_present);
+	acpi_id_present = NULL;
+err_out:
+	kfree(pr_backup);
+	pr_backup = NULL;
 	return 0;
 }
 /*
@@ -329,7 +415,7 @@ static int xen_cpu_soft_notify(struct notifier_block *nfb,
 	struct acpi_processor *_pr = per_cpu(processors, cpu);
 
 	if (action == CPU_ONLINE && _pr)
-		(void)xen_process_data(_pr, cpu);
+		(void)xen_process_data(_pr);
 
 	return NOTIFY_OK;
 }
@@ -379,6 +465,10 @@ static int __init xen_processor_passthru_init(void)
 	if (rc)
 		return rc;
 
+	acpi_ids_done = kcalloc(MAX_ACPI_BITS, sizeof(unsigned long), GFP_KERNEL);
+	if (!acpi_ids_done)
+		return -ENOMEM;
+	memset(acpi_ids_done, 0, MAX_ACPI_BITS * sizeof(unsigned long));
 	xen_processor_thread = kthread_run(xen_processor_thread_func, NULL, DRV_NAME);
 	if (IS_ERR(xen_processor_thread)) {
 		pr_err(DRV_NAME ": Failed to create thread. Aborting.\n");
@@ -392,6 +482,7 @@ static void __exit xen_processor_passthru_exit(void)
 	unregister_hotcpu_notifier(&xen_cpu_notifier);
 	if (xen_processor_thread)
 		kthread_stop(xen_processor_thread);
+	kfree(acpi_ids_done);
 }
 late_initcall(xen_processor_passthru_init);
 module_exit(xen_processor_passthru_exit);
-- 
1.7.7.5

