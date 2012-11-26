Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2KZSNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:13:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47215 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab2KZRCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 045/270] iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG demo-mode
Date: Mon, 26 Nov 2012 14:55:35 -0200
Message-Id: <1353949160-26803-46-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 38b11bae6ba02da352340aff12ee25755977b222 upstream.

We've had reports in the past about this specific case, so it's time to
go ahead and explicitly set cache_dynamic_acls=1 for generate_node_acls=1
(TPG demo-mode) operation.

During normal generate_node_acls=0 operation with explicit NodeACLs ->
se_node_acl memory is persistent to the configfs group located at
/sys/kernel/config/target/$TARGETNAME/$TPGT/acls/$INITIATORNAME, so in
the generate_node_acls=1 case we want the reservation logic to reference
existing per initiator IQN se_node_acl memory (not to generate a new
se_node_acl), so go ahead and always set cache_dynamic_acls=1 when
TPG demo-mode is enabled.

Reported-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target_tpg.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 879d8d0..c3d7bf54 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -672,6 +672,12 @@ int iscsit_ta_generate_node_acls(
 	pr_debug("iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n",
 		tpg->tpgt, (a->generate_node_acls) ? "Enabled" : "Disabled");
 
+	if (flag == 1 && a->cache_dynamic_acls == 0) {
+		pr_debug("Explicitly setting cache_dynamic_acls=1 when "
+			"generate_node_acls=1\n");
+		a->cache_dynamic_acls = 1;
+	}
+
 	return 0;
 }
 
@@ -711,6 +717,12 @@ int iscsit_ta_cache_dynamic_acls(
 		return -EINVAL;
 	}
 
+	if (a->generate_node_acls == 1 && flag == 0) {
+		pr_debug("Skipping cache_dynamic_acls=0 when"
+			" generate_node_acls=1\n");
+		return 0;
+	}
+
 	a->cache_dynamic_acls = flag;
 	pr_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
 		" ACLs %s\n", tpg->tpgt, (a->cache_dynamic_acls) ?
-- 
1.7.9.5

