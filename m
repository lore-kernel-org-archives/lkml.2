Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab2IGNiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:38:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64530 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624Ab2IGNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 09/10] vfs: embed getname_info inside of names_cache allocation if possible
Date: Fri,  7 Sep 2012 09:38:04 -0400
Message-Id: <1347025085-20285-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the common case where a name is much smaller than PATH_MAX, an extra
allocation for struct getname_info is unnecessary. Before allocating a
separate one, try to embed the getname_info inside the buffer first. If
it turns out that that's not long enough, then fall back to allocating a
separate getname_info struct and redoing the copy.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c         | 69 ++++++++++++++++++++++++++++++++++++++----------------
 include/linux/fs.h |  1 +
 2 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ac57c42..52feb98 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -119,36 +119,65 @@
  */
 void final_putname(struct getname_info *ginfo)
 {
-	__putname(ginfo->name);
-	kfree(ginfo);
+	if (ginfo->separate) {
+		__putname(ginfo->name);
+		kfree(ginfo);
+	} else {
+		__putname(ginfo);
+	}
 }
 
+#define EMBEDDED_NAME_MAX	(PATH_MAX - sizeof(struct getname_info))
+
 static struct getname_info *
 getname_flags(const char __user *filename, int flags, int *empty)
 {
 	struct getname_info *result, *err;
-	char *kname;
 	int len;
+	long max;
+	char *kname;
 
-	/* FIXME: create dedicated slabcache? */
-	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	result = __getname();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
-	kname = __getname();
-	if (unlikely(!kname)) {
-		err = ERR_PTR(-ENOMEM);
-		goto error_free_ginfo;
-	}
-
+	/*
+	 * First, try to embed the getname_info inside the names_cache
+	 * allocation
+	 */
+	kname = (char *)result + sizeof(*result);
 	result->name = kname;
-	result->uptr = filename;
-	len = strncpy_from_user(kname, filename, PATH_MAX);
+	result->separate = false;
+	max = EMBEDDED_NAME_MAX;
+
+recopy:
+	len = strncpy_from_user(kname, filename, max);
 	if (unlikely(len < 0)) {
 		err = ERR_PTR(len);
 		goto error;
 	}
 
+	/*
+	 * Uh-oh. We have a name that's approaching PATH_MAX. Allocate a
+	 * separate getname_info struct so we can dedicate the entire
+	 * names_cache allocation for the pathname, and re-do the copy from
+	 * userland.
+	 */
+	if (len == EMBEDDED_NAME_MAX && max == EMBEDDED_NAME_MAX) {
+		kname = (char *)result;
+
+		result = kzalloc(sizeof(*result), GFP_KERNEL);
+		if (!result) {
+			err = ERR_PTR(-ENOMEM);
+			result = (struct getname_info *)kname;
+			goto error;
+		}
+		result->name = kname;
+		result->separate = true;
+		max = PATH_MAX;
+		goto recopy;
+	}
+
 	/* The empty path is special. */
 	if (unlikely(!len)) {
 		if (empty)
@@ -159,15 +188,15 @@ getname_flags(const char __user *filename, int flags, int *empty)
 	}
 
 	err = ERR_PTR(-ENAMETOOLONG);
-	if (likely(len < PATH_MAX)) {
-		audit_getname(result);
-		return result;
-	}
+	if (unlikely(len >= PATH_MAX))
+		goto error;
+
+	result->uptr = filename;
+	audit_getname(result);
+	return result;
 
 error:
-	__putname(kname);
-error_free_ginfo:
-	kfree(result);
+	final_putname(result);
 	return err;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4ce38f2..a3c2c17 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2194,6 +2194,7 @@ struct getname_info {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
 	struct audit_names	*aname;
+	bool			separate; /* should "name" be freed? */
 };
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
-- 
1.7.11.4

