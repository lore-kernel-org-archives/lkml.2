Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2FMLVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:21:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40789
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2FMLVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:21:16 -0400
Date: Wed, 13 Jun 2012 07:21:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, dhowells@redhat.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120613112112.GA10597@infradead.org>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
 <20120610111056.GD30000@ZenIV.linux.org.uk>
 <20120610175605.GE30000@ZenIV.linux.org.uk>
 <20120610222745.GG30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610222745.GG30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:27:45PM +0100, Al Viro wrote:
> And in vfs.git#master there's a followup to that.  ->d_revalidate(),
> ->lookup() and ->create() are nameidata-free now.  IOW, open intents
> crap is well and truly dead.  Good riddance.
> 
> Miklos, if I see you at Kernel Summit (or anywhere else, for that matter),
> I owe you a bottle of booze of your choice.

It also shows that were are really close to getting nameidata out of the
filesystem.  The remaning issues are kern_path_parent usages in devtmpfs
and audit_watch, as well as direct access to nd->path in
proc_pid_follow_link.  A hacky patch to demonstrate this is below (not
intended for submission).


diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 765c3a2..b5e907b 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -25,6 +25,8 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 
+#include "../internal.h"
+
 static struct task_struct *thread;
 
 #if defined CONFIG_DEVTMPFS_MOUNT
diff --git a/fs/internal.h b/fs/internal.h
index 8a9f5fa..3826dcc 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -115,3 +115,23 @@ extern int invalidate_inodes(struct super_block *, bool);
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+
+
+enum { MAX_NESTED_LINKS = 8 };
+
+struct nameidata {
+	struct path	path;
+	struct qstr	last;
+	struct path	root;
+	struct inode	*inode; /* path.dentry.d_inode */
+	unsigned int	flags;
+	unsigned	seq;
+	int		last_type;
+	unsigned	depth;
+	char *saved_names[MAX_NESTED_LINKS + 1];
+};
+
+/*
+ * Type of the last component on LOOKUP_PARENT
+ */
+enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
diff --git a/fs/namei.c b/fs/namei.c
index 1fc02ff..2ea6608 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3629,6 +3629,18 @@ out:
 	return len;
 }
 
+void nd_set_link(struct nameidata *nd, char *path)
+{
+	nd->saved_names[nd->depth] = path;
+}
+EXPORT_SYMBOL(nd_set_link);
+
+char *nd_get_link(struct nameidata *nd)
+{
+	return nd->saved_names[nd->depth];
+}
+EXPORT_SYMBOL(nd_get_link);
+
 /*
  * A helper for ->readlink().  This should be used *ONLY* for symlinks that
  * have ->follow_link() touching nd only in nd_set_link().  Using (or not
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8eaa5ea..5453fdd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -90,6 +90,7 @@
 #endif
 #include <trace/events/oom.h>
 #include "internal.h"
+#include "../internal.h"
 
 /* NOTE:
  *	Implementing inode permission operations in /proc is almost
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 54dadda..5d92c0a 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -5,26 +5,7 @@
 #include <linux/linkage.h>
 #include <linux/path.h>
 
-struct vfsmount;
-
-enum { MAX_NESTED_LINKS = 8 };
-
-struct nameidata {
-	struct path	path;
-	struct qstr	last;
-	struct path	root;
-	struct inode	*inode; /* path.dentry.d_inode */
-	unsigned int	flags;
-	unsigned	seq;
-	int		last_type;
-	unsigned	depth;
-	char *saved_names[MAX_NESTED_LINKS + 1];
-};
-
-/*
- * Type of the last component on LOOKUP_PARENT
- */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
+struct nameidata;
 
 /*
  * The bitmask for a lookup event:
@@ -71,9 +52,6 @@ extern int kern_path_parent(const char *, struct nameidata *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
 
-extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *));
-
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 
 extern int follow_down_one(struct path *);
@@ -83,15 +61,8 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
-static inline void nd_set_link(struct nameidata *nd, char *path)
-{
-	nd->saved_names[nd->depth] = path;
-}
-
-static inline char *nd_get_link(struct nameidata *nd)
-{
-	return nd->saved_names[nd->depth];
-}
+extern void nd_set_link(struct nameidata *nd, char *path);
+extern char *nd_get_link(struct nameidata *nd);
 
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index e683869..0943897 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -32,6 +32,8 @@
 #include <linux/security.h>
 #include "audit.h"
 
+#include "../fs/internal.h"
+
 /*
  * Reference counting:
  *
