Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab0E2ERM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 00:17:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:59652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0E2ERG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 00:17:06 -0400
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle driver for select intel processors
Date: Sat, 29 May 2010 06:17:19 +0200
User-Agent: KMail/1.9.10
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au
References: <1274928151-30919-1-git-send-email-lenb@kernel.org> <201005271053.31087.trenn@suse.de> <alpine.LFD.2.00.1005272131400.24823@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005272131400.24823@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005290617.20771.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010 03:44:16 am Len Brown wrote:
> On Thu, 27 May 2010, Thomas Renninger wrote:
> > On Thursday 27 May 2010 04:42:31 Len Brown wrote:
...
> > If this is known broken, should this already be spread through
> > linux-next?
>
> If you know somebody with a system that supports CPU hot-add
> on one of the processors supported by intel_idle, and they
> are willing to test linux-next, please have them contact me.
This was my attempt to fix it.
There still is an issue, eventually someone sees it,
but it may give a picture what is missing.

        Thomas

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index b5658cd..62cd8a3 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -445,7 +445,28 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		    (acpi_processor_hotadd_init(pr->handle, &pr->id))) {
 			return -ENODEV;
 		}
+		/*
+		 * CPU not initialized yet, the rest of .add must not touch
+		 * (struct cpuinfo_x86) cpu_data(cpu)!
+		 * If it does, move it from .add to init_components to
+		 * get it done, once the cpu got online and set up the
+		 * first time. Also look into the CPU_ONLINE notify code.
+		 */
+		pr->flags.hotplugged_uninitialized = 1;
+	} else {
+		struct cpuinfo_x86 *c;
+		c = &cpu_data(pr->id);
+		/*
+		 * Same as above, but the driver could have been unloaded
+		 * before the cpu got onlined the first time.
+		 */
+		if (c->x86 == 0 && c->x86_model == 0 && c->x86_mask == 0) {
+			printk(KERN_INFO "CPU %d not initialized yet!\n",
+			       pr->id);
+			pr->flags.hotplugged_uninitialized = 1;
+		}
 	}
+
 	/*
 	 * On some boxes several processors use the same processor bus id.
 	 * But they are located in different scope. For example:
@@ -535,16 +556,94 @@ static void acpi_processor_notify(struct acpi_device *device, u32 event)
 	return;
 }
 
+/*
+ * Add everything that must be run on the CPU that gets initialized
+ * or that depends on cpu_data(cpu) here.
+ * Otherwise things will break in cpu hotadd case as this info is not
+ * yet available in acpi_processor_add or acpi_processor_get_info()
+ */
+
+static int __cpuinit acpi_processor_init_components(struct acpi_processor *pr)
+{
+	int result = 0;
+	struct acpi_device *device;
+
+	acpi_bus_get_device(pr->handle, &device);
+
+	printk(KERN_INFO "%s - cpu: %d\n", __func__, pr->id);
+
+#ifdef CONFIG_CPU_FREQ
+	acpi_processor_ppc_has_changed(pr, 0);
+#endif
+	acpi_processor_get_throttling_info(pr);
+	acpi_processor_get_limit_info(pr);
+
+
+	acpi_processor_power_init(pr, device);
+
+	pr->cdev = thermal_cooling_device_register("Processor", device,
+						&processor_cooling_ops);
+	if (IS_ERR(pr->cdev)) {
+		result = PTR_ERR(pr->cdev);
+		goto err_power_exit;
+	}
+
+	dev_dbg(&device->dev, "registered as cooling_device%d\n",
+		 pr->cdev->id);
+
+	result = sysfs_create_link(&device->dev.kobj,
+				   &pr->cdev->device.kobj,
+				   "thermal_cooling");
+	if (result) {
+		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		goto err_thermal_unregister;
+	}
+	result = sysfs_create_link(&pr->cdev->device.kobj,
+				   &device->dev.kobj,
+				   "device");
+	if (result) {
+		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		goto err_remove_sysfs;
+	}
+
+	return 0;
+
+err_remove_sysfs:
+	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+err_thermal_unregister:
+	thermal_cooling_device_unregister(pr->cdev);
+err_power_exit:
+	acpi_processor_power_exit(pr, device);
+
+	return result;
+}
+
+
 static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 		unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
+	int ret;
 
 	if (action == CPU_ONLINE && pr) {
-		acpi_processor_ppc_has_changed(pr, 0);
-		acpi_processor_cst_has_changed(pr);
-		acpi_processor_tstate_has_changed(pr);
+		if (pr->flags.hotplugged_uninitialized) {
+			/* We only run into this if a CPU got hotplugged
+			 * and not fully initialized yet in .add
+			 * We have to do it here and only once,
+			 * because in .add cpu_data(cpu) is not set up yet
+			 */
+			acpi_processor_set_pdc(pr);
+			ret = acpi_processor_init_components(pr);
+			printk(KERN_INFO "Do initialize: %d - CPU: %d\n",
+			       ret, pr->id);
+			pr->flags.hotplugged_uninitialized = 0;
+		} else {
+			printk(KERN_INFO "already initialized: %d\n", pr->id);
+			acpi_processor_ppc_has_changed(pr, 0);
+			acpi_processor_cst_has_changed(pr);
+			acpi_processor_tstate_has_changed(pr);
+		}
 	}
 	return NOTIFY_OK;
 }
@@ -608,48 +707,14 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		goto err_remove_fs;
 	}
 
-#ifdef CONFIG_CPU_FREQ
-	acpi_processor_ppc_has_changed(pr, 0);
-#endif
-	acpi_processor_get_throttling_info(pr);
-	acpi_processor_get_limit_info(pr);
-
-
-	acpi_processor_power_init(pr, device);
-
-	pr->cdev = thermal_cooling_device_register("Processor", device,
-						&processor_cooling_ops);
-	if (IS_ERR(pr->cdev)) {
-		result = PTR_ERR(pr->cdev);
-		goto err_power_exit;
-	}
-
-	dev_dbg(&device->dev, "registered as cooling_device%d\n",
-		 pr->cdev->id);
-
-	result = sysfs_create_link(&device->dev.kobj,
-				   &pr->cdev->device.kobj,
-				   "thermal_cooling");
-	if (result) {
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
-		goto err_thermal_unregister;
-	}
-	result = sysfs_create_link(&pr->cdev->device.kobj,
-				   &device->dev.kobj,
-				   "device");
-	if (result) {
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
-		goto err_remove_sysfs;
+	if (!pr->flags.hotplugged_uninitialized) {
+		result = acpi_processor_init_components(pr);
+		if (result)
+			goto err_remove_fs;
 	}
 
 	return 0;
 
-err_remove_sysfs:
-	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
-err_thermal_unregister:
-	thermal_cooling_device_unregister(pr->cdev);
-err_power_exit:
-	acpi_processor_power_exit(pr, device);
 err_remove_fs:
 	acpi_processor_remove_fs(device);
 err_free_cpumask:
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 86825dd..e7716ec 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -207,6 +207,7 @@ struct acpi_processor_flags {
 	u8 has_cst:1;
 	u8 power_setup_done:1;
 	u8 bm_rld_set:1;
+	u8 hotplugged_uninitialized:1;
 };
 
 struct acpi_processor {

