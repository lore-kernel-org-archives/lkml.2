Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2ATR7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:59:47 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57095 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2ATR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:59:46 -0500
Message-Id: <20120120175930.702036458@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 Jan 2012 12:58:49 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: stefanb@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com
Subject: [PATCH 1/2] Only probe iTPMs
References: <20120120175848.310554335@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_intel_only.diff
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012017-7408-0000-0000-0000020B5787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect iTPMs through the vendor ID on the hardware interface and only
probe the device if the manufacturer is found to be Intel. This
obsoletes a previously added delay necessary for some TPMs but not iTPMs. 

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.h     |    2 ++
 drivers/char/tpm/tpm_tis.c |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -99,6 +99,8 @@ struct tpm_vendor_specific {
 	wait_queue_head_t int_queue;
 };
 
+#define TPM_VID_INTEL    0x8086
+
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -368,6 +368,11 @@ static int probe_itpm(struct tpm_chip *c
 	};
 	size_t len = sizeof(cmd_getticks);
 	int rem_itpm = itpm;
+	u16 vendor = ioread16(chip->vendor.iobase + TPM_DID_VID(0));
+
+	/* probe only iTPMS */
+	if (vendor != TPM_VID_INTEL)
+		return 0;
 
 	itpm = 0;
 
@@ -390,9 +395,6 @@ static int probe_itpm(struct tpm_chip *c
 out:
 	itpm = rem_itpm;
 	tpm_tis_ready(chip);
-	/* some TPMs need a break here otherwise they will not work
-	 * correctly on the immediately subsequent command */
-	msleep(chip->vendor.timeout_b);
 	release_locality(chip, chip->vendor.locality, 0);
 
 	return rc;

