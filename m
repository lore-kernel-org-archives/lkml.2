Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0G1H0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:26:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0G1H0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:26:18 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/2] drivers:staging:ti-st: mv sysfs entries to debugfs
Date: Wed, 28 Jul 2010 02:25:59 -0500
Message-Id: <1280301960-16474-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

When the chip is in use, information like the chip's ROM version and the
protocols currently making use of the chip needs to be made known to
user-space.
Earlier the version and the protocol-list were exposed as sysfs entries
now cleanup by making them as debugfs entries, also in process remove
any unwanted/previously unused sysfs entries.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_core.c |   27 +---------
 drivers/staging/ti-st/st_kim.c  |  114 ++++++++++++++++----------------------
 drivers/staging/ti-st/st_kim.h  |    2 +-
 3 files changed, 51 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index fc6de63..063c9b1 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -39,7 +39,6 @@
 #include "st.h"
 
 #define VERBOSE
-#ifdef DEBUG
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
  */
@@ -49,7 +48,6 @@ const unsigned char *protocol_strngs[] = {
 	PROTO_ENTRY(ST_FM, "FM"),
 	PROTO_ENTRY(ST_GPS, "GPS"),
 };
-#endif
 /* function pointer pointing to either,
  * st_kim_recv during registration to receive fw download responses
  * st_int_recv after registration to receive proto stack responses
@@ -563,34 +561,13 @@ void st_tx_wakeup(struct st_data_s *st_data)
 /********************************************************************/
 /* functions called from ST KIM
 */
-void kim_st_list_protocols(struct st_data_s *st_gdata, char *buf)
+void kim_st_list_protocols(struct st_data_s *st_gdata, void *buf)
 {
-	unsigned long flags = 0;
-#ifdef DEBUG
-	unsigned char i = ST_MAX;
-#endif
-	spin_lock_irqsave(&st_gdata->lock, flags);
-#ifdef DEBUG			/* more detailed log */
-	for (i = 0; i < ST_MAX; i++) {
-		if (i == 0) {
-			sprintf(buf, "%s is %s", protocol_strngs[i],
-				st_gdata->list[i] !=
-				NULL ? "Registered" : "Unregistered");
-		} else {
-			sprintf(buf, "%s\n%s is %s", buf, protocol_strngs[i],
-				st_gdata->list[i] !=
-				NULL ? "Registered" : "Unregistered");
-		}
-	}
-	sprintf(buf, "%s\n", buf);
-#else /* limited info */
-	sprintf(buf, "[%d]\nBT=%c\nFM=%c\nGPS=%c\n",
+	seq_printf(buf, "[%d]\nBT=%c\nFM=%c\nGPS=%c\n",
 			st_gdata->protos_registered,
 			st_gdata->list[ST_BT] != NULL ? 'R' : 'U',
 			st_gdata->list[ST_FM] != NULL ? 'R' : 'U',
 			st_gdata->list[ST_GPS] != NULL ? 'R' : 'U');
-#endif
-	spin_unlock_irqrestore(&st_gdata->lock, flags);
 }
 
 /********************************************************************/
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 7e34e4d..b4a6c7f 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -26,6 +26,8 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/gpio.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <linux/sched.h>
 
@@ -55,36 +57,6 @@ static struct platform_driver kim_platform_driver = {
 		   },
 };
 
