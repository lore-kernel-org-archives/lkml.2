Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab0KLVS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:18:58 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:44944 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab0KLVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:18:56 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, eparis@redhat.com,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH] TPM: Long default timeout fix
Date: Fri, 12 Nov 2010 19:18:50 -0200
Message-Id: <1289596730-28966-1-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If duration variable value is 0 at this point, it's because
chip->vendor.duration wasn't filled by tpm_get_timeouts() yet.
This patch sets then the lowest timeout just to give enough
time for tpm_get_timeouts() to further succeed.

This fix avoids long boot times in case another entity attempts
to send commands to the TPM when the TPM isn't accessible.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 7c41335..5635ac0 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -364,12 +364,14 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 		    tpm_protected_ordinal_duration[ordinal &
 						   TPM_PROTECTED_ORDINAL_MASK];
 
-	if (duration_idx != TPM_UNDEFINED)
+	if (duration_idx != TPM_UNDEFINED) {
 		duration = chip->vendor.duration[duration_idx];
-	if (duration <= 0)
+		/* if duration is 0, it's because chip->vendor.duration wasn't */
+		/* filled yet, so we set the lowest timeout just to give enough */
+		/* time for tpm_get_timeouts() to succeed */
+		return (duration <= 0 ? HZ : duration);
+	} else 
 		return 2 * 60 * HZ;
-	else
-		return duration;
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
-- 
1.7.2.3

