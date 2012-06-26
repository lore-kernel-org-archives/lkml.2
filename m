Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2FZQfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:35:53 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:62636 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2FZQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:35:49 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/9] audit: add a new "type" field to audit_names struct
Date: Tue, 26 Jun 2012 12:35:32 -0400
Message-Id: <1340728537-25599-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
References: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, we just have two possibilities:

UNKNOWN: for a new audit_names record that we don't know anything about yet
NORMAL: for everything else

In later patches, we'll add other types so we can distinguish and update
records created under different circumstances.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/audit.h |    5 +++++
 kernel/auditsc.c      |   15 ++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 51eca54..7acbfc8 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -449,6 +449,11 @@ struct audit_field {
 extern int __init audit_register_class(int class, unsigned *list);
 extern int audit_classify_syscall(int abi, unsigned syscall);
 extern int audit_classify_arch(int arch);
+
+/* audit_names->type values */
+#define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
+#define AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */
+
 #ifdef CONFIG_AUDITSYSCALL
 /* These are defined in auditsc.c */
 				/* Public API */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 12b007b..21c4223 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -120,6 +120,7 @@ struct audit_names {
 	struct audit_cap_data fcap;
 	unsigned int	fcap_ver;
 	int		name_len;	/* number of name's characters to log */
+	unsigned char	type;		/* record type */
 	bool		name_put;	/* call __putname() for this name */
 	/*
 	 * This was an allocated audit_names and not from the array of
@@ -2009,7 +2010,8 @@ retry:
 #endif
 }
 
-static struct audit_names *audit_alloc_name(struct audit_context *context)
+static struct audit_names *audit_alloc_name(struct audit_context *context,
+						unsigned char type)
 {
 	struct audit_names *aname;
 
@@ -2024,6 +2026,7 @@ static struct audit_names *audit_alloc_name(struct audit_context *context)
 	}
 
 	aname->ino = (unsigned long)-1;
+	aname->type = type;
 	list_add_tail(&aname->list, &context->names_list);
 
 	context->name_count++;
@@ -2054,7 +2057,7 @@ void __audit_getname(const char *name)
 		return;
 	}
 
-	n = audit_alloc_name(context);
+	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
 
@@ -2167,12 +2170,13 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 	}
 
 	/* unable to find the name from a previous getname() */
-	n = audit_alloc_name(context);
+	n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
 	if (!n)
 		return;
 out:
 	handle_path(dentry);
 	audit_copy_inode(n, dentry, inode);
+	n->type = AUDIT_TYPE_NORMAL;
 }
 
 /**
@@ -2229,6 +2233,7 @@ void __audit_inode_child(const struct inode *parent,
 				audit_copy_inode(n, dentry, inode);
 			else
 				n->ino = (unsigned long)-1;
+			n->type = AUDIT_TYPE_NORMAL;
 			found_child = n->name;
 			goto add_names;
 		}
@@ -2236,14 +2241,14 @@ void __audit_inode_child(const struct inode *parent,
 
 add_names:
 	if (!found_parent) {
-		n = audit_alloc_name(context);
+		n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
 		if (!n)
 			return;
 		audit_copy_inode(n, NULL, parent);
 	}
 
 	if (!found_child) {
-		n = audit_alloc_name(context);
+		n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
 		if (!n)
 			return;
 
-- 
1.7.7.6

