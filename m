Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1C3QOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50740 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab1C3QOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:33 -0400
Message-Id: <20110330161416.096830022@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:25 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 03/12] tpm_tis: Introduce durations sysfs entry
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_driver_sysfs_durations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display the TPM's command timeouts in a 'durations' sysfs entry. Display
the entries as having been adjusted when they were scaled due to their values
being reported in milliseconds rather than microseconds.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Tested-by: Guillaume Chazarain <guichaz@gmail.com>

---
 drivers/char/tpm/tpm.c     |   15 +++++++++++++++
 drivers/char/tpm/tpm.h     |    3 +++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 3 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -597,6 +597,7 @@ duration:
 		chip->vendor.duration[TPM_SHORT] = HZ;
 		chip->vendor.duration[TPM_MEDIUM] *= 1000;
 		chip->vendor.duration[TPM_LONG] *= 1000;
+		chip->vendor.duration_adjusted = true;
 		dev_info(chip->dev, "Adjusting TPM timeout parameters.");
 	}
 }
@@ -944,6 +945,20 @@ ssize_t tpm_show_caps_1_2(struct device 
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
+ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d %d %d [%s]\n",
+		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
+		       chip->vendor.duration_adjusted
+		       ? "adjusted" : "original");
+}
+EXPORT_SYMBOL_GPL(tpm_show_durations);
+
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -56,6 +56,8 @@ extern ssize_t tpm_show_owned(struct dev
 				char *);
 extern ssize_t tpm_show_temp_deactivated(struct device *,
 					 struct device_attribute *attr, char *);
+extern ssize_t tpm_show_durations(struct device *,
+				  struct device_attribute *attr, char *);
 
 struct tpm_chip;
 
@@ -82,6 +84,7 @@ struct tpm_vendor_specific {
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
 	unsigned long duration[3]; /* jiffies */
+	bool duration_adjusted;
 
 	wait_queue_head_t read_queue;
 	wait_queue_head_t int_queue;
Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -376,6 +376,7 @@ static DEVICE_ATTR(temp_deactivated, S_I
 		   NULL);
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
 
 static struct attribute *tis_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -385,7 +386,8 @@ static struct attribute *tis_attrs[] = {
 	&dev_attr_owned.attr,
 	&dev_attr_temp_deactivated.attr,
 	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr, NULL,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr, NULL,
 };
 
 static struct attribute_group tis_attr_grp = {

