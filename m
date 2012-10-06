Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2JFPfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:35:04 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63340 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2JFPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:34:58 -0400
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
Subject: [RFC PATCH v3 21/28] ACPIHP/processor: reorganize ACPI processor driver for new hotplug framework
Date: Sat,  6 Oct 2012 23:27:29 +0800
Message-Id: <1349537256-21670-22-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorganizes code in processor_driver.c to parepare for
integration with the new hotplug framework. Common code could be
shared among acpi_processor_add(), acpi_processor_remove() and hotplug
has been reorganized as:
acpi_processor_start()
acpi_processor_stop()
acpi_processor_link()
acpi_processor_unlink()

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/processor_driver.c |  179 +++++++++++++++++++++++----------------
 include/acpi/processor.h        |    2 +
 2 files changed, 108 insertions(+), 73 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index abbce9e..4f2fec0 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -105,6 +105,8 @@ static struct acpi_driver acpi_processor_driver = {
 #define INSTALL_NOTIFY_HANDLER		1
 #define UNINSTALL_NOTIFY_HANDLER	2
 
+static DEFINE_PER_CPU(void *, processor_device_array);
+
 DEFINE_PER_CPU(struct acpi_processor *, processors);
 EXPORT_PER_CPU_SYMBOL(processors);
 
@@ -327,11 +329,11 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	 * \_SB.SCK1.CPU0
 	 * Rename the processor device bus id. And the new bus id will be
 	 * generated as the following format:
-	 * CPU+CPU ID.
+	 * CPU+ACPI ID.
 	 */
-	sprintf(acpi_device_bid(device), "CPU%X", pr->id);
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Processor [%d:%d]\n", pr->id,
-			  pr->acpi_id));
+	sprintf(acpi_device_bid(device), "CPU%X", pr->acpi_id);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Processor [%d:%d]\n", pr->acpi_id,
+			  pr->id));
 
 	if (!object.processor.pblk_address)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
@@ -355,19 +357,67 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		request_region(pr->throttling.address, 6, "ACPI CPU throttle");
 	}
 
+	return 0;
+}
+
+static int acpi_processor_link(struct acpi_device *device,
+			       struct acpi_processor *pr)
+{
+	struct device *dev;
+	acpi_status status;
+	unsigned long long value;
+
+	if (pr->flags.device_linked)
+		return 0;
+
 	/*
 	 * If ACPI describes a slot number for this CPU, we can use it
 	 * ensure we get the right value in the "physical id" field
 	 * of /proc/cpuinfo
 	 */
-	status = acpi_evaluate_object(pr->handle, "_SUN", NULL, &buffer);
+	status = acpi_evaluate_integer(pr->handle, "_SUN", NULL, &value);
 	if (ACPI_SUCCESS(status))
-		arch_fix_phys_package_id(pr->id, object.integer.value);
+		arch_fix_phys_package_id(pr->id, value);
+
+	/*
+	 * Buggy BIOS check
+	 * ACPI id of processors can be reported wrongly by the BIOS.
+	 * Don't trust it blindly
+	 */
+	if (per_cpu(processor_device_array, pr->id) != NULL &&
+	    per_cpu(processor_device_array, pr->id) != device) {
+		dev_warn(&device->dev,
+			 "BIOS reported wrong ACPI id for the processor\n");
+		return -ENODEV;
+	}
+	per_cpu(processor_device_array, pr->id) = device;
+	per_cpu(processors, pr->id) = pr;
+
+	dev = get_cpu_device(pr->id);
+	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
+		/*
+		 * processor_device_array is not cleared to allow checks
+		 * for buggy BIOS
+		 */ 
+		per_cpu(processors, pr->id) = NULL;
+		return -EFAULT;
+	}
+
+	pr->flags.device_linked = 1;
 
 	return 0;
 }
 
-static DEFINE_PER_CPU(void *, processor_device_array);
+static void acpi_processor_unlink(struct acpi_device *device,
+				  struct acpi_processor *pr)
+{
+	if (pr->flags.device_linked) {
+		sysfs_remove_link(&device->dev.kobj, "sysdev");
+		per_cpu(processor_device_array, pr->id) = NULL;
+		per_cpu(processors, pr->id) = NULL;
+		pr->flags.device_linked = 0;
+	}
+}
 
 static void acpi_processor_notify(struct acpi_device *device, u32 event)
 {
@@ -422,11 +472,11 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 		if (pr->flags.need_hotplug_init) {
 			printk(KERN_INFO "Will online and init hotplugged "
 			       "CPU: %d\n", pr->id);
-			WARN(acpi_processor_start(pr), "Failed to start CPU:"
-				" %d\n", pr->id);
+			WARN(acpi_processor_start(pr),
+				"Failed to start CPU: %d\n", pr->id);
 			pr->flags.need_hotplug_init = 0;
 		/* Normal CPU soft online event */
-		} else {
+		} else if (pr->flags.device_started) {
 			acpi_processor_ppc_has_changed(pr, 0);
 			acpi_processor_hotplug(pr);
 			acpi_processor_reevaluate_tstate(pr, action);
@@ -458,6 +508,9 @@ static __ref int acpi_processor_start(struct acpi_processor *pr)
 	struct acpi_device *device = per_cpu(processor_device_array, pr->id);
 	int result = 0;
 
+	if (pr->flags.device_started)
+		return 0;
+
 #ifdef CONFIG_CPU_FREQ
 	acpi_processor_ppc_has_changed(pr, 0);
 	acpi_processor_load_module(pr);
@@ -493,6 +546,8 @@ static __ref int acpi_processor_start(struct acpi_processor *pr)
 		goto err_remove_sysfs_thermal;
 	}
 
+	pr->flags.device_started = 1;
+
 	return 0;
 
 err_remove_sysfs_thermal:
@@ -505,6 +560,21 @@ err_power_exit:
 	return result;
 }
 
