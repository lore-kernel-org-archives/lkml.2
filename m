Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2JNOnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab2JNOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:03 -0400
Message-Id: <20121014143546.089208491@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [ 091/147] iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG
 demo-mode
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_tpg.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index a38a3f8..de9ea32 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -677,6 +677,12 @@ int iscsit_ta_generate_node_acls(
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
 
@@ -716,6 +722,12 @@ int iscsit_ta_cache_dynamic_acls(
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


