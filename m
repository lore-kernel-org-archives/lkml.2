Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab1C3QRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:17:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51249 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab1C3QOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:20 -0400
Message-Id: <20110330161415.318867768@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:23 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 01/12] tpm: Use durations returned from TPM
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_durations_usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM driver currently discards the durations values returned
from the TPM. The check of the response packet needs to consider that
the return_code field is 0 on success and the size of the expected
packet is equivalent to the header size + u32 length indicator for the
TPM_GetCapability() result + 3 timeout indicators of type u32.

v4:
- sysfs entry 'durations' is now a patch of its own
- the work-around for TPMs reporting durations in milliseconds is now in a
  patch of its own

v3:
- sysfs entry now called 'durations' to resemble TPM-speak (previously
  was called 'timeouts')

v2:
- adjusting all timeouts for TPM devices reporting timeouts in msec rather
  than usec
- also displaying in sysfs whether the timeouts are 'original' or 'adjusted'


Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com> 
Tested-by: Guillaume Chazarain <guichaz@gmail.com>

---
 drivers/char/tpm/tpm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
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

