Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2IFPNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:13:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab2IFPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:13:50 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org
Subject: [PATCH 3.6 1/2] target: remove pscsi_clear_cdb_lun
Date: Thu,  6 Sep 2012 17:13:29 +0200
Message-Id: <1346944410-19850-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this function is to clear a LUN set in the CDB, in case
the initiator talking to us is speaking an old standards version.
However, as things stand, pscsi_clear_cdb_lun has two problems.  It
will "deceive" the guest by clearing the LUN bits on initial
commands (INQUIRY, TEST UNIT READY, etc.); but then it will let the
LUN bits through on reads, which will likely fail due to protection not
being enabled.  Second, not all commands are properly filtered, in
particular WRITE's WRPROTECT bits are cleared.

This should be done by the fabric module rather than by PSCSI, if it
knows such initiators may be lying around _and_ it can assume that its
initiators do not really care about protection information.  Nuke it
from PSCSI.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_pscsi.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5f7151d..a0fb2c3 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1031,30 +1031,6 @@ fail:
 	return -ENOMEM;
 }
 
-/*
- * Clear a lun set in the cdb if the initiator talking to use spoke
- * and old standards version, as we can't assume the underlying device
- * won't choke up on it.
- */
-static inline void pscsi_clear_cdb_lun(unsigned char *cdb)
-{
-	switch (cdb[0]) {
-	case READ_10: /* SBC - RDProtect */
-	case READ_12: /* SBC - RDProtect */
-	case READ_16: /* SBC - RDProtect */
-	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
-	case VERIFY: /* SBC - VRProtect */
-	case VERIFY_16: /* SBC - VRProtect */
-	case WRITE_VERIFY: /* SBC - VRProtect */
-	case WRITE_VERIFY_12: /* SBC - VRProtect */
-	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
-		break;
-	default:
-		cdb[1] &= 0x1f; /* clear logical unit number */
-		break;
-	}
-}
-
 static int pscsi_parse_cdb(struct se_cmd *cmd)
 {
 	unsigned char *cdb = cmd->t_task_cdb;
@@ -1067,8 +1043,6 @@ static int pscsi_parse_cdb(struct se_cmd *cmd)
 		return -EINVAL;
 	}
 
-	pscsi_clear_cdb_lun(cdb);
-
 	/*
 	 * For REPORT LUNS we always need to emulate the response, for everything
 	 * else the default for pSCSI is to pass the command to the underlying
-- 
1.7.1


