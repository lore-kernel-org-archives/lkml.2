Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab2JZPnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:43:55 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:58620 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966Ab2JZPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:43:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] audit: break the setup of the audit_name out of audit_inode and into separate function
Date: Fri, 26 Oct 2012 11:43:41 -0400
Message-Id: <1351266222-11107-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
References: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have 2 variants of __audit_inode then they can each call this
function to do the setup.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/auditsc.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6a6d95a..9a65af0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2160,6 +2160,21 @@ static void audit_copy_inode(struct audit_names *name,
 	security_inode_getsecid(inode, &name->osid);
 }
 
+static void audit_names_setup(struct audit_names *n,
+			const struct dentry *dentry, unsigned int parent)
+{
+	if (parent) {
+		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;
+		n->type = AUDIT_TYPE_PARENT;
+	} else {
+		n->name_len = AUDIT_NAME_FULL;
+		n->type = AUDIT_TYPE_NORMAL;
+	}
+	handle_path(dentry);
+	audit_copy_inode(n, dentry->d_inode);
+	audit_copy_fcaps(n, dentry);
+}
+
 /**
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
@@ -2170,7 +2185,6 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 		   unsigned int parent)
 {
 	struct audit_context *context = current->audit_context;
-	const struct inode *inode = dentry->d_inode;
 	struct audit_names *n;
 
 	if (!context->in_syscall)
@@ -2223,16 +2237,7 @@ out_alloc:
 	if (!n)
 		return;
 out:
-	if (parent) {
-		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;
-		n->type = AUDIT_TYPE_PARENT;
-	} else {
-		n->name_len = AUDIT_NAME_FULL;
-		n->type = AUDIT_TYPE_NORMAL;
-	}
-	handle_path(dentry);
-	audit_copy_inode(n, inode);
-	audit_copy_fcaps(n, dentry);
+	audit_names_setup(n, dentry, parent);
 }
 
 /**
-- 
1.7.11.7

