Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab2IGNjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:39:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64530 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760216Ab2IGNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:23 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 05/10] audit: allow audit code to satisfy getname requests from its names_list
Date: Fri,  7 Sep 2012 09:38:00 -0400
Message-Id: <1347025085-20285-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if we call getname() on a userland string more than once,
we'll get multiple copies of the string and multiple audit_names
records.

Add a function that will allow the audit_names code to satisfy getname
requests using info from the audit_names list, avoiding a new allocation
and audit_names records.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/audit.h |  8 ++++++++
 kernel/auditsc.c      | 23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index d361921..ea58de3 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -469,6 +469,7 @@ extern void __audit_syscall_entry(int arch,
 				  int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
+extern struct getname_info *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct getname_info *ginfo);
 extern void audit_putname(struct getname_info *ginfo);
 extern void __audit_inode(const char *name, const struct dentry *dentry,
@@ -505,6 +506,12 @@ static inline void audit_syscall_exit(void *pt_regs)
 		__audit_syscall_exit(success, return_code);
 	}
 }
+static inline struct getname_info *audit_reusename(const __user char *name)
+{
+	if (unlikely(!audit_dummy_context()))
+		return __audit_reusename(name);
+	return NULL;
+}
 static inline void audit_getname(struct getname_info *name)
 {
 	if (unlikely(!audit_dummy_context()))
@@ -642,6 +649,7 @@ extern int audit_signals;
 #define audit_syscall_entry(ta,a,b,c,d,e) do { ; } while (0)
 #define audit_syscall_exit(r) do { ; } while (0)
 #define audit_dummy_context() 1
+#define audit_reusename(g) ({ NULL; })
 #define audit_getname(n) do { ; } while (0)
 #define audit_putname(n) do { ; } while (0)
 #define __audit_inode(n,d,p) do { ; } while (0)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3ffb71a..22121bb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2034,6 +2034,29 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
 }
 
 /**
+ * audit_reusename - fill out getname_info with info from existing entry
+ * @uptr: userland ptr to pathname
+ *
+ * Search the audit_names list for the current audit context. If there is an
+ * existing entry with a matching "uptr" then return the getname_info
+ * associated with that audit_name. If not, return NULL.
+ */
+struct getname_info *
+__audit_reusename(const __user char *uptr)
+{
+	struct audit_context *context = current->audit_context;
+	struct audit_names *n;
+
+	list_for_each_entry(n, &context->names_list, list) {
+		if (!n->ginfo)
+			continue;
+		if (n->ginfo->uptr == uptr)
+			return n->ginfo;
+	}
+	return NULL;
+}
+
+/**
  * audit_getname - add a name to the list
  * @name: name to add
  *
-- 
1.7.11.4

