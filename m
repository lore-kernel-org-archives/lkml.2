Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab1EMXY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:24:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:59038 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272Ab1EMXYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:24:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="2026749"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] VFS: Make symlink nesting limit a define
Date: Fri, 13 May 2011 16:24:15 -0700
Message-Id: <1305329059-2017-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use a SYMLOOP_MAX define for the total symlink nesting limit instead
of a hardcoded 40. No behaviour change.

Used in a followon patch

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/namei.c             |    6 +++---
 include/linux/limits.h |    1 +
 include/linux/namei.h  |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 54fc993..9d0a92e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -763,7 +763,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 	if (link->mnt == nd->path.mnt)
 		mntget(link->mnt);
 
-	if (unlikely(current->total_link_count >= 40)) {
+	if (unlikely(current->total_link_count >= SYMLOOP_MAX)) {
 		*p = ERR_PTR(-ELOOP); /* no ->put_link(), please */
 		path_put(&nd->path);
 		return -ELOOP;
@@ -871,7 +871,7 @@ static int follow_automount(struct path *path, unsigned flags,
 		return -EISDIR;
 
 	current->total_link_count++;
-	if (current->total_link_count >= 40)
+	if (current->total_link_count >= SYMLOOP_MAX)
 		return -ELOOP;
 
 	mnt = path->dentry->d_op->d_automount(path);
@@ -1369,7 +1369,7 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 
 /*
  * This limits recursive symlink follows to 8, while
- * limiting consecutive symlinks to 40.
+ * limiting consecutive symlinks to 40 (SYMLOOP_MAX)
  *
  * Without that kind of total limit, nasty chains of consecutive
  * symlinks can cause almost arbitrarily long lookups.
diff --git a/include/linux/limits.h b/include/linux/limits.h
index 2d0f941..2f39657 100644
--- a/include/linux/limits.h
+++ b/include/linux/limits.h
@@ -14,6 +14,7 @@
 #define XATTR_NAME_MAX   255	/* # chars in an extended attribute name */
 #define XATTR_SIZE_MAX 65536	/* size of an extended attribute value (64k) */
 #define XATTR_LIST_MAX 65536	/* size of extended attribute namelist (64k) */
+#define SYMLOOP_MAX	  40	/* max number of total symlink nests */
 
 #define RTSIG_MAX	  32
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index eba45ea..403e39c 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -4,6 +4,7 @@
 #include <linux/dcache.h>
 #include <linux/linkage.h>
 #include <linux/path.h>
+#include <linux/limits.h>
 
 struct vfsmount;
 
-- 
1.7.4.4

