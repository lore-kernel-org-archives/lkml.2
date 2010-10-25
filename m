Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab0JYSnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456Ab0JYSn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:27 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 09/11] IMA: drop refcnt from ima_iint_cache since it isn't
	needed
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:42:12 -0400
Message-ID: <20101025184212.20504.93145.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since finding a struct ima_iint_cache requires a valid struct inode, and the
struct ima_iint_cache is supposed to have the same lifetime as a struct inode
(technically they die together but don't need to be created at the same time)
we don't have to worry about the ima_iint_cache outliving or dieing before the
inode.  So the refcnt isn't useful.  Just get rid of it and free the structure
when the inode is freed.

Signed-off-by: Eric Paris <eapris@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h      |    4 +---
 security/integrity/ima/ima_iint.c |   38 ++++++++++++++++---------------------
 security/integrity/ima/ima_main.c |    7 ++-----
 3 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 27849e1..ac79032 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -107,7 +107,6 @@ struct ima_iint_cache {
 	unsigned char flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
-	struct kref refcount;	/* ima_iint_cache reference count */
 };
 
 /* LIM API function definitions */
@@ -125,8 +124,7 @@ void ima_template_show(struct seq_file *m, void *e,
  * integrity data associated with an inode.
  */
 struct ima_iint_cache *ima_iint_insert(struct inode *inode);
-struct ima_iint_cache *ima_iint_find_get(struct inode *inode);
-void iint_free(struct kref *kref);
+struct ima_iint_cache *ima_iint_find(struct inode *inode);
 
 /* IMA policy related functions */
 enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 0936a71..969a1c1 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -53,24 +53,26 @@ static struct ima_iint_cache *__ima_iint_find(struct inode *inode)
 }
 
 /*
- * ima_iint_find_get - return the iint associated with an inode
- *
- * ima_iint_find_get gets a reference to the iint. Caller must
- * remember to put the iint reference.
+ * ima_iint_find - return the iint associated with an inode
  */
-struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
+struct ima_iint_cache *ima_iint_find(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
 	spin_lock(&ima_iint_lock);
 	iint = __ima_iint_find(inode);
-	if (iint)
-		kref_get(&iint->refcount);
 	spin_unlock(&ima_iint_lock);
 
 	return iint;
 }
 
+static void iint_free(struct ima_iint_cache *iint)
+{
+	iint->version = 0;
+	iint->flags = 0UL;
+	kmem_cache_free(iint_cache, iint);
+}
+
 /**
  * ima_inode_alloc - allocate an iint associated with an inode
  * @inode: pointer to the inode
@@ -113,19 +115,9 @@ int ima_inode_alloc(struct inode *inode)
 	return 0;
 out_err:
 	spin_unlock(&ima_iint_lock);
-	kref_put(&new_iint->refcount, iint_free);
-	return rc;
-}
+	iint_free(new_iint);
 
-/* iint_free - called when the iint refcount goes to zero */
-void iint_free(struct kref *kref)
-{
-	struct ima_iint_cache *iint = container_of(kref, struct ima_iint_cache,
-						   refcount);
-	iint->version = 0;
-	iint->flags = 0UL;
-	kref_init(&iint->refcount);
-	kmem_cache_free(iint_cache, iint);
+	return rc;
 }
 
 /**
@@ -148,8 +140,11 @@ void ima_inode_free(struct inode *inode)
 	if (iint)
 		rb_erase(&iint->rb_node, &ima_iint_tree);
 	spin_unlock(&ima_iint_lock);
-	if (iint)
-		kref_put(&iint->refcount, iint_free);
+
+	if (!iint)
+		return;
+
+	iint_free(iint);
 }
 
 static void init_once(void *foo)
@@ -160,7 +155,6 @@ static void init_once(void *foo)
 	iint->version = 0;
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
-	kref_init(&iint->refcount);
 }
 
 static int __init ima_iintcache_init(void)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 5e3229c..1dccafe 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -186,8 +186,6 @@ static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
 
 	spin_unlock(&inode->i_lock);
 	mutex_unlock(&iint->mutex);
-
-	kref_put(&iint->refcount, iint_free);
 }
 
 static void ima_file_free_noiint(struct inode *inode, struct file *file)
@@ -213,7 +211,7 @@ void ima_file_free(struct file *file)
 
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
-	iint = ima_iint_find_get(inode);
+	iint = ima_iint_find(inode);
 
 	if (iint)
 		ima_file_free_iint(iint, inode, file);
@@ -236,7 +234,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 	if (rc != 0)
 		return rc;
 retry:
-	iint = ima_iint_find_get(inode);
+	iint = ima_iint_find(inode);
 	if (!iint) {
 		rc = ima_inode_alloc(inode);
 		if (!rc || rc == -EEXIST)
@@ -255,7 +253,6 @@ retry:
 		ima_store_measurement(iint, file, filename);
 out:
 	mutex_unlock(&iint->mutex);
-	kref_put(&iint->refcount, iint_free);
 	return rc;
 }
 

