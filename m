Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2IGLZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:25:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34003 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557Ab2IGLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:24:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: [PATCH v6 05/10] audit: add a new "type" field to audit_names struct
Date: Fri,  7 Sep 2012 07:23:42 -0400
Message-Id: <1347017027-17167-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
References: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
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
 include/linux/audit.h |  5 +++++
 kernel/auditsc.c      | 15 ++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2d8b761..48c49eb 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -450,6 +450,11 @@ struct audit_field {
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
index ff58089..bd11d09 100644
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
 
@@ -2171,12 +2174,13 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 
 out_alloc:
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
@@ -2233,6 +2237,7 @@ void __audit_inode_child(const struct inode *parent,
 				audit_copy_inode(n, dentry, inode);
 			else
 				n->ino = (unsigned long)-1;
+			n->type = AUDIT_TYPE_NORMAL;
 			found_child = n->name;
 			goto add_names;
 		}
@@ -2240,14 +2245,14 @@ void __audit_inode_child(const struct inode *parent,
 
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
1.7.11.4

