Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2BOO7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:59:45 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42334 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2BOO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:59:18 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH v2 1/3] firewire-sbp2: Take into account Unit_Unique_ID
Date: Wed, 15 Feb 2012 14:59:08 +0000
Message-Id: <1329317950-101579-2-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317950-101579-1-git-send-email-bootc@bootc.net>
References: <1328881314-26544-1-git-send-email-bootc@bootc.net>
 <1329317950-101579-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the target's unit directory contains a Unit_Unique_ID entry, we
should use that as the target's GUID for identification purposes. The
SBP-2 standards document says:

"Although the node unique ID (EUI-64) present in the bus information
block is sufficient to uniquely identify nodes attached to Serial Bus,
it is insufficient to identify a target when a vendor implements a
device with multiple Serial Bus node connections. In this case initiator
software requires information by which a particular target may be
uniquely identified, regardless of the Serial Bus access path used."

[ IEEE T10 P1155D Revision 4, Section 7.6 (page 51) ] and
[ IEEE T10 P1467D Revision 5, Section 7.9 (page 74) ]

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/sbp2.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 80e95aa..a8f43d2 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -211,6 +211,7 @@ static struct fw_device *target_device(struct sbp2_target *tgt)
 #define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
 #define SBP2_CSR_FIRMWARE_REVISION	0x3c
 #define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
+#define SBP2_CSR_UNIT_UNIQUE_ID		0x8d
 #define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
 
 /* Management orb opcodes */
@@ -997,6 +998,13 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 	return 0;
 }
 
+static void sbp2_get_unit_unique_id(struct sbp2_target *tgt,
+				    const u32 *leaf)
+{
+	if ((leaf[0] & 0xffff0000) == 0x00020000)
+		tgt->guid = (u64)leaf[1] << 32 | leaf[2];
+}
+
 static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt,
 				      const u32 *directory)
 {
@@ -1048,6 +1056,10 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, const u32 *directory,
 				return -ENOMEM;
 			break;
 
+		case SBP2_CSR_UNIT_UNIQUE_ID:
+			sbp2_get_unit_unique_id(tgt, ci.p - 1 + value);
+			break;
+
 		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
 			/* Adjust for the increment in the iterator */
 			if (sbp2_scan_logical_unit_dir(tgt, ci.p - 1 + value) < 0)
-- 
1.7.9

