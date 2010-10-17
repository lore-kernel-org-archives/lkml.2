Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0JQSmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:42:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50840 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab0JQSmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:42:13 -0400
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs/jffs2/dir.c: Use kasprintf
Date: Sun, 17 Oct 2010 20:48:31 +0200
Message-Id: <1287341311-11161-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287341311-11161-1-git-send-email-julia@diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a sequence of kmalloc and memcpy to use kasprintf.  The argument is
checked for being a string by the presence of a previous call to strlen.

The semantic patch that performs this transformation is:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag,len;
expression arg,e1,e2;
statement S;
@@

  len = strlen(arg)
  ... when != len = e1
      when != arg = e2
  a =
-  \(kmalloc\|kzalloc\)(len+1,flag)
+  kasprintf(flag,"%s",arg)
  <... when != a
  if (a == NULL || ...) S
  ...>
- memcpy(a,arg,len+1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/jffs2/dir.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index ed78a3c..8ee5675 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -367,7 +367,7 @@ static int jffs2_symlink (struct inode *dir_i, struct dentry *dentry, const char
 	}
 
 	/* We use f->target field to store the target path. */
-	f->target = kmalloc(targetlen + 1, GFP_KERNEL);
+	f->target = kasprintf(GFP_KERNEL, "%s", target);
 	if (!f->target) {
 		printk(KERN_WARNING "Can't allocate %d bytes of memory\n", targetlen + 1);
 		mutex_unlock(&f->sem);
@@ -376,7 +376,6 @@ static int jffs2_symlink (struct inode *dir_i, struct dentry *dentry, const char
 		goto fail;
 	}
 
-	memcpy(f->target, target, targetlen + 1);
 	D1(printk(KERN_DEBUG "jffs2_symlink: symlink's target '%s' cached\n", (char *)f->target));
 
 	/* No data here. Only a metadata node, which will be

