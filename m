Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab1C3QRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:17:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45491 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab1C3QOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:20 -0400
Message-Id: <20110330161417.326156811@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:28 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 06/12] tpm_tis: Add timeouts sysfs entry
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_driver_sysfs_timeouts.patch
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display the TPM's interface timeouts in a 'timeouts' sysfs entry. Display
the entries as having been adjusted when they were scaled due to their values
being reported in milliseconds rather than microseconds.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c     |   16 ++++++++++++++++
 drivers/char/tpm/tpm.h     |    3 +++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 3 files changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -58,6 +58,8 @@ extern ssize_t tpm_show_temp_deactivated
 					 struct device_attribute *attr, char *);
 extern ssize_t tpm_show_durations(struct device *,
 				  struct device_attribute *attr, char *);
+extern ssize_t tpm_show_timeouts(struct device *,
+				 struct device_attribute *attr, char *);
 
 struct tpm_chip;
 
@@ -83,6 +85,7 @@ struct tpm_vendor_specific {
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
+	bool timeout_adjusted;
 	unsigned long duration[3]; /* jiffies */
 	bool duration_adjusted;
 
Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -377,6 +377,7 @@ static DEVICE_ATTR(temp_deactivated, S_I
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
 
 static struct attribute *tis_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -387,7 +388,8 @@ static struct attribute *tis_attrs[] = {
 	&dev_attr_temp_deactivated.attr,
 	&dev_attr_caps.attr,
 	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr, NULL,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr, NULL,
 };
 
 static struct attribute_group tis_attr_grp = {
Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -557,6 +557,7 @@ void tpm_get_timeouts(struct tpm_chip *c
 	if (timeout && timeout < 1000) {
 		/* timeouts in msec rather usec */
 		scale = 1000;
+		chip->vendor.timeout_adjusted = true;
 	}
 	if (timeout)
 		chip->vendor.timeout_a = usecs_to_jiffies(timeout * scale);
@@ -965,6 +966,21 @@ ssize_t tpm_show_durations(struct device
 }
 EXPORT_SYMBOL_GPL(tpm_show_durations);
 
+ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d %d %d %d [%s]\n",
+		       jiffies_to_usecs(chip->vendor.timeout_a),
+		       jiffies_to_usecs(chip->vendor.timeout_b),
+		       jiffies_to_usecs(chip->vendor.timeout_c),
+		       jiffies_to_usecs(chip->vendor.timeout_d),
+		       chip->vendor.timeout_adjusted
+		       ? "adjusted" : "original");
+}
+EXPORT_SYMBOL_GPL(tpm_show_timeouts);
+
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {

