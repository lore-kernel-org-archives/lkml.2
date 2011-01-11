Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1AKThv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:37:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55686 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1AKThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:37:48 -0500
Subject: [PATCH] tpm_tis: Use timeouts returned from TPM
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Cc: tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 14:37:29 -0500
Message-ID: <1294774649.1337.7.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current TPM TIS driver in git discards the timeout values returned
from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected
packet is equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 3 timeout indicators of type u32.

I am also adding a sysfs entry 'timeouts' showing the timeouts that are
being used.


Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 1f46f1c..ef9ca1e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -575,9 +575,11 @@ duration:
 	if (rc)
 		return;
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code)
-	    != 3 * sizeof(u32))
+	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
+	    be32_to_cpu(tpm_cmd.header.out.length)
+	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
 		return;
+
 	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
 	chip->vendor.duration[TPM_SHORT] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
@@ -937,6 +939,18 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
+ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d %d %d\n",
+	               jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+	               jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+	               jiffies_to_usecs(chip->vendor.duration[TPM_LONG]));
+}
+EXPORT_SYMBOL_GPL(tpm_show_timeouts);
+
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 72ddb03..d84ff77 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -56,6 +56,8 @@ extern ssize_t tpm_show_owned(struct device *, struct device_attribute *attr,
 				char *);
 extern ssize_t tpm_show_temp_deactivated(struct device *,
 					 struct device_attribute *attr, char *);
+extern ssize_t tpm_show_timeouts(struct device *,
+				 struct device_attribute *attr, char *);
 
 struct tpm_chip;
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c17a305..3e1f2bb 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -376,6 +376,7 @@ static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
 		   NULL);
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
 
 static struct attribute *tis_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -385,7 +386,8 @@ static struct attribute *tis_attrs[] = {
 	&dev_attr_owned.attr,
 	&dev_attr_temp_deactivated.attr,
 	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr, NULL,
+	&dev_attr_cancel.attr,
+	&dev_attr_timeouts.attr, NULL,
 };
 
 static struct attribute_group tis_attr_grp = {

