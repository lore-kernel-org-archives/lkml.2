Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1AYPGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:06:18 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:54655
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751492Ab1AYPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:06:17 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/sdvo: If at first we don't succeed in reading the response, wait
Date: Tue, 25 Jan 2011 15:06:07 +0000
Message-Id: <1295967967-26041-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D3EB90C.9020901@t-online.de>
References: <4D3EB90C.9020901@t-online.de>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were not pausing after detecting the response was pending and so did
not allow the hardware sufficient time to complete before aborting. This
lead to transient failures whilst probing SDVO devices.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Knut, this should fix one of the failures in the log:

[  680.371855] [drm:intel_sdvo_debug_write], SDVOC: W: 0B (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  680.417190] [drm:intel_sdvo_write_cmd], command returns response Pending [4]

which caused the detect routine to return connector_status_unknown.

However, there is still immediately following that:

[  680.419880] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00 (SDVO_CMD_SET_TARGET_OUTPUT)
[  680.450190] [drm:intel_sdvo_write_cmd], command returns response Invalid arg 
[3]

which implies that we are mishandling that odd VGA-2 connector.
-Chris

---
 drivers/gpu/drm/i915/intel_sdvo.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 45cd376..f52df3a 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -473,20 +473,6 @@ static bool intel_sdvo_write_cmd(struct intel_sdvo *intel_sdvo, u8 cmd,
 		return false;
 	}
 
-	i = 3;
-	while (status == SDVO_CMD_STATUS_PENDING && i--) {
-		if (!intel_sdvo_read_byte(intel_sdvo,
-					  SDVO_I2C_CMD_STATUS,
-					  &status))
-			return false;
-	}
-	if (status != SDVO_CMD_STATUS_SUCCESS) {
-		DRM_DEBUG_KMS("command returns response %s [%d]\n",
-			      status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP ? cmd_status_names[status] : "???",
-			      status);
-		return false;
-	}
-
 	return true;
 }
 
@@ -505,12 +491,17 @@ static bool intel_sdvo_read_response(struct intel_sdvo *intel_sdvo,
 	 *
 	 * Check 5 times in case the hardware failed to read the docs.
 	 */
-	do {
+	if (!intel_sdvo_read_byte(intel_sdvo,
+				  SDVO_I2C_CMD_STATUS,
+				  &status))
+		return false;
+	while (status == SDVO_CMD_STATUS_PENDING && retry--) {
+		udelay(15);
 		if (!intel_sdvo_read_byte(intel_sdvo,
 					  SDVO_I2C_CMD_STATUS,
 					  &status))
 			return false;
-	} while (status == SDVO_CMD_STATUS_PENDING && --retry);
+	}
 
 	DRM_DEBUG_KMS("%s: R: ", SDVO_NAME(intel_sdvo));
 	if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
-- 
1.7.2.3

