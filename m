Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab2JZPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:44:43 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:58620 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928Ab2JZPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:43:51 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] audit: eliminate optional dentry argument to audit_copy_inode
Date: Fri, 26 Oct 2012 11:43:40 -0400
Message-Id: <1351266222-11107-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
References: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just have callers that are passing in a dentry call audit_copy_fcaps
themselves after audit_copy_inode returns.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/auditsc.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2f186ed..6a6d95a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2148,7 +2148,7 @@ static inline int audit_copy_fcaps(struct audit_names *name, const struct dentry
 
 
 /* Copy inode data into an audit_names. */
-static void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
+static void audit_copy_inode(struct audit_names *name,
 			     const struct inode *inode)
 {
 	name->ino   = inode->i_ino;
@@ -2158,7 +2158,6 @@ static void audit_copy_inode(struct audit_names *name, const struct dentry *dent
 	name->gid   = inode->i_gid;
 	name->rdev  = inode->i_rdev;
 	security_inode_getsecid(inode, &name->osid);
-	audit_copy_fcaps(name, dentry);
 }
 
 /**
@@ -2232,7 +2231,8 @@ out:
 		n->type = AUDIT_TYPE_NORMAL;
 	}
 	handle_path(dentry);
-	audit_copy_inode(n, dentry, inode);
+	audit_copy_inode(n, inode);
+	audit_copy_fcaps(n, dentry);
 }
 
 /**
@@ -2301,7 +2301,7 @@ void __audit_inode_child(const struct inode *parent,
 		n = audit_alloc_name(context, AUDIT_TYPE_PARENT);
 		if (!n)
 			return;
-		audit_copy_inode(n, NULL, parent);
+		audit_copy_inode(n, parent);
 	}
 
 	if (!found_child) {
@@ -2319,10 +2319,13 @@ void __audit_inode_child(const struct inode *parent,
 			found_child->name_put = false;
 		}
 	}
-	if (inode)
-		audit_copy_inode(found_child, dentry, inode);
-	else
+
+	if (inode) {
+		audit_copy_inode(found_child, inode);
+		audit_copy_fcaps(found_child, dentry);
+	} else {
 		found_child->ino = (unsigned long)-1;
+	}
 }
 EXPORT_SYMBOL_GPL(__audit_inode_child);
 
-- 
1.7.11.7

