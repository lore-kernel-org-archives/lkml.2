Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1BPAYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:52 -0500
Received: from kroah.org ([198.145.64.141]:49687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab1BPAY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.725341479@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [226/272] tpm_tis: Use timeouts returned from TPM
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Berger <stefanb@linux.vnet.ibm.com>

commit 9b29050f8f75916f974a2d231ae5d3cd59792296 upstream.

The current TPM TIS driver in git discards the timeout values returned
from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected
packet is equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 3 timeout indicators of type u32.

I am also adding a sysfs entry 'timeouts' showing the timeouts that are
being used.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Tested-by: Guillaume Chazarain <guichaz@gmail.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c     |   18 ++++++++++++++++--
 drivers/char/tpm/tpm.h     |    2 ++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 3 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -577,9 +577,11 @@ duration:
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
@@ -923,6 +925,18 @@ ssize_t tpm_show_caps_1_2(struct device
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
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -56,6 +56,8 @@ extern ssize_t tpm_show_owned(struct dev
 				char *);
 extern ssize_t tpm_show_temp_deactivated(struct device *,
 					 struct device_attribute *attr, char *);
+extern ssize_t tpm_show_timeouts(struct device *,
+				 struct device_attribute *attr, char *);
 
 struct tpm_chip;
 
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
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


