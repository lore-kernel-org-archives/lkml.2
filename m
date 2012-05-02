Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2EBPKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:10:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:4064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab2EBPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95539640"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] hwmon: coretemp: use list instead of fixed size array for temp data
Date: Wed,  2 May 2012 18:10:36 +0300
Message-Id: <1335971436-13903-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120501212512.GA4340@ericsson.com>
References: <20120501212512.GA4340@ericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Let's rework code to allow arbitrary number of cores on a CPU, not
limited by hardcoded array size.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/hwmon/coretemp.c |  176 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 127 insertions(+), 49 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 54a70fe..f5f9108 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -36,6 +36,8 @@
 #include <linux/cpu.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
+#include <linux/list.h>
+#include <linux/kref.h>
 #include <linux/moduleparam.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -52,11 +54,9 @@ module_param_named(tjmax, force_tjmax, int, 0444);
 MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		16	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
-#define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
 #define TO_PHYS_ID(cpu)		(cpu_data(cpu).phys_proc_id)
 #define TO_CORE_ID(cpu)		(cpu_data(cpu).cpu_core_id)
@@ -82,6 +82,9 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
  * @valid: If this is 1, the current temperature is valid.
  */
 struct temp_data {
+	struct list_head list;
+	struct kref refcount;
+	int id;
 	int temp;
 	int ttarget;
 	int tjmax;
@@ -101,7 +104,8 @@ struct temp_data {
 struct platform_data {
 	struct device *hwmon_dev;
 	u16 phys_proc_id;
-	struct temp_data *core_data[MAX_CORE_DATA];
+	struct list_head temp_data_list;
+	spinlock_t temp_data_lock;
 	struct device_attribute name_attr;
 };
 
@@ -114,6 +118,29 @@ struct pdev_entry {
 static LIST_HEAD(pdev_list);
 static DEFINE_MUTEX(pdev_list_mutex);
 
+static void temp_data_release(struct kref *ref)
+{
+	struct temp_data *tdata = container_of(ref, struct temp_data, refcount);
+
+	kfree(tdata);
+}
+
+static struct temp_data *get_temp_data(struct platform_data *pdata, int id)
+{
+	struct temp_data *tdata;
+
+	spin_lock(&pdata->temp_data_lock);
+	list_for_each_entry(tdata, &pdata->temp_data_list, list)
+		if (tdata->id == id) {
+			kref_get(&tdata->refcount);
+			goto out;
+		}
+	tdata = NULL;
+out:
+	spin_unlock(&pdata->temp_data_lock);
+	return tdata;
+}
+
 static ssize_t show_name(struct device *dev,
 			struct device_attribute *devattr, char *buf)
 {
@@ -125,12 +152,19 @@ static ssize_t show_label(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct temp_data *tdata = get_temp_data(pdata, attr->index);
+	ssize_t ret;
+
+	if (!tdata)
+		return -ENOENT;
 
 	if (tdata->is_pkg_data)
-		return sprintf(buf, "Physical id %u\n", pdata->phys_proc_id);
+		ret = sprintf(buf, "Physical id %u\n", pdata->phys_proc_id);
+	else
+		ret = sprintf(buf, "Core %u\n", tdata->cpu_core_id);
 
-	return sprintf(buf, "Core %u\n", tdata->cpu_core_id);
+	kref_put(&tdata->refcount, temp_data_release);
+	return ret;
 }
 
 static ssize_t show_crit_alarm(struct device *dev,
@@ -139,11 +173,18 @@ static ssize_t show_crit_alarm(struct device *dev,
 	u32 eax, edx;
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct temp_data *tdata = get_temp_data(pdata, attr->index);
+	ssize_t ret;
+
+	if (!tdata)
+		return -ENOENT;
 
 	rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 
-	return sprintf(buf, "%d\n", (eax >> 5) & 1);
+	ret = sprintf(buf, "%d\n", (eax >> 5) & 1);
+
+	kref_put(&tdata->refcount, temp_data_release);
+	return ret;
 }
 
 static ssize_t show_tjmax(struct device *dev,
@@ -151,8 +192,16 @@ static ssize_t show_tjmax(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct temp_data *tdata = get_temp_data(pdata, attr->index);
+	ssize_t ret;
+
+	if (!tdata)
+		return -ENOENT;
+
+	ret = sprintf(buf, "%d\n", tdata->tjmax);
 
-	return sprintf(buf, "%d\n", pdata->core_data[attr->index]->tjmax);
+	kref_put(&tdata->refcount, temp_data_release);
+	return ret;
 }
 
 static ssize_t show_ttarget(struct device *dev,
@@ -160,8 +209,16 @@ static ssize_t show_ttarget(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct temp_data *tdata = get_temp_data(pdata, attr->index);
+	ssize_t ret;
 
-	return sprintf(buf, "%d\n", pdata->core_data[attr->index]->ttarget);
+	if (!tdata)
+		return -ENOENT;
+
+	ret = sprintf(buf, "%d\n", tdata->ttarget);
+
+	kref_put(&tdata->refcount, temp_data_release);
+	return ret;
 }
 
 static ssize_t show_temp(struct device *dev,
@@ -170,7 +227,11 @@ static ssize_t show_temp(struct device *dev,
 	u32 eax, edx;
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct temp_data *tdata = get_temp_data(pdata, attr->index);
+	ssize_t ret = -EAGAIN;
+
+	if (!tdata)
+		return -ENOENT;
 
 	mutex_lock(&tdata->update_lock);
 
@@ -188,7 +249,12 @@ static ssize_t show_temp(struct device *dev,
 	}
 
 	mutex_unlock(&tdata->update_lock);
-	return tdata->valid ? sprintf(buf, "%d\n", tdata->temp) : -EAGAIN;
+
+	if (tdata->valid)
+		ret = sprintf(buf, "%d\n", tdata->temp);
+
+	kref_put(&tdata->refcount, temp_data_release);
+	return ret;
 }
 
 static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,
@@ -412,6 +478,7 @@ static struct temp_data __cpuinit *init_temp_data(unsigned int cpu,
 	tdata = kzalloc(sizeof(struct temp_data), GFP_KERNEL);
 	if (!tdata)
 		return NULL;
+	kref_init(&tdata->refcount);
 
 	tdata->status_reg = pkg_flag ? MSR_IA32_PACKAGE_THERM_STATUS :
 							MSR_IA32_THERM_STATUS;
@@ -423,7 +490,7 @@ static struct temp_data __cpuinit *init_temp_data(unsigned int cpu,
 	return tdata;
 }
 
-static int __cpuinit create_core_data(struct platform_device *pdev,
+static int __cpuinit create_temp_data(struct platform_device *pdev,
 				unsigned int cpu, int pkg_flag)
 {
 	struct temp_data *tdata;
@@ -440,9 +507,6 @@ static int __cpuinit create_core_data(struct platform_device *pdev,
 	 */
 	attr_no = pkg_flag ? 1 : TO_ATTR_NO(cpu);
 
-	if (attr_no > MAX_CORE_DATA - 1)
-		return -ERANGE;
-
 	/*
 	 * Provide a single set of attributes for all HT siblings of a core
 	 * to avoid duplicate sensors (the processor ID and core ID of all
@@ -450,8 +514,14 @@ static int __cpuinit create_core_data(struct platform_device *pdev,
 	 * Skip if a HT sibling of this core is already registered.
 	 * This is not an error.
 	 */
-	if (pdata->core_data[attr_no] != NULL)
-		return 0;
+	spin_lock(&pdata->temp_data_lock);
+	list_for_each_entry(tdata, &pdata->temp_data_list, list) {
+		if (tdata->id == attr_no) {
+			spin_unlock(&pdata->temp_data_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&pdata->temp_data_lock);
 
 	tdata = init_temp_data(cpu, pkg_flag);
 	if (!tdata)
@@ -480,16 +550,23 @@ static int __cpuinit create_core_data(struct platform_device *pdev,
 		}
 	}
 
-	pdata->core_data[attr_no] = tdata;
+	tdata->id = attr_no;
+
+	spin_lock(&pdata->temp_data_lock);
+	list_add(&tdata->list, &pdata->temp_data_list);
+	spin_unlock(&pdata->temp_data_lock);
 
 	/* Create sysfs interfaces */
 	err = create_core_attrs(tdata, &pdev->dev, attr_no);
 	if (err)
-		goto exit_free;
+		goto exit_list_del;
 
 	return 0;
+exit_list_del:
+	spin_lock(&pdata->temp_data_lock);
+	list_del(&tdata->list);
+	spin_unlock(&pdata->temp_data_lock);
 exit_free:
-	pdata->core_data[attr_no] = NULL;
 	kfree(tdata);
 	return err;
 }
@@ -502,23 +579,21 @@ static void __cpuinit coretemp_add_core(unsigned int cpu, int pkg_flag)
 	if (!pdev)
 		return;
 
-	err = create_core_data(pdev, cpu, pkg_flag);
+	err = create_temp_data(pdev, cpu, pkg_flag);
 	if (err)
 		dev_err(&pdev->dev, "Adding Core %u failed\n", cpu);
 }
 
-static void coretemp_remove_core(struct platform_data *pdata,
-				struct device *dev, int indx)
+static void coretemp_remove_core(struct temp_data *tdata, struct device *dev)
 {
 	int i;
-	struct temp_data *tdata = pdata->core_data[indx];
 
 	/* Remove the sysfs attributes */
 	for (i = 0; i < tdata->attr_size; i++)
 		device_remove_file(dev, &tdata->sd_attrs[i].dev_attr);
 
-	kfree(pdata->core_data[indx]);
-	pdata->core_data[indx] = NULL;
+	list_del(&tdata->list);
+	kref_put(&tdata->refcount, temp_data_release);
 }
 
 static int __devinit coretemp_probe(struct platform_device *pdev)
@@ -536,6 +611,8 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
 		goto exit_free;
 
 	pdata->phys_proc_id = pdev->id;
+	INIT_LIST_HEAD(&pdata->temp_data_list);
+	spin_lock_init(&pdata->temp_data_lock);
 	platform_set_drvdata(pdev, pdata);
 
 	pdata->hwmon_dev = hwmon_device_register(&pdev->dev);
@@ -557,11 +634,12 @@ exit_free:
 static int __devexit coretemp_remove(struct platform_device *pdev)
 {
 	struct platform_data *pdata = platform_get_drvdata(pdev);
-	int i;
+	struct temp_data *cur, *tmp;
 
-	for (i = MAX_CORE_DATA - 1; i >= 0; --i)
-		if (pdata->core_data[i])
-			coretemp_remove_core(pdata, &pdev->dev, i);
+	spin_lock(&pdata->temp_data_lock);
+	list_for_each_entry_safe(cur, tmp, &pdata->temp_data_list, list)
+		coretemp_remove_core(cur, &pdev->dev);
+	spin_unlock(&pdata->temp_data_lock);
 
 	device_remove_file(&pdev->dev, &pdata->name_attr);
 	hwmon_device_unregister(pdata->hwmon_dev);
@@ -641,16 +719,17 @@ static void __cpuinit coretemp_device_remove(unsigned int cpu)
 
 static bool __cpuinit is_any_core_online(struct platform_data *pdata)
 {
-	int i;
-
-	/* Find online cores, except pkgtemp data */
-	for (i = MAX_CORE_DATA - 1; i >= 0; --i) {
-		if (pdata->core_data[i] &&
-			!pdata->core_data[i]->is_pkg_data) {
-			return true;
-		}
-	}
-	return false;
+	struct temp_data *tdata;
+	bool ret = true;
+
+	spin_lock(&pdata->temp_data_lock);
+	list_for_each_entry(tdata, &pdata->temp_data_list, list)
+		if (!tdata->is_pkg_data)
+			 goto out;
+	ret = false;
+out:
+	spin_unlock(&pdata->temp_data_lock);
+	return ret;
 }
 
 static void __cpuinit get_core_online(unsigned int cpu)
@@ -697,9 +776,10 @@ static void __cpuinit get_core_online(unsigned int cpu)
 
 static void __cpuinit put_core_offline(unsigned int cpu)
 {
-	int i, indx;
+	int i, attr_no;
 	struct platform_data *pdata;
 	struct platform_device *pdev = coretemp_get_pdev(cpu);
+	struct temp_data *tdata;
 
 	/* If the physical CPU device does not exist, just return */
 	if (!pdev)
@@ -707,14 +787,12 @@ static void __cpuinit put_core_offline(unsigned int cpu)
 
 	pdata = platform_get_drvdata(pdev);
 
-	indx = TO_ATTR_NO(cpu);
-
-	/* The core id is too big, just return */
-	if (indx > MAX_CORE_DATA - 1)
-		return;
+	attr_no = TO_ATTR_NO(cpu);
 
-	if (pdata->core_data[indx] && pdata->core_data[indx]->cpu == cpu)
-		coretemp_remove_core(pdata, &pdev->dev, indx);
+	tdata = get_temp_data(pdata, attr_no);
+	if (tdata->cpu == cpu)
+		coretemp_remove_core(tdata, &pdev->dev);
+	kref_put(&tdata->refcount, temp_data_release);
 
 	/*
 	 * If a HT sibling of a core is taken offline, but another HT sibling
-- 
1.7.9.1

