Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2JBA2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:28:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37115 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2JBARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:17 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 09/49] audit: optimize audit_compare_dname_path
Date: Mon,  1 Oct 2012 20:16:18 -0400
Message-Id: <1349137018-21948-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the cases where we already know the length of the parent, pass it as
a parm so we don't need to recompute it. In the cases where we don't
know the length, pass in AUDIT_NAME_FULL (-1) to indicate that it should
be determined.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/audit.h       |  5 ++++-
 kernel/audit_watch.c |  3 ++-
 kernel/auditfilter.c | 16 +++++++++++-----
 kernel/auditsc.c     |  8 +++-----
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index ee31316..34af33c 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -74,10 +74,13 @@ static inline int audit_hash_ino(u32 ino)
 	return (ino & (AUDIT_INODE_BUCKETS-1));
 }
 
+/* Indicates that audit should log the full pathname. */
+#define AUDIT_NAME_FULL -1
+
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int parent_len(const char *path);
-extern int audit_compare_dname_path(const char *dname, const char *path);
+extern int audit_compare_dname_path(const char *dname, const char *path, int plen);
 extern struct sk_buff *	    audit_make_reply(int pid, int seq, int type,
 					     int done, int multi,
 					     const void *payload, int size);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index b6a873a..f8e9353 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -265,7 +265,8 @@ static void audit_update_watch(struct audit_parent *parent,
 	/* Run all of the watches on this parent looking for the one that
 	 * matches the given dname */
 	list_for_each_entry_safe(owatch, nextw, &parent->watches, wlist) {
-		if (audit_compare_dname_path(dname, owatch->path))
+		if (audit_compare_dname_path(dname, owatch->path,
+					     AUDIT_NAME_FULL))
 			continue;
 
 		/* If the update involves invalidating rules, do the inode-based
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f47ba18..1e0899d 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1228,11 +1228,17 @@ int parent_len(const char *path)
 	return p - path;
 }
 
-/* Compare given dentry name with last component in given path,
- * return of 0 indicates a match. */
-int audit_compare_dname_path(const char *dname, const char *path)
+/**
+ * audit_compare_dname_path - compare given dentry name with last component in
+ * 			      given path. Return of 0 indicates a match.
+ * @dname:	dentry name that we're comparing
+ * @path:	full pathname that we're comparing
+ * @parentlen:	length of the parent if known. Passing in AUDIT_NAME_FULL
+ * 		here indicates that we must compute this value.
+ */
+int audit_compare_dname_path(const char *dname, const char *path, int parentlen)
 {
-	int dlen, pathlen, parentlen;
+	int dlen, pathlen;
 	const char *p;
 
 	dlen = strlen(dname);
@@ -1240,7 +1246,7 @@ int audit_compare_dname_path(const char *dname, const char *path)
 	if (pathlen < dlen)
 		return 1;
 
-	parentlen = parent_len(path);
+	parentlen = parentlen == AUDIT_NAME_FULL ? parent_len(path) : parentlen;
 	if (pathlen - parentlen != dlen)
 		return 1;
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b03ef6a..52d1f0f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -81,9 +81,6 @@
  * a name dynamically and also add those to the list anchored by names_list. */
 #define AUDIT_NAMES	5
 
-/* Indicates that audit should log the full pathname. */
-#define AUDIT_NAME_FULL -1
-
 /* no execve audit message should be longer than this (userspace limits) */
 #define MAX_EXECVE_AUDIT_LEN 7500
 
@@ -2236,7 +2233,7 @@ void __audit_inode_child(const struct inode *parent,
 			continue;
 
 		if (n->ino == parent->i_ino &&
-		    !audit_compare_dname_path(dname, n->name)) {
+		    !audit_compare_dname_path(dname, n->name, n->name_len)) {
 			found_parent = n->name;
 			goto add_names;
 		}
@@ -2249,7 +2246,8 @@ void __audit_inode_child(const struct inode *parent,
 
 		/* strcmp() is the more likely scenario */
 		if (!strcmp(dname, n->name) ||
-		     !audit_compare_dname_path(dname, n->name)) {
+		    !audit_compare_dname_path(dname, n->name,
+						AUDIT_NAME_FULL)) {
 			if (inode)
 				audit_copy_inode(n, dentry, inode);
 			else
-- 
1.7.11.4

