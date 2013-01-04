Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3ADV66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:58:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60461 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3ADV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:58:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 4/6] ACPI / PM: Export power states of ACPI devices via sysfs
Date: Fri, 04 Jan 2013 23:03:01 +0100
Message-ID: <6722291.GNv0dQuq4j@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2311196.icSMDvAsYg@vostro.rjw.lan>
References: <2311196.icSMDvAsYg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make it possible to retrieve the current power state of an ACPI
device from user space via sysfs by adding a new attribute
power_state to the power subdirectory of the sysfs directory
associated with the struct acpi_device representing the device's
ACPI node.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-power |   13 ++++++++
 drivers/acpi/scan.c                           |   41 ++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -184,6 +184,43 @@ err_out:
 }
 EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
+#ifdef CONFIG_PM
+static ssize_t power_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+	int state;
+	int ret;
+
+	ret = acpi_device_get_power(adev, &state);
+	return ret ? ret : sprintf(buf, "%s\n", acpi_power_state_string(state));
+}
+
+static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
+
+static struct attribute *acpi_dev_pm_attrs[] = {
+	&dev_attr_power_state.attr,
+	NULL,
+};
+static struct attribute_group acpi_dev_pm_attr_group = {
+	.name	= power_group_name,
+	.attrs	= acpi_dev_pm_attrs,
+};
+
+static void acpi_dev_pm_sysfs_add(struct device *dev)
+{
+	sysfs_merge_group(&dev->kobj, &acpi_dev_pm_attr_group);
+}
+
+static void acpi_dev_pm_sysfs_remove(struct device *dev)
+{
+	sysfs_unmerge_group(&dev->kobj, &acpi_dev_pm_attr_group);
+}
+#else /* !CONFIG_PM */
+static inline void acpi_dev_pm_sysfs_add(struct device *dev) {}
+static inline void acpi_dev_pm_sysfs_remove(struct device *dev) {}
+#endif /* !CONFIG_PM */
+
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
@@ -377,6 +414,9 @@ static int acpi_device_setup_files(struc
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
 	if (ACPI_SUCCESS(status))
 		result = device_create_file(&dev->dev, &dev_attr_eject);
+
+	acpi_dev_pm_sysfs_add(&dev->dev);
+
 end:
 	return result;
 }
@@ -386,6 +426,7 @@ static void acpi_device_remove_files(str
 	acpi_status status;
 	acpi_handle temp;
 
+	acpi_dev_pm_sysfs_remove(&dev->dev);
 	/*
 	 * If device has _STR, remove 'description' file
 	 */
Index: linux/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux/Documentation/ABI/testing/sysfs-devices-power
@@ -235,3 +235,16 @@ Description:
 
 		This attribute has no effect on system-wide suspend/resume and
 		hibernation.
+
+What:		/sys/devices/.../power/power_state
+Date:		December 2012
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power/power_state attribute is only present
+		for ACPI device nodes (i.e. objects of type struct acpi_device).
+
+		If present, it contains the string representation of the current
+		ACPI power state of the device represented by the given ACPI
+		device node.
+
+		This attribute is read-only.

