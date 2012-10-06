Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2JFPgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:36:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2JFPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:36:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v3 26/28] ACPI/processor: save parsed APIC ID in processor driver data structure
Date: Sat,  6 Oct 2012 23:27:34 +0800
Message-Id: <1349537256-21670-27-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance ACPI processor driver to save parsed APIC ID in processor driver
data structure, and avoid reparsing again in _acpi_map_lsapic().
This change also makes fake CPU hotplug possible because we have no
dependency on _MAT method now.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/ia64/kernel/acpi.c         |   38 ++++----------------------------------
 arch/x86/kernel/acpi/boot.c     |   38 +++-----------------------------------
 drivers/acpi/internal.h         |    2 ++
 drivers/acpi/processor_core.c   |   26 +++++++++++++++++++++-----
 drivers/acpi/processor_driver.c |   15 +++++++++------
 include/acpi/processor.h        |    1 +
 include/linux/acpi.h            |    2 +-
 7 files changed, 41 insertions(+), 81 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 44057885..f0da941 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -880,40 +880,10 @@ __init void prefill_possible_map(void)
 		set_cpu_possible(i, true);
 }
 
-static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
+static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu)
 {
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
-	struct acpi_madt_local_sapic *lsapic;
 	cpumask_t tmp_map;
-	int cpu, physid;
-
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
-		return -EINVAL;
-
-	if (!buffer.length || !buffer.pointer)
-		return -EINVAL;
-
-	obj = buffer.pointer;
-	if (obj->type != ACPI_TYPE_BUFFER)
-	{
-		kfree(buffer.pointer);
-		return -EINVAL;
-	}
-
-	lsapic = (struct acpi_madt_local_sapic *)obj->buffer.pointer;
-
-	if ((lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) ||
-	    (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))) {
-		kfree(buffer.pointer);
-		return -EINVAL;
-	}
-
-	physid = ((lsapic->id << 8) | (lsapic->eid));
-
-	kfree(buffer.pointer);
-	buffer.length = ACPI_ALLOCATE_BUFFER;
-	buffer.pointer = NULL;
+	int cpu;
 
 	cpumask_complement(&tmp_map, cpu_present_mask);
 	cpu = cpumask_first(&tmp_map);
@@ -932,9 +902,9 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 }
 
 /* wrapper to silence section mismatch warning */
-int __ref acpi_map_lsapic(acpi_handle handle, int *pcpu)
+int __ref acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu)
 {
-	return _acpi_map_lsapic(handle, pcpu);
+	return _acpi_map_lsapic(handle, physid, pcpu);
 }
 EXPORT_SYMBOL(acpi_map_lsapic);
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e651f7a..5e76952 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -608,44 +608,12 @@ static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 #endif
 }
 
-static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
+static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu)
 {
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
-	struct acpi_madt_local_apic *lapic;
 	cpumask_var_t tmp_map, new_map;
-	u8 physid;
 	int cpu;
 	int retval = -ENOMEM;
 
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
-		return -EINVAL;
-
-	if (!buffer.length || !buffer.pointer)
-		return -EINVAL;
-
-	obj = buffer.pointer;
-	if (obj->type != ACPI_TYPE_BUFFER ||
-	    obj->buffer.length < sizeof(*lapic)) {
-		kfree(buffer.pointer);
-		return -EINVAL;
-	}
-
-	lapic = (struct acpi_madt_local_apic *)obj->buffer.pointer;
-
-	if (lapic->header.type != ACPI_MADT_TYPE_LOCAL_APIC ||
-	    !(lapic->lapic_flags & ACPI_MADT_ENABLED)) {
-		kfree(buffer.pointer);
-		return -EINVAL;
-	}
-
-	physid = lapic->id;
-
-	kfree(buffer.pointer);
-	buffer.length = ACPI_ALLOCATE_BUFFER;
-	buffer.pointer = NULL;
-	lapic = NULL;
-
 	if (!alloc_cpumask_var(&tmp_map, GFP_KERNEL))
 		goto out;
 
@@ -683,9 +651,9 @@ out:
 }
 
 /* wrapper to silence section mismatch warning */
