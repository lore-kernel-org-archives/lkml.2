Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937Ab2C3VU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935988Ab2C3VUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:23 -0400
Message-Id: <20120330194838.528005881@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 072/175] iscsi-target: Fix dynamic -> explict NodeACL pointer reference
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit d06283341aee9e48eff1b068779d340785c635ce upstream.

This patch fixes a free after use in lio_target_make_nodeacl() where
iscsi_node_acl was referenced from the original se_nacl_new allocation,
instead of from core_tpg_add_initiator_node_acl() in the case of dynamic
-> explict NodeACL conversion.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_configfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -812,9 +812,6 @@ static struct se_node_acl *lio_target_ma
 	if (!se_nacl_new)
 		return ERR_PTR(-ENOMEM);
 
-	acl = container_of(se_nacl_new, struct iscsi_node_acl,
-				se_node_acl);
-
 	cmdsn_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
 	/*
 	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
@@ -825,7 +822,8 @@ static struct se_node_acl *lio_target_ma
 	if (IS_ERR(se_nacl))
 		return se_nacl;
 
-	stats_cg = &acl->se_node_acl.acl_fabric_stat_group;
+	acl = container_of(se_nacl, struct iscsi_node_acl, se_node_acl);
+	stats_cg = &se_nacl->acl_fabric_stat_group;
 
 	stats_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);


