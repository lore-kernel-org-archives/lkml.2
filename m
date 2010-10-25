Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab0JYSmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab0JYSms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:42:48 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 10/11] IMA: explicit IMA i_flag to remove global lock on
	inode_delete
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:42:19 -0400
Message-ID: <20101025184219.20504.7019.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently for every removed inode IMA must take a global lock and search
the IMA rbtree looking for an associated integrity structure.  Instead we
explicitly mark an inode when we add an integrity structure so we only have
to take the global lock and do the removal if it exists.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 include/linux/fs.h                |    2 ++
 security/integrity/ima/ima_iint.c |   16 +++++++++++-----
 security/integrity/ima/ima_main.c |    1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cb9dbd0..b228b3a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -231,6 +231,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_IMA		1024	/* Inode has an associated IMA struct */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -265,6 +266,7 @@ struct inodes_stat_t {
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_IMA(inode)		((inode)->i_flags & S_IMA)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 969a1c1..c442e47 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -59,6 +59,9 @@ struct ima_iint_cache *ima_iint_find(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
+	if (!IS_IMA(inode))
+		return NULL;
+
 	spin_lock(&ima_iint_lock);
 	iint = __ima_iint_find(inode);
 	spin_unlock(&ima_iint_lock);
@@ -91,6 +94,7 @@ int ima_inode_alloc(struct inode *inode)
 	new_iint->inode = inode;
 	new_node = &new_iint->rb_node;
 
+	mutex_lock(&inode->i_mutex); /* i_flags */
 	spin_lock(&ima_iint_lock);
 
 	p = &ima_iint_tree.rb_node;
@@ -107,14 +111,17 @@ int ima_inode_alloc(struct inode *inode)
 			goto out_err;
 	}
 
+	inode->i_flags |= S_IMA;
 	rb_link_node(new_node, parent, p);
 	rb_insert_color(new_node, &ima_iint_tree);
 
 	spin_unlock(&ima_iint_lock);
+	mutex_unlock(&inode->i_mutex); /* i_flags */
 
 	return 0;
 out_err:
 	spin_unlock(&ima_iint_lock);
+	mutex_unlock(&inode->i_mutex); /* i_flags */
 	iint_free(new_iint);
 
 	return rc;
@@ -135,15 +142,14 @@ void ima_inode_free(struct inode *inode)
 
 	inode->i_readcount = 0;
 
+	if (!IS_IMA(inode))
+		return;
+
 	spin_lock(&ima_iint_lock);
 	iint = __ima_iint_find(inode);
-	if (iint)
-		rb_erase(&iint->rb_node, &ima_iint_tree);
+	rb_erase(&iint->rb_node, &ima_iint_tree);
 	spin_unlock(&ima_iint_lock);
 
-	if (!iint)
-		return;
-
 	iint_free(iint);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 1dccafe..60dd615 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -211,6 +211,7 @@ void ima_file_free(struct file *file)
 
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
+
 	iint = ima_iint_find(inode);
 
 	if (iint)

