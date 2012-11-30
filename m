Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab2K3TIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:08:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:59774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993079Ab2K3TCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [ 46/54] NFC: pn533: Fix mem leak in pn533_in_dep_link_up
Date: Fri, 30 Nov 2012 10:56:17 -0800
Message-Id: <20121130185212.551797168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>

commit 70418e6efcf4f8652cc08e3f2ab8ae35f0948fd9 upstream.

cmd is allocated in pn533_dep_link_up and passed as an arg to
pn533_send_cmd_frame_async together with a complete cb.

arg is passed to the cb and must be kfreed there.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/pn533.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1618,11 +1618,14 @@ static void pn533_deactivate_target(stru
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
@@ -1644,7 +1647,6 @@ static int pn533_in_dep_link_up_complete
 	}
 
 	resp = (struct pn533_cmd_jump_dep_response *) params;
-	cmd = (struct pn533_cmd_jump_dep *) arg;
 	rc = resp->status & PN533_CMD_RET_MASK;
 	if (rc != PN533_CMD_RET_SUCCESS) {
 		nfc_dev_err(&dev->interface->dev,
@@ -1674,7 +1676,7 @@ static int pn533_in_dep_link_up_complete
 	if (rc == 0)
 		rc = nfc_dep_link_is_up(dev->nfc_dev,
 						dev->nfc_dev->targets[0].idx,
-						!cmd->active, NFC_RF_INITIATOR);
+						!active, NFC_RF_INITIATOR);
 
 	return 0;
 }


