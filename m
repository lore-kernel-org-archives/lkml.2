Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1COLOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:14:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37954 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1COLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:34 -0400
Message-Id: <20110315111427.497272632@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:13 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 6/8] tpm + tpm_tis: Use interface timeouts returned from TPM
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_iftimeouts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the check for whether the 4 interface  timeouts (a,b,c,d)
reported by the TPM have been properly returned.

The current TPM TIS driver in git discards the interface timeout values
returned from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected packet is
equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 4 timeout indicators of type u32.

I anticipate that some TPMs will also report these timeouts in msec rather than
usec and therefore scale them by a factor of 1000 if the timeout_a value is
found to be below 1000 (usecs).

I am also add a sysfs entry 'timeouts' that shows the 4 timeouts and reports
them either as being either 'original' or 'adjusted' if they were scaled.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c     |   36 +++++++++++++++++++++++++++++-------
 drivers/char/tpm/tpm.h     |    3 +++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 3 files changed, 35 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -534,6 +534,7 @@ void tpm_get_timeouts(struct tpm_chip *c
 	struct duration_t *duration_cap;
 	ssize_t rc;
 	u32 timeout;
+	unsigned int scale = 1;
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
@@ -545,24 +546,30 @@ void tpm_get_timeouts(struct tpm_chip *c
 	if (rc)
 		goto duration;
 
-	if (be32_to_cpu(tpm_cmd.header.out.length)
-	    != 4 * sizeof(u32))
-		goto duration;
+	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
+	    be32_to_cpu(tpm_cmd.header.out.length)
+	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
+		return;
 
 	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
 	/* Don't overwrite default if value is 0 */
 	timeout = be32_to_cpu(timeout_cap->a);
+	if (timeout && timeout < 1000) {
+		/* timeouts in msec rather usec */
+		scale = 1000;
+		chip->vendor.timeout_adjusted = true;
+	}
 	if (timeout)
-		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
+		chip->vendor.timeout_a = usecs_to_jiffies(timeout * scale);
 	timeout = be32_to_cpu(timeout_cap->b);
 	if (timeout)
-		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
+		chip->vendor.timeout_b = usecs_to_jiffies(timeout * scale);
 	timeout = be32_to_cpu(timeout_cap->c);
 	if (timeout)
-		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
+		chip->vendor.timeout_c = usecs_to_jiffies(timeout * scale);
 	timeout = be32_to_cpu(timeout_cap->d);
 	if (timeout)
-		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
+		chip->vendor.timeout_d = usecs_to_jiffies(timeout * scale);
 
 duration:
 	tpm_cmd.header.in = tpm_getcap_header;
@@ -965,6 +972,21 @@ ssize_t tpm_show_durations(struct device
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
 
@@ -84,6 +86,7 @@ struct tpm_vendor_specific {
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
@@ -395,6 +395,7 @@ static DEVICE_ATTR(temp_deactivated, S_I
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
 
 static struct attribute *tis_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -405,7 +406,8 @@ static struct attribute *tis_attrs[] = {
 	&dev_attr_temp_deactivated.attr,
 	&dev_attr_caps.attr,
 	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr, NULL,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr, NULL,
 };
 
 static struct attribute_group tis_attr_grp = {

