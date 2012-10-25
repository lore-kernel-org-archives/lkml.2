Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2JYSbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab2JYSbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:31:08 -0400
Date: Thu, 25 Oct 2012 14:30:18 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH v2] fs: xattr: rewrite simple_xattr_set()
Message-ID: <20121025183018.GI14085@redhat.com>
References: <20121025152613.GF14085@redhat.com>
 <20121025173326.GH11442@htj.dyndns.org>
 <20121025175412.GG14085@redhat.com>
 <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way this function was written is confusing and already caused problems.
Rewriting it to be easier to understand and maintain.

v2:
- fix error return value in __simple_xattr_remove() (pointed by Tejun Heo)

Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 fs/xattr.c |  124 +++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 48 deletions(-)

Index: github/fs/xattr.c
===================================================================
--- github.orig/fs/xattr.c	2012-10-23 16:02:41.155857391 -0400
+++ github/fs/xattr.c	2012-10-25 11:17:15.118197552 -0400
@@ -842,55 +842,46 @@
 	return ret;
 }
 
-static int __simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
-			      const void *value, size_t size, int flags)
+static struct simple_xattr *__find_xattr(struct simple_xattrs *xattrs,
+					 const char *name)
 {
 	struct simple_xattr *xattr;
-	struct simple_xattr *new_xattr = NULL;
-	int err = 0;
-
-	/* value == NULL means remove */
-	if (value) {
-		new_xattr = simple_xattr_alloc(value, size);
-		if (!new_xattr)
-			return -ENOMEM;
-
-		new_xattr->name = kstrdup(name, GFP_KERNEL);
-		if (!new_xattr->name) {
-			kfree(new_xattr);
-			return -ENOMEM;
-		}
-	}
 
-	spin_lock(&xattrs->lock);
 	list_for_each_entry(xattr, &xattrs->head, list) {
-		if (!strcmp(name, xattr->name)) {
-			if (flags & XATTR_CREATE) {
-				xattr = new_xattr;
-				err = -EEXIST;
-			} else if (new_xattr) {
-				list_replace(&xattr->list, &new_xattr->list);
-			} else {
-				list_del(&xattr->list);
-			}
-			goto out;
-		}
+		if (!strcmp(name, xattr->name))
+			return xattr;
 	}
-	if (flags & XATTR_REPLACE) {
-		xattr = new_xattr;
-		err = -ENODATA;
-	} else {
-		list_add(&new_xattr->list, &xattrs->head);
-		xattr = NULL;
-	}
-out:
-	spin_unlock(&xattrs->lock);
+	return NULL;
+}
+
+static int __simple_xattr_remove(struct simple_xattrs *xattrs,
+				 const char *name)
+{
+	struct simple_xattr *xattr;
+
+	xattr = __find_xattr(xattrs, name);
 	if (xattr) {
+		list_del(&xattr->list);
 		kfree(xattr->name);
 		kfree(xattr);
+		return 0;
 	}
-	return err;
 
+	return -ENODATA;
+}
+
+/*
+ * xattr REMOVE operation for in-memory/pseudo filesystems
+ */
+int simple_xattr_remove(struct simple_xattrs *xattrs, const char *name)
+{
+	int rc;
+
+	spin_lock(&xattrs->lock);
+	rc = __simple_xattr_remove(xattrs, name);
+	spin_unlock(&xattrs->lock);
+
+	return rc;
 }
 
 /**
@@ -910,17 +901,54 @@
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)
 {
+	struct simple_xattr *found, *new_xattr;
+	int err = 0;
+
 	if (size == 0)
-		value = ""; /* empty EA, do not remove */
-	return __simple_xattr_set(xattrs, name, value, size, flags);
-}
+		value = ""; /* empty EA */
 
-/*
- * xattr REMOVE operation for in-memory/pseudo filesystems
- */
-int simple_xattr_remove(struct simple_xattrs *xattrs, const char *name)
-{
-	return __simple_xattr_set(xattrs, name, NULL, 0, XATTR_REPLACE);
+	/* if value == NULL is specified, remove the item */
+	if (value == NULL)
+		return simple_xattr_remove(xattrs, name);
+
+	new_xattr = simple_xattr_alloc(value, size);
+	if (!new_xattr)
+		return -ENOMEM;
+
+	new_xattr->name = kstrdup(name, GFP_KERNEL);
+	if (!new_xattr->name) {
+		kfree(new_xattr);
+		return -ENOMEM;
+	}
+
+	spin_lock(&xattrs->lock);
+
+	found = __find_xattr(xattrs, name);
+	if (found) {
+		if (flags & XATTR_CREATE) {
+			err = -EEXIST;
+			goto free_new;
+		}
+
+		list_replace(&found->list, &new_xattr->list);
+		kfree(found->name);
+		kfree(found);
+	} else {
+		if (flags & XATTR_REPLACE) {
+			err = -ENODATA;
+			goto free_new;
+		}
+
+		list_add_tail(&new_xattr->list, &xattrs->head);
+	}
+
+out:
+	spin_unlock(&xattrs->lock);
+	return err;
+free_new:
+	kfree(new_xattr->name);
+	kfree(new_xattr);
+	goto out;
 }
 
 static bool xattr_is_trusted(const char *name)
