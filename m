Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1C3QRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:17:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51251 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab1C3QOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:21 -0400
Message-Id: <20110330161416.905554456@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:27 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 05/12] tpm: Adjust interface timeouts if they are too small
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_iftimeouts_infineon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the interface timeouts if they are found to be too small, i.e., if
they are returned in milliseconds rather than microseconds as we heared
from Infineon that some (old) Infineon TPMs do.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

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
@@ -553,17 +554,21 @@ void tpm_get_timeouts(struct tpm_chip *c
 	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
 	/* Don't overwrite default if value is 0 */
 	timeout = be32_to_cpu(timeout_cap->a);
+	if (timeout && timeout < 1000) {
+		/* timeouts in msec rather usec */
+		scale = 1000;
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

