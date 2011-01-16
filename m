Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1APFqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:46:35 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:49914 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1APFqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:46:35 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACIVMk2rR7Hu/2dsb2JhbACkaXOkVZgdhVAEhHCGL4Uw
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [SCSI] target: Remove unneeded test of se_cmd
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
X-Message-Flag: Warning: May contain useful information
Date: Sat, 15 Jan 2011 21:46:31 -0800
Message-ID: <adazkr1z9hk.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

se_cmd is dereferenced unconditionally in many other parts of
transport_get_lun_for_cmd() so remove the last test whether se_cmd is NULL.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
I'm not 100% sure of this patch (perhaps se_cmd can be NULL here and the
whole rest of the function needs to be fixed instead), but this seems
like the more sensible thing.

 drivers/target/target_core_device.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 317ce58..d94933d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -69,21 +69,17 @@ int transport_get_lun_for_cmd(
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		if (se_cmd) {
-			deve->total_cmds++;
-			deve->total_bytes += se_cmd->data_length;
-
-			if (se_cmd->data_direction == DMA_TO_DEVICE) {
-				if (deve->lun_flags &
-						TRANSPORT_LUNFLAGS_READ_ONLY) {
-					read_only = 1;
-					goto out;
-				}
-				deve->write_bytes += se_cmd->data_length;
-			} else if (se_cmd->data_direction ==
-				   DMA_FROM_DEVICE) {
-				deve->read_bytes += se_cmd->data_length;
+		deve->total_cmds++;
+		deve->total_bytes += se_cmd->data_length;
+
+		if (se_cmd->data_direction == DMA_TO_DEVICE) {
+			if (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
+				read_only = 1;
+				goto out;
 			}
+			deve->write_bytes += se_cmd->data_length;
+		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+			deve->read_bytes += se_cmd->data_length;
 		}
 		deve->deve_cmds++;
 
