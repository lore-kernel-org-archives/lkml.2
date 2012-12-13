Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab2LMOOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab2LMOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 223/241] NFC: pn533: Fix mem leak in pn533_in_dep_link_up
Date: Thu, 13 Dec 2012 11:59:48 -0200
Message-Id: <1355407206-17100-224-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>

commit 70418e6efcf4f8652cc08e3f2ab8ae35f0948fd9 upstream.

cmd is allocated in pn533_dep_link_up and passed as an arg to
pn533_send_cmd_frame_async together with a complete cb.

arg is passed to the cb and must be kfreed there.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/nfc/pn533.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 3811d60..c905563 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1288,11 +1288,14 @@ static void pn533_deactivate_target(struct nfc_dev *nfc_dev,
 static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 						u8 *params, int params_len)
 {
-	struct pn533_cmd_jump_dep *cmd;
 	struct pn533_cmd_jump_dep_response *resp;
 	struct nfc_target nfc_target;
 	u8 target_gt_len;
 	int rc;
+	struct pn533_cmd_jump_dep *cmd = (struct pn533_cmd_jump_dep *)arg;
+	u8 active = cmd->active;
+
+	kfree(arg);
 
 	if (params_len == -ENOENT) {
 		nfc_dev_dbg(&dev->interface->dev, "");
@@ -1314,7 +1317,6 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 	}
 
 	resp = (struct pn533_cmd_jump_dep_response *) params;
-	cmd = (struct pn533_cmd_jump_dep *) arg;
 	rc = resp->status & PN533_CMD_RET_MASK;
 	if (rc != PN533_CMD_RET_SUCCESS) {
 		nfc_dev_err(&dev->interface->dev,
@@ -1344,7 +1346,7 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 	if (rc == 0)
 		rc = nfc_dep_link_is_up(dev->nfc_dev,
 						dev->nfc_dev->targets[0].idx,
-						!cmd->active, NFC_RF_INITIATOR);
+						!active, NFC_RF_INITIATOR);
 
 	return 0;
 }
-- 
1.7.9.5

