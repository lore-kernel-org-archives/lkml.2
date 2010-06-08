Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0FHOyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:54:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab0FHOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:54:54 -0400
From: naveen_jain@ti.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@ti.com, Naveen Jain <naveen_jain@ti.com>
Subject: [PATCH] drivers:staging: ti-st: add version info to sysfs
Date: Tue,  8 Jun 2010 09:54:45 -0500
Message-Id: <1276008885-30282-1-git-send-email-naveen_jain@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Jain <naveen_jain@ti.com>

Cleanup sysfs code, so that all the required sysfs entries
are created under /sys/bus/platform/drivers/kim now.
Add version information to be available under the sysfs group
for kim.

TODO: Cleanup un-compiled code related to creation of kobject

Signed-off-by: Naveen Jain <naveen_jain@ti.com>
---
 drivers/staging/ti-st/st_kim.c |   51 ++++++++++++++++++++++++++++-----------
 drivers/staging/ti-st/st_kim.h |   12 +++++++++
 2 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 98cbabb..ca986d6 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -55,14 +55,14 @@ static struct platform_driver kim_platform_driver = {
 		   },
 };
 
-#ifndef LEGACY_RFKILL_SUPPORT
 static ssize_t show_pid(struct device *dev, struct device_attribute
-			*attr, char *buf);
+		*attr, char *buf);
 static ssize_t store_pid(struct device *dev, struct device_attribute
-			 *devattr, char *buf, size_t count);
+		*devattr, char *buf, size_t count);
 static ssize_t show_list(struct device *dev, struct device_attribute
-			 *attr, char *buf);
-
+		*attr, char *buf);
+static ssize_t show_version(struct device *dev, struct device_attribute
+		*attr, char *buf);
 /* structures specific for sysfs entries */
 static struct kobj_attribute pid_attr =
 __ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
@@ -70,22 +70,25 @@ __ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
 static struct kobj_attribute list_protocols =
 __ATTR(protocols, 0444, (void *)show_list, NULL);
 
+static struct kobj_attribute chip_version =
+__ATTR(version, 0444, (void *)show_version, NULL);
+
 static struct attribute *uim_attrs[] = {
 	&pid_attr.attr,
 	/* add more debug sysfs entries */
 	&list_protocols.attr,
+	&chip_version.attr,
 	NULL,
 };
 
 static struct attribute_group uim_attr_grp = {
 	.attrs = uim_attrs,
 };
-#else
+
 static int kim_toggle_radio(void*, bool);
 static const struct rfkill_ops kim_rfkill_ops = {
 	.set_block = kim_toggle_radio,
 };
-#endif	/* LEGACY_RFKILL_SUPPORT */
 
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
@@ -253,7 +256,8 @@ static long read_local_version(char *bts_scr_name)
 	}
 
 	version =
-	    MAKEWORD(kim_gdata->resp_buffer[13], kim_gdata->resp_buffer[14]);
+		MAKEWORD(kim_gdata->resp_buffer[13],
+			kim_gdata->resp_buffer[14]);
 	chip = (version & 0x7C00) >> 10;
 	min_ver = (version & 0x007F);
 	maj_ver = (version & 0x0380) >> 7;
@@ -262,6 +266,13 @@ static long read_local_version(char *bts_scr_name)
 		maj_ver |= 0x0008;
 
 	sprintf(bts_scr_name, "TIInit_%d.%d.%d.bts", chip, maj_ver, min_ver);
+
+	/* to be accessed later via sysfs entry */
+	kim_gdata->version.full = version;
+	kim_gdata->version.chip = chip;
+	kim_gdata->version.maj_ver = maj_ver;
+	kim_gdata->version.min_ver = min_ver;
+
 	pr_info("%s", bts_scr_name);
 	return ST_SUCCESS;
 }
@@ -522,8 +533,16 @@ long st_kim_stop(void)
 
 /**********************************************************************/
 /* functions called from subsystems */
+/* called when sysfs entry is read from */
+static ssize_t show_version(struct device *dev, struct device_attribute
+		*attr, char *buf)
+{
+	sprintf(buf, "%04X %d.%d.%d", kim_gdata->version.full,
+			kim_gdata->version.chip, kim_gdata->version.maj_ver,
+			kim_gdata->version.min_ver);
+	return strlen(buf);
+}
 
-#ifndef LEGACY_RFKILL_SUPPORT
 /* called when sysfs entry is written to */
 static ssize_t store_pid(struct device *dev, struct device_attribute
 			 *devattr, char *buf, size_t count)
@@ -551,8 +570,6 @@ static ssize_t show_list(struct device *dev, struct device_attribute
 	return strlen(buf);
 }
 
-#else /* LEGACY_RFKILL_SUPPORT */
-
 /* function called from rfkill subsystem, when someone from
  * user space would write 0/1 on the sysfs entry
  * /sys/class/rfkill/rfkill0,1,3/state
@@ -580,8 +597,6 @@ static int kim_toggle_radio(void *data, bool blocked)
 	return ST_SUCCESS;
 }
 
-#endif	/* LEGACY_RFKILL_SUPPORT */
-
 void st_kim_ref(struct st_data_s **core_data)
 {
 	*core_data = kim_gdata->core_data;
@@ -656,14 +671,20 @@ static int kim_probe(struct platform_device *pdev)
 		return -1;	/* fail insmod */
 	}
 	pr_info(" sysfs entry created ");
-#endif
+#else
 	/* get reference of pdev for request_firmware
 	 */
 	kim_gdata->kim_pdev = pdev;
 	init_completion(&kim_gdata->kim_rcvd);
 	init_completion(&kim_gdata->ldisc_installed);
+	if (sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp)) {
+		pr_err(" sysfs entry creation failed");
+		return -1;
+	}
+	pr_info(" sysfs entry created ");
+#endif
 #ifdef LEGACY_RFKILL_SUPPORT
-	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
+	for (proto = ST_BT; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
 		/* TODO: should all types be rfkill_type_bt ? */
 		kim_gdata->rf_protos[proto] = proto;
 		kim_gdata->rfkill[proto] = rfkill_alloc(protocol_names[proto],
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index ff3270e..f18affe 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -35,6 +35,15 @@
 #define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
 	| ((unsigned short)((unsigned char)(b))) << 8))
 
+/* chip version storage
+ */
+struct chip_version {
+	unsigned short full;
+	unsigned short chip;
+	unsigned short min_ver;
+	unsigned short maj_ver;
+};
+
 #define GPIO_HIGH 1
 #define GPIO_LOW  0
 
@@ -60,7 +69,9 @@ struct kim_data_s {
 	char resp_buffer[30];
 	const struct firmware *fw_entry;
 	long gpios[ST_MAX];
+#ifndef LEGACY_RFKILL_SUPPORT
 	struct kobject *kim_kobj;
+#endif
 /* used by kim_int_recv to validate fw response */
 	unsigned long rx_state;
 	unsigned long rx_count;
@@ -70,6 +81,7 @@ struct kim_data_s {
 	enum proto_type rf_protos[ST_MAX];
 #endif
 	struct st_data_s *core_data;
+	struct chip_version version;
 };
 
 long st_kim_start(void);
-- 
1.5.6.3