-int __ref acpi_map_lsapic(acpi_handle handle, int *pcpu)
+int __ref acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu)
 {
-	return _acpi_map_lsapic(handle, pcpu);
+	return _acpi_map_lsapic(handle, physid, pcpu);
 }
 EXPORT_SYMBOL(acpi_map_lsapic);
 
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 6f0632d..036dba11 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -47,6 +47,8 @@ int acpi_bus_init_power(struct acpi_device *device);
 
 int acpi_wakeup_device_init(void);
 void acpi_early_processor_set_pdc(void);
+int acpi_get_apicid(acpi_handle handle, int type, u32 acpi_id);
+int acpi_map_cpuid(int apic_id, u32 acpi_id);
 
 /* --------------------------------------------------------------------------
                                   Embedded Controller
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index eff7222..21217e5 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -163,16 +163,23 @@ exit:
 	return apic_id;
 }
 
-int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+int acpi_get_apicid(acpi_handle handle, int type, u32 acpi_id)
 {
-#ifdef CONFIG_SMP
-	int i;
-#endif
-	int apic_id = -1;
+	int apic_id;
 
 	apic_id = map_mat_entry(handle, type, acpi_id);
 	if (apic_id == -1)
 		apic_id = map_madt_entry(type, acpi_id);
+
+	return apic_id;
+}
+
+int acpi_map_cpuid(int apic_id, u32 acpi_id)
+{
+#ifdef CONFIG_SMP
+	int i;
+#endif
+
 	if (apic_id == -1) {
 		/*
 		 * On UP processor, there is no _MAT or MADT table.
@@ -212,6 +219,15 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 #endif
 	return -1;
 }
+
+int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+{
+	int apic_id;
+
+	apic_id = acpi_get_apicid(handle, type, acpi_id);
+
+	return acpi_map_cpuid(apic_id, acpi_id);
+}
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 
 static bool __init processor_physically_present(acpi_handle handle)
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 51e3993..2346b81 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -57,6 +57,7 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 #include <acpi/acpi_hotplug.h>
+#include "internal.h"
 
 #define PREFIX "ACPI: "
 
@@ -303,7 +304,8 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		device_declaration = 1;
 		pr->acpi_id = value;
 	}
-	cpu_index = acpi_get_cpuid(pr->handle, device_declaration, pr->acpi_id);
+	pr->apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
+	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
 
 	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 	if (!cpu0_initialized && (cpu_index == -1) &&
@@ -689,7 +691,7 @@ static int acpi_processor_get_dev_info(struct acpi_device *device,
 static int acpi_processor_pre_configure(struct acpi_device *device,
 					struct acpihp_cancel_context *ctx)
 {
-	int result;
+	int result = -EINVAL;
 	struct acpi_processor *pr;
 
 	if (!device || !acpi_driver_data(device))
@@ -698,9 +700,11 @@ static int acpi_processor_pre_configure(struct acpi_device *device,
 
 	/* Generate CPUID for hot-added CPUs */
 	if (pr->id == -1) {
-		result = acpi_map_lsapic(device->handle, &pr->id);
+		if (pr->apic_id == -1)
+			goto out;
+		result = acpi_map_lsapic(device->handle, pr->apic_id, &pr->id);
 		if (result)
-			goto out_unlock;
+			goto out;
 		BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 		result = arch_register_cpu(pr->id, 1);
 		if (result)
@@ -720,8 +724,7 @@ static int acpi_processor_pre_configure(struct acpi_device *device,
 out_unmap:
 	acpi_unmap_lsapic(pr->id);
 	pr->id = -1;
-out_unlock:
-	put_online_cpus();
+out:
 
 	return result;
 }
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index ae7d94e..da65f1f 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -200,6 +200,7 @@ struct acpi_processor_flags {
 struct acpi_processor {
 	acpi_handle handle;
 	u32 acpi_id;
+	int apic_id;
 	u32 id;
 	u32 pblk;
 	int performance_platform_limit;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 90be989..774ce2b 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -101,7 +101,7 @@ void acpi_numa_arch_fixup(void);
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
-int acpi_map_lsapic(acpi_handle handle, int *pcpu);
+int acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu);
 int acpi_unmap_lsapic(int cpu);
 #endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
-- 
1.7.9.5