-static ssize_t show_pid(struct device *dev, struct device_attribute
-		*attr, char *buf);
-static ssize_t store_pid(struct device *dev, struct device_attribute
-		*devattr, char *buf, size_t count);
-static ssize_t show_list(struct device *dev, struct device_attribute
-		*attr, char *buf);
-static ssize_t show_version(struct device *dev, struct device_attribute
-		*attr, char *buf);
-/* structures specific for sysfs entries */
-static struct kobj_attribute pid_attr =
-__ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
-
-static struct kobj_attribute list_protocols =
-__ATTR(protocols, 0444, (void *)show_list, NULL);
-
-static struct kobj_attribute chip_version =
-__ATTR(version, 0444, (void *)show_version, NULL);
-
-static struct attribute *uim_attrs[] = {
-	&pid_attr.attr,
-	/* add more debug sysfs entries */
-	&list_protocols.attr,
-	&chip_version.attr,
-	NULL,
-};
-
-static struct attribute_group uim_attr_grp = {
-	.attrs = uim_attrs,
-};
-
 static int kim_toggle_radio(void*, bool);
 static const struct rfkill_ops kim_rfkill_ops = {
 	.set_block = kim_toggle_radio,
@@ -550,45 +522,22 @@ long st_kim_stop(void *kim_data)
 
 /**********************************************************************/
 /* functions called from subsystems */
-/* called when sysfs entry is read from */
+/* called when debugfs entry is read from */
 
-static ssize_t show_version(struct device *dev, struct device_attribute
-		*attr, char *buf)
+static int show_version(struct seq_file *s, void *unused)
 {
-	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
-	sprintf(buf, "%04X %d.%d.%d", kim_gdata->version.full,
+	struct kim_data_s *kim_gdata = (struct kim_data_s *)s->private;
+	seq_printf(s, "%04X %d.%d.%d\n", kim_gdata->version.full,
 			kim_gdata->version.chip, kim_gdata->version.maj_ver,
 			kim_gdata->version.min_ver);
-	return strlen(buf);
-}
-
-/* called when sysfs entry is written to */
-static ssize_t store_pid(struct device *dev, struct device_attribute
-			 *devattr, char *buf, size_t count)
-{
-	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
-	sscanf(buf, "%ld", &kim_gdata->uim_pid);
-	/* to be made use by kim_start to signal SIGUSR2
-	 */
-	return strlen(buf);
-}
-
-/* called when sysfs entry is read from */
-static ssize_t show_pid(struct device *dev, struct device_attribute
-			*attr, char *buf)
-{
-	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
-	sprintf(buf, "%ld", kim_gdata->uim_pid);
-	return strlen(buf);
+	return 0;
 }
 
-/* called when sysfs entry is read from */
-static ssize_t show_list(struct device *dev, struct device_attribute
-			 *attr, char *buf)
+static int show_list(struct seq_file *s, void *unused)
 {
-	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
-	kim_st_list_protocols(kim_gdata->core_data, buf);
-	return strlen(buf);
+	struct kim_data_s *kim_gdata = (struct kim_data_s *)s->private;
+	kim_st_list_protocols(kim_gdata->core_data, s);
+	return 0;
 }
 
 /* function called from rfkill subsystem, when someone from
@@ -635,12 +584,38 @@ void st_kim_ref(struct st_data_s **core_data)
 	*core_data = kim_gdata->core_data;
 }
 
+static int kim_version_open(struct inode *i, struct file *f)
+{
+	return single_open(f, show_version, i->i_private);
+}
+
+static int kim_list_open(struct inode *i, struct file *f)
+{
+	return single_open(f, show_list, i->i_private);
+}
+
+static const struct file_operations version_debugfs_fops = {
+	/* version info */
+	.open = kim_version_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+static const struct file_operations list_debugfs_fops = {
+	/* protocols info */
+	.open = kim_list_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 /**********************************************************************/
 /* functions called from platform device driver subsystem
  * need to have a relevant platform device entry in the platform's
  * board-*.c file
  */
 
+struct dentry *kim_debugfs_dir;
 static int kim_probe(struct platform_device *pdev)
 {
 	long status;
@@ -726,11 +701,18 @@ static int kim_probe(struct platform_device *pdev)
 		pr_info("rfkill entry created for %ld", gpios[proto]);
 	}
 
-	if (sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp)) {
-		pr_err(" sysfs entry creation failed");
+	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
+	if (IS_ERR(kim_debugfs_dir)) {
+		pr_err(" debugfs entries creation failed ");
+		kim_debugfs_dir = NULL;
 		return -1;
 	}
-	pr_info(" sysfs entries created ");
+
+	debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
+				kim_gdata, &version_debugfs_fops);
+	debugfs_create_file("protocols", S_IRUGO, kim_debugfs_dir,
+				kim_gdata, &list_debugfs_fops);
+	pr_info(" debugfs entries created ");
 	return 0;
 }
 
@@ -754,7 +736,7 @@ static int kim_remove(struct platform_device *pdev)
 		kim_gdata->rfkill[proto] = NULL;
 	}
 	pr_info("kim: GPIO Freed");
-	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
+	debugfs_remove_recursive(kim_debugfs_dir);
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
 
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index 225cacd..7de2541 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -108,7 +108,7 @@ long st_kim_stop(void *);
 void st_kim_recv(void *, const unsigned char *, long count);
 void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
 void st_kim_complete(void *);
-void kim_st_list_protocols(struct st_data_s *, char *);
+void kim_st_list_protocols(struct st_data_s *, void *);
 
 /*
  * BTS headers
-- 
1.5.6.3

