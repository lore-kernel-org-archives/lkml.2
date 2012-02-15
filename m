Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2BOO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:59:43 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42339 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2BOO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:59:18 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH v2 3/3] firewire-sbp2: Fix SCSI sense data mangling
Date: Wed, 15 Feb 2012 14:59:10 +0000
Message-Id: <1329317950-101579-4-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317950-101579-1-git-send-email-bootc@bootc.net>
References: <1328881314-26544-1-git-send-email-bootc@bootc.net>
 <1329317950-101579-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCSI sense data in SBP-2/3 is carried in an unusual format that means we
have to un-mangle it on our end before we pass it to the SCSI subsystem.
Currently our un-mangling code doesn't quite follow the SBP-2 standard
in that we always assume Current and never Deferred error types, we
never set the VALID bit, and we mishandle the FILEMARK, EOM and ILI
bits.

This patch fixes the sense un-mangling to correctly handle those and
follow the spec.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
(This patch is unchanged from v1)

 drivers/firewire/sbp2.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 9e9631f..b12c6ba 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1302,10 +1302,19 @@ static void sbp2_unmap_scatterlist(struct device *card_device,
 static unsigned int sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
 {
 	int sam_status;
+	int sfmt = (sbp2_status[0] >> 6) & 0x03;
 
-	sense_data[0] = 0x70;
+	if (sfmt == 2 || sfmt == 3) {
+		/*
+		 * Reserved for future standardization (2) or
+		 * Status block format vendor-dependent (3)
+		 */
+		return DID_ERROR << 16;
+	}
+
+	sense_data[0] = 0x70 | sfmt | (sbp2_status[1] & 0x80);
 	sense_data[1] = 0x0;
-	sense_data[2] = sbp2_status[1];
+	sense_data[2] = ((sbp2_status[1] << 1) & 0xe0) | (sbp2_status[1] & 0x0f);
 	sense_data[3] = sbp2_status[4];
 	sense_data[4] = sbp2_status[5];
 	sense_data[5] = sbp2_status[6];
-- 
1.7.9