+static void acpi_processor_stop(struct acpi_device *device,
+				struct acpi_processor *pr)
+{
+	if (pr->flags.device_started) {
+		acpi_processor_power_exit(pr, device);
+		if (pr->cdev) {
+			sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+			sysfs_remove_link(&pr->cdev->device.kobj, "device");
+			thermal_cooling_device_unregister(pr->cdev);
+			pr->cdev = NULL;
+		}
+		pr->flags.device_started = 0;
+	}
+}
+
 /*
  * Do not put anything in here which needs the core to be online.
  * For example MSR access or setting up things which check for cpuinfo_x86
@@ -513,9 +583,8 @@ err_power_exit:
  */
 static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
-	struct acpi_processor *pr = NULL;
-	int result = 0;
-	struct device *dev;
+	struct acpi_processor *pr;
+	int result;
 
 	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
@@ -532,60 +601,36 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	device->driver_data = pr;
 
 	result = acpi_processor_get_info(device);
-	if (result) {
-		/* Processor is physically not present */
-		return 0;
-	}
-
-#ifdef CONFIG_SMP
-	if (pr->id >= setup_max_cpus && pr->id != 0)
-		return 0;
-#endif
-
-	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
-
-	/*
-	 * Buggy BIOS check
-	 * ACPI id of processors can be reported wrongly by the BIOS.
-	 * Don't trust it blindly
-	 */
-	if (per_cpu(processor_device_array, pr->id) != NULL &&
-	    per_cpu(processor_device_array, pr->id) != device) {
-		printk(KERN_WARNING "BIOS reported wrong ACPI id "
-			"for the processor\n");
-		result = -ENODEV;
+	if (result)
 		goto err_free_cpumask;
-	}
-	per_cpu(processor_device_array, pr->id) = device;
-
-	per_cpu(processors, pr->id) = pr;
-
-	dev = get_cpu_device(pr->id);
-	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
-		result = -EFAULT;
-		goto err_clear_processor;
-	}
 
 	/*
-	 * Do not start hotplugged CPUs now, but when they
-	 * are onlined the first time
+	 * Delay linking with logical CPU device if:
+	 * 1) no CPUID assigned yet
+	 * 2) processor won't be boot if CPUID is bigger than setup_max_cpus
+	 * They will be handled by CPU hotplug logical later.
 	 */
-	if (pr->flags.need_hotplug_init)
+	if (pr->id == -1)
 		return 0;
+	if (IS_BUILTIN(CONFIG_SMP) && pr->id >= setup_max_cpus && pr->id != 0)
+		return 0;
+	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
-	result = acpi_processor_start(pr);
+	result = acpi_processor_link(device, pr);
 	if (result)
-		goto err_remove_sysfs;
+		goto err_unlock;
+	if (cpu_online(pr->id)) {
+		result = acpi_processor_start(pr);
+		if (result)
+			goto err_unlink;
+	}
 
 	return 0;
 
-err_remove_sysfs:
-	sysfs_remove_link(&device->dev.kobj, "sysdev");
-err_clear_processor:
-	/*
-	 * processor_device_array is not cleared to allow checks for buggy BIOS
-	 */ 
-	per_cpu(processors, pr->id) = NULL;
+err_unlink:
+	acpi_processor_unlink(device, pr);
+err_unlock:
+	put_online_cpus();
 err_free_cpumask:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
 err_free_pr:
@@ -595,14 +640,12 @@ err_free_pr:
 
 static int acpi_processor_remove(struct acpi_device *device, int type)
 {
-	struct acpi_processor *pr = NULL;
-
+	struct acpi_processor *pr;
 
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
 	pr = acpi_driver_data(device);
-
 	if (pr->id >= nr_cpu_ids)
 		goto free;
 
@@ -611,21 +654,11 @@ static int acpi_processor_remove(struct acpi_device *device, int type)
 			return -EINVAL;
 	}
 
-	acpi_processor_power_exit(pr, device);
-
-	sysfs_remove_link(&device->dev.kobj, "sysdev");
-
-	if (pr->cdev) {
-		sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
-		sysfs_remove_link(&pr->cdev->device.kobj, "device");
-		thermal_cooling_device_unregister(pr->cdev);
-		pr->cdev = NULL;
-	}
-
-	per_cpu(processors, pr->id) = NULL;
-	per_cpu(processor_device_array, pr->id) = NULL;
+	acpi_processor_stop(device, pr);
+	acpi_processor_unlink(device, pr);
 
 free:
+	device->driver_data = NULL;
 	free_cpumask_var(pr->throttling.shared_cpu_map);
 	kfree(pr);
 
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 64ec644..ae7d94e 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -193,6 +193,8 @@ struct acpi_processor_flags {
 	u8 power_setup_done:1;
 	u8 bm_rld_set:1;
 	u8 need_hotplug_init:1;
+	u8 device_linked:1;
+	u8 device_started:1;
 };
 
 struct acpi_processor {
-- 
1.7.9.5

