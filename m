Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481Ab2JSDFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:05:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:52018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab2JSCsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 20/76] iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG demo-mode
Date: Thu, 18 Oct 2012 19:46:44 -0700
Message-Id: <20121019024353.354622792@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_tpg.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

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


