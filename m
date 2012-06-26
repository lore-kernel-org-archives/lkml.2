Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2FZQhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:37:04 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:62636 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2FZQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:35:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/9] audit: remove dirlen argument to audit_compare_dname_path
Date: Tue, 26 Jun 2012 12:35:34 -0400
Message-Id: <1340728537-25599-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
References: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the callers set this to NULL now.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/audit.h       |    3 +--
 kernel/audit_watch.c |    2 +-
 kernel/auditfilter.c |    6 +-----
 kernel/auditsc.c     |    4 ++--
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 276ca88..ee31316 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -77,8 +77,7 @@ static inline int audit_hash_ino(u32 ino)
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int parent_len(const char *path);
-extern int audit_compare_dname_path(const char *dname, const char *path,
-				    int *dirlen);
+extern int audit_compare_dname_path(const char *dname, const char *path);
 extern struct sk_buff *	    audit_make_reply(int pid, int seq, int type,
 					     int done, int multi,
 					     const void *payload, int size);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index e683869..44f3b31 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -265,7 +265,7 @@ static void audit_update_watch(struct audit_parent *parent,
 	/* Run all of the watches on this parent looking for the one that
 	 * matches the given dname */
 	list_for_each_entry_safe(owatch, nextw, &parent->watches, wlist) {
-		if (audit_compare_dname_path(dname, owatch->path, NULL))
+		if (audit_compare_dname_path(dname, owatch->path))
 			continue;
 
 		/* If the update involves invalidating rules, do the inode-based
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 29b167b..f9c48d0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1230,8 +1230,7 @@ int parent_len(const char *path)
 
 /* Compare given dentry name with last component in given path,
  * return of 0 indicates a match. */
-int audit_compare_dname_path(const char *dname, const char *path,
-			     int *dirlen)
+int audit_compare_dname_path(const char *dname, const char *path)
 {
 	int dlen, plen;
 	const char *p;
@@ -1260,9 +1259,6 @@ int audit_compare_dname_path(const char *dname, const char *path,
 			p++;
 	}
 
-	/* return length of path's directory component */
-	if (dirlen)
-		*dirlen = p - path;
 	return strncmp(p, dname, dlen);
 }
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e9f8b60..34d7ab2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2232,7 +2232,7 @@ void __audit_inode_child(const struct inode *parent,
 			continue;
 
 		if (n->ino == parent->i_ino &&
-		    !audit_compare_dname_path(dname, n->name, NULL)) {
+		    !audit_compare_dname_path(dname, n->name)) {
 			found_parent = n->name;
 			goto add_names;
 		}
@@ -2245,7 +2245,7 @@ void __audit_inode_child(const struct inode *parent,
 
 		/* strcmp() is the more likely scenario */
 		if (!strcmp(dname, n->name) ||
-		     !audit_compare_dname_path(dname, n->name, NULL)) {
+		     !audit_compare_dname_path(dname, n->name)) {
 			if (inode)
 				audit_copy_inode(n, dentry, inode);
 			else
-- 
1.7.7.6

