Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab0JYSnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0JYSnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:02 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 08/11] IMA: only allocate iint when needed
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:42:05 -0400
Message-ID: <20101025184205.20504.74605.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA always allocates an integrity structure to hold information about every
inode, but only needed this structure to tract the number of readers and
writers currently accessing a given inode.  Since that information was moved
into struct inode instead of the integrity struct this patch stops allocating
the integrity stucture until it is needed.  Thus greatly reducing memory usage.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima_main.c |   94 +++++++++++++++++++++++++------------
 security/security.c               |   10 ----
 2 files changed, 65 insertions(+), 39 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2a77b14..5e3229c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -141,33 +141,62 @@ out:
 /*
  * Decrement ima counts
  */
-static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
-			   struct file *file)
+static void ima_dec_counts(struct inode *inode, struct file *file)
 {
 	mode_t mode = file->f_mode;
-	bool dump = false;
 
-	BUG_ON(!mutex_is_locked(&iint->mutex));
 	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
-		if (unlikely(inode->i_readcount == 0))
-			dump = true;
+		if (unlikely(inode->i_readcount == 0)) {
+			if (!ima_limit_imbalance(file)) {
+				printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
+				       __func__, inode->i_readcount);
+				dump_stack();
+			}
+			return;
+		}
 		inode->i_readcount--;
 	}
-	if (mode & FMODE_WRITE) {
-		if (atomic_read(&inode->i_writecount) <= 0)
-			dump = true;
-		if (atomic_read(&inode->i_writecount) == 1 &&
-		    iint->version != inode->i_version)
-			iint->flags &= ~IMA_MEASURED;
-	}
+}
 
-	if (dump && !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
-		       __func__, inode->i_readcount);
-		dump_stack();
-	}
+static void ima_check_last_writer(struct ima_iint_cache *iint,
+				  struct inode *inode,
+				  struct file *file)
+{
+	mode_t mode = file->f_mode;
+
+	BUG_ON(!mutex_is_locked(&iint->mutex));
+	assert_spin_locked(&inode->i_lock);
+
+	if (mode & FMODE_WRITE &&
+	    atomic_read(&inode->i_writecount) == 1 &&
+	    iint->version != inode->i_version)
+		iint->flags &= ~IMA_MEASURED;
+}
+
+static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
+			       struct file *file)
+{
+	mutex_lock(&iint->mutex);
+	spin_lock(&inode->i_lock);
+
+	ima_dec_counts(inode, file);
+	ima_check_last_writer(iint, inode, file);
+
+	spin_unlock(&inode->i_lock);
+	mutex_unlock(&iint->mutex);
+
+	kref_put(&iint->refcount, iint_free);
+}
+
+static void ima_file_free_noiint(struct inode *inode, struct file *file)
+{
+	spin_lock(&inode->i_lock);
+
+	ima_dec_counts(inode, file);
+
+	spin_unlock(&inode->i_lock);
 }
 
 /**
@@ -175,7 +204,7 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
  * @file: pointer to file structure being freed
  *
  * Flag files that changed, based on i_version;
- * and decrement the iint readcount/writecount.
+ * and decrement the i_readcount.
  */
 void ima_file_free(struct file *file)
 {
@@ -185,17 +214,12 @@ void ima_file_free(struct file *file)
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return;
 
-	mutex_lock(&iint->mutex);
-	spin_lock(&inode->i_lock);
-
-	ima_dec_counts(iint, inode, file);
+	if (iint)
+		ima_file_free_iint(iint, inode, file);
+	else
+		ima_file_free_noiint(inode, file);
 
-	spin_unlock(&inode->i_lock);
-	mutex_unlock(&iint->mutex);
-	kref_put(&iint->refcount, iint_free);
 }
 
 static int process_measurement(struct file *file, const unsigned char *filename,
@@ -207,11 +231,21 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
+
+	rc = ima_must_measure(NULL, inode, mask, function);
+	if (rc != 0)
+		return rc;
+retry:
 	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return -ENOMEM;
+	if (!iint) {
+		rc = ima_inode_alloc(inode);
+		if (!rc || rc == -EEXIST)
+			goto retry;
+		return rc;
+	}
 
 	mutex_lock(&iint->mutex);
+
 	rc = ima_must_measure(iint, inode, mask, function);
 	if (rc != 0)
 		goto out;
diff --git a/security/security.c b/security/security.c
index ad5ca29..259d3ad 100644
--- a/security/security.c
+++ b/security/security.c
@@ -325,16 +325,8 @@ EXPORT_SYMBOL(security_sb_parse_opts_str);
 
 int security_inode_alloc(struct inode *inode)
 {
-	int ret;
-
 	inode->i_security = NULL;
-	ret =  security_ops->inode_alloc_security(inode);
-	if (ret)
-		return ret;
-	ret = ima_inode_alloc(inode);
-	if (ret)
-		security_inode_free(inode);
-	return ret;
+	return security_ops->inode_alloc_security(inode);
 }
 
 void security_inode_free(struct inode *inode)

