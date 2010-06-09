Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0FIIpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:45:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57466 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab0FIIpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:45:42 -0400
From: naveen_jain@ti.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@ti.com, Naveen Jain <naveen_jain@ti.com>
Subject: [PATCH 2/2] drivers:staging: ti-st: add version info to sysfs
Date: Wed,  9 Jun 2010 03:45:33 -0500
Message-Id: <1276073133-17711-2-git-send-email-naveen_jain@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1276073133-17711-1-git-send-email-naveen_jain@ti.com>
References: <1276073133-17711-1-git-send-email-naveen_jain@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Jain <naveen_jain@ti.com>

Add version information to be available under the sysfs group
for kim.

Signed-off-by: Naveen Jain <naveen_jain@ti.com>
---
 drivers/staging/ti-st/st_kim.c |   40 +++++++++++++++++++++++++++++++++++-----
 drivers/staging/ti-st/st_kim.h |   11 +++++++++++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index cfba5f8..d015ad3 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -56,12 +56,13 @@ static struct platform_driver kim_platform_driver = {
 };
 
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
@@ -69,10 +70,14 @@ __ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
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
 
@@ -251,7 +256,8 @@ static long read_local_version(char *bts_scr_name)
 	}
 
 	version =
-	    MAKEWORD(kim_gdata->resp_buffer[13], kim_gdata->resp_buffer[14]);
+		MAKEWORD(kim_gdata->resp_buffer[13],
+				kim_gdata->resp_buffer[14]);
 	chip = (version & 0x7C00) >> 10;
 	min_ver = (version & 0x007F);
 	maj_ver = (version & 0x0380) >> 7;
@@ -260,6 +266,13 @@ static long read_local_version(char *bts_scr_name)
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
@@ -516,6 +529,16 @@ long st_kim_stop(void)
 
 /**********************************************************************/
 /* functions called from subsystems */
+/* called when sysfs entry is read from */
+
+static ssize_t show_version(struct device *dev, struct device_attribute
+		*attr, char *buf)
+{
+	sprintf(buf, "%04X %d.%d.%d", kim_gdata->version.full,
+			kim_gdata->version.chip, kim_gdata->version.maj_ver,
+			kim_gdata->version.min_ver);
+	return strlen(buf);
+}
 
 /* called when sysfs entry is written to */
 static ssize_t store_pid(struct device *dev, struct device_attribute
@@ -656,6 +679,12 @@ static int kim_probe(struct platform_device *pdev)
 		}
 		pr_info("rfkill entry created for %ld", gpios[proto]);
 	}
+
+	if (sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp)) {
+		pr_err(" sysfs entry creation failed");
+		return -1;
+	}
+	pr_info(" sysfs entries created ");
 	return ST_SUCCESS;
 }
 
@@ -676,6 +705,7 @@ static int kim_remove(struct platform_device *pdev)
 		kim_gdata->rfkill[proto] = NULL;
 	}
 	pr_info("kim: GPIO Freed");
+	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
 	return ST_SUCCESS;
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index 49c42ae..a5ea8d7 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -48,6 +48,16 @@
  * devices are created for the 3 gpios
  * that ST has requested
  */
+
+/* chip version storage
+ */
+struct chip_version {
+	unsigned short full;
+	unsigned short chip;
+	unsigned short min_ver;
+	unsigned short maj_ver;
+};
+
 /*
  * header file for ST provided by KIM
  */
@@ -66,6 +76,7 @@ struct kim_data_s {
 	struct rfkill *rfkill[ST_MAX];
 	enum proto_type rf_protos[ST_MAX];
 	struct st_data_s *core_data;
+	struct chip_version version;
 };
 
 long st_kim_start(void);
-- 
1.5.6.3

