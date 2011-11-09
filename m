Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1KIOdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:33:08 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:46507 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1KIOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:33:06 -0500
X-AuditID: c1b4fb3d-b7c26ae0000035b9-3a-4eba8f1f2940
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <dougthompson@xmission.com>, <borislav.petkov@amd.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH] amd64_edac: fix size decoding error on K8
Date: Wed, 9 Nov 2011 15:32:58 +0100
Message-ID: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a lookup table to calculate the size of a chip select. The old
method of calculating size return erroneous values for some memory
configurations. The lookup table is transcribed from "DRAM CS
Address Mapping Register" [1], pages 88-89.

[1] BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
    Opteron Processors - Revision 3.30 - doc #26094 - February 2006
    http://support.amd.com/us/Processor_TechDocs/26094.pdf

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/edac/amd64_edac.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9a8bebc..396ea76 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1108,6 +1108,10 @@ static int ddr2_cs_size(unsigned i, bool dct_width)
 static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 				  unsigned cs_mode)
 {
+	static const int rev_de_lookup[] = { 32, 64, 128, 128, 256, 512, 256,
+		512, 1024, 1024, 2048 };
+
+
 	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
 
 	if (pvt->ext_model >= K8_REV_F) {
@@ -1116,11 +1120,7 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 	}
 	else if (pvt->ext_model >= K8_REV_D) {
 		WARN_ON(cs_mode > 10);
-
-		if (cs_mode == 3 || cs_mode == 8)
-			return 32 << (cs_mode - 1);
-		else
-			return 32 << cs_mode;
+		return rev_de_lookup[cs_mode];
 	}
 	else {
 		WARN_ON(cs_mode > 6);
-- 
1.7.7.1

