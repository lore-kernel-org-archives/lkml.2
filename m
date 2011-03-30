Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1C3QOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56784 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1C3QOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:18 -0400
Message-Id: <20110330161415.716187023@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:24 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 02/12] tpm: Adjust the durations if they are too small
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_durations_infineon.patch
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the durations if they are found to be too small, i.e., if they are
returned in milliseconds rather than microseconds as some Infineon TPMs are
reported to do.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -583,17 +583,22 @@ duration:
 	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
 	chip->vendor.duration[TPM_SHORT] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
+	chip->vendor.duration[TPM_MEDIUM] =
+	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
+	chip->vendor.duration[TPM_LONG] =
+	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
+
 	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
 	 * value wrong and apparently reports msecs rather than usecs. So we
 	 * fix up the resulting too-small TPM_SHORT value to make things work.
+	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
 	 */
-	if (chip->vendor.duration[TPM_SHORT] < (HZ/100))
+	if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
 		chip->vendor.duration[TPM_SHORT] = HZ;
-
-	chip->vendor.duration[TPM_MEDIUM] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
-	chip->vendor.duration[TPM_LONG] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
+		chip->vendor.duration[TPM_MEDIUM] *= 1000;
+		chip->vendor.duration[TPM_LONG] *= 1000;
+		dev_info(chip->dev, "Adjusting TPM timeout parameters.");
+	}
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 

