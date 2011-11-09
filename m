Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab1KJDgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:36:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874Ab1KJDgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:46 2011
Message-Id: <20111109213146.064065951@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [039/264] target: Fix transport_cmd_finish_abort queue removal bug
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 77039d1eafbbc192df71ee84b157b8973766737d upstream.

This patch fixes a bug in LUN_RESET operation with transport_cmd_finish_abort()
where transport_remove_cmd_from_queue() was incorrectly being called, causing
descriptors with t_state == TRANSPORT_FREE_CMD_INTR to be incorrectly removed
from qobj->qobj_list during process context release.  This change ensures the
descriptor is only removed via transport_remove_cmd_from_queue() when doing a
direct release via transport_generic_remove().

Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -594,13 +594,14 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
-	if (remove)
+	if (remove) {
+		transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 		transport_generic_remove(cmd, 0);
+	}
 }
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)


