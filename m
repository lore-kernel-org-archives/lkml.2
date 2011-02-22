Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1BVTlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:41:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48962 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab1BVTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:41:45 -0500
Subject: [PATCH v2] tpm_tis: Use timeouts returned from TPM
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: preining@logic.at, Jiri Slaby <jirislaby@gmail.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 14:41:40 -0500
Message-ID: <1298403700.25819.7.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch applies to the tip of the git tree.

v2:
  - adjusting all timeouts for TPM devices reporting too low timeout
numbers
  - also displaying in sysfs whether the timeouts are 'original' or
'adjusted'

The current TPM TIS driver in git discards the timeout values returned
from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected
packet is equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 3 timeout indicators of type u32.

Since some TPMs seem to return timeouts in msec rather than usec,
I am now adjusting all the timeouts rather than just the one for short
durations.

I am also adding a sysfs entry 'timeouts' showing the timeouts that are
being used.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c     |   35 ++++++++++++++++++++++++++---------
 drivers/char/tpm/tpm.h     |    2 ++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 3 files changed, 31 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -577,23 +577,30 @@ duration:
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
-	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
-	 * value wrong and apparently reports msecs rather than usecs. So we
-	 * fix up the resulting too-small TPM_SHORT value to make things work.
-	 */
-	if (chip->vendor.duration[TPM_SHORT] < (HZ/100))
-		chip->vendor.duration[TPM_SHORT] = HZ;
-
 	chip->vendor.duration[TPM_MEDIUM] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
 	chip->vendor.duration[TPM_LONG] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
+
+	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
+	 * value wrong and apparently reports msecs rather than usecs. So we
+	 * fix up the resulting too-small TPM_SHORT value to make things work.
+	 */
+	if (chip->vendor.duration[TPM_SHORT] < (HZ/100)) {
+		chip->vendor.duration[TPM_SHORT]   = HZ;
+		chip->vendor.duration[TPM_MEDIUM] *= 1000;
+		chip->vendor.duration[TPM_LONG]   *= 1000;
+		chip->vendor.duration_adjusted = true;
+		dev_info(chip->dev, "Adjusting TPM timeout parameters.");
+	}
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 
@@ -939,6 +946,21 @@ ssize_t tpm_show_caps_1_2(struct device 
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
+ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d %d %d [%s]\n",
+		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
+		       chip->vendor.duration_adjusted
+			 ? "adjusted"
+			 : "original");
+}
+EXPORT_SYMBOL_GPL(tpm_show_timeouts);
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
+extern ssize_t tpm_show_timeouts(struct device *,
+				 struct device_attribute *attr, char *);
 
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

