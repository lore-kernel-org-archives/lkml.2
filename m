Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1BVWWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:49 -0500
Received: from kroah.org ([198.145.64.141]:33042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1BVWWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:44 2011
Message-Id: <20110222221844.036641156@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jirislaby@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Guillaume Chazarain <guichaz@gmail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [70/70] Revert: tpm_tis: Use timeouts returned from TPM
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

This is a revert of commit 9b29050f8f75916f974a2d231ae5d3cd59792296
upstream which has been found to prevent suspend from working on a
number of systems.

Thanks to Jiri Slaby <jirislaby@gmail.com> for tracing this down.

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Rafael Wysocki <rjw@sisk.pl>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c     |   18 ++----------------
 drivers/char/tpm/tpm.h     |    2 --
 drivers/char/tpm/tpm_tis.c |    4 +---
 3 files changed, 3 insertions(+), 21 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -577,11 +577,9 @@ duration:
 	if (rc)
 		return;
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
+	if (be32_to_cpu(tpm_cmd.header.out.return_code)
+	    != 3 * sizeof(u32))
 		return;
-
 	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
 	chip->vendor.duration[TPM_SHORT] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
@@ -925,18 +923,6 @@ ssize_t tpm_show_caps_1_2(struct device
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
-ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%d %d %d\n",
-	               jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
-	               jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
-	               jiffies_to_usecs(chip->vendor.duration[TPM_LONG]));
-}
-EXPORT_SYMBOL_GPL(tpm_show_timeouts);
-
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -56,8 +56,6 @@ extern ssize_t tpm_show_owned(struct dev
 				char *);
 extern ssize_t tpm_show_temp_deactivated(struct device *,
 					 struct device_attribute *attr, char *);
-extern ssize_t tpm_show_timeouts(struct device *,
-				 struct device_attribute *attr, char *);
 
 struct tpm_chip;
 
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -376,7 +376,6 @@ static DEVICE_ATTR(temp_deactivated, S_I
 		   NULL);
 static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
 
 static struct attribute *tis_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -386,8 +385,7 @@ static struct attribute *tis_attrs[] = {
 	&dev_attr_owned.attr,
 	&dev_attr_temp_deactivated.attr,
 	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_timeouts.attr, NULL,
+	&dev_attr_cancel.attr, NULL,
 };
 
 static struct attribute_group tis_attr_grp = {


