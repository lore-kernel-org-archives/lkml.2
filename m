Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1C3QOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48930 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab1C3QOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:23 -0400
Message-Id: <20110330161416.487850194@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:26 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 04/12] tpm: Use interface timeouts returned from the TPM
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_iftimeouts_usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM driver currently discards the interface timeout values returned
from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected
packet is equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 4 interface timeout indicators of type u32.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -545,9 +545,10 @@ void tpm_get_timeouts(struct tpm_chip *c
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

