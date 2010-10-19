Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0JSW7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:59:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0JSW7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:43 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/6] IMA: only allocate iint when needed
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:33 -0400
Message-ID: <20101019225833.12396.56721.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
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
the integrity stucture until it is needed.  Thurs greatly reducing memory
usage.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/ima.h               |    6 ---
 security/integrity/ima/ima.h      |    1 
 security/integrity/ima/ima_api.c  |    2 -
 security/integrity/ima/ima_iint.c |    4 --
 security/integrity/ima/ima_main.c |   87 ++++++++++++++++++++++++++-----------
 security/security.c               |    4 --
 6 files changed, 65 insertions(+), 39 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 1c4bdb9..72644a5 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -15,7 +15,6 @@ struct linux_binprm;
 
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
-extern int ima_inode_alloc(struct inode *inode);
 extern void ima_inode_free(struct inode *inode);
 extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
@@ -29,11 +28,6 @@ static inline int ima_bprm_check(struct linux_binprm *bprm)
 	return 0;
 }
 
-static inline int ima_inode_alloc(struct inode *inode)
-{
-	return 0;
-}
-
 static inline void ima_inode_free(struct inode *inode)
 {
 	return;
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e500fe3..0767717 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -70,6 +70,7 @@ int ima_init(void);
 void ima_cleanup(void);
 int ima_fs_init(void);
 void ima_fs_cleanup(void);
+int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode);
 int ima_calc_hash(struct file *file, char *digest);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 52015d0..44f779f 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -116,7 +116,7 @@ int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
 {
 	int must_measure;
 
-	if (iint->flags & IMA_MEASURED)
+	if (iint && (iint->flags & IMA_MEASURED))
 		return 1;
 
 	must_measure = ima_match_policy(inode, function, mask);
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index d327840..0bab052 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -123,9 +123,7 @@ static void init_once(void *foo)
 {
 	struct ima_iint_cache *iint = foo;
 
-	memset(iint, 0, sizeof *iint);
-	iint->version = 0;
-	iint->flags = 0UL;
+	memset(iint, 0, sizeof(*iint));
 	mutex_init(&iint->mutex);
 	kref_init(&iint->refcount);
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 68ecb43..860e161 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -145,19 +145,17 @@ void ima_counts_get(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
-	struct ima_iint_cache *iint;
 	int rc;
 
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
-	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return;
-	mutex_lock(&iint->mutex);
+
 	mutex_lock(&inode->i_mutex);
+
 	if (!ima_initialized)
 		goto out;
-	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
+
+	rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
 	if (rc < 0)
 		goto out;
 
@@ -169,21 +167,16 @@ void ima_counts_get(struct file *file)
 out:
 	ima_inc_counts(inode, file->f_mode);
 	mutex_unlock(&inode->i_mutex);
-	mutex_unlock(&iint->mutex);
-
-	kref_put(&iint->refcount, iint_free);
 }
 
 /*
  * Decrement ima counts
  */
-static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
-			   struct file *file)
+static void ima_dec_counts(struct inode *inode, struct file *file)
 {
 	mode_t mode = file->f_mode;
 	bool dump = false;
 
-	BUG_ON(!mutex_is_locked(&iint->mutex));
 	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
@@ -195,10 +188,6 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		if (unlikely(inode->i_writers == 0))
 			dump = true;
 		inode->i_writers--;
-		if (inode->i_writers == 0) {
-			if (iint->version != inode->i_version)
-				iint->flags &= ~IMA_MEASURED;
-		}
 	}
 
 	if (dump && !ima_limit_imbalance(file)) {
@@ -208,6 +197,45 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	}
 }
 
+static void ima_check_last_writer(struct ima_iint_cache *iint,
+				  struct inode *inode,
+				  struct file *file)
+{
+	mode_t mode = file->f_mode;
+
+	BUG_ON(!mutex_is_locked(&iint->mutex));
+	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+
+	if (mode & FMODE_WRITE &&
+	    inode->i_writers == 0 &&
+	    iint->version != inode->i_version)
+		iint->flags &= ~IMA_MEASURED;
+}
+
+static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
+			       struct file *file)
+{
+	mutex_lock(&iint->mutex);
+	mutex_lock(&inode->i_mutex);
+
+	ima_dec_counts(inode, file);
+	ima_check_last_writer(iint, inode, file);
+
+	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&iint->mutex);
+
+	kref_put(&iint->refcount, iint_free);
+}
+
+static void ima_file_free_noiint(struct inode *inode, struct file *file)
+{
+	mutex_lock(&inode->i_mutex);
+
+	ima_dec_counts(inode, file);
+
+	mutex_unlock(&inode->i_mutex);
+}
+
 /**
  * ima_file_free - called on __fput()
  * @file: pointer to file structure being freed
@@ -223,15 +251,12 @@ void ima_file_free(struct file *file)
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return;
 
-	mutex_lock(&iint->mutex);
-	mutex_lock(&inode->i_mutex);
-	ima_dec_counts(iint, inode, file);
-	mutex_unlock(&iint->mutex);
-	mutex_unlock(&inode->i_mutex);
-	kref_put(&iint->refcount, iint_free);
+	if (iint)
+		ima_file_free_iint(iint, inode, file);
+	else
+		ima_file_free_noiint(inode, file);
+
 }
 
 static int process_measurement(struct file *file, const unsigned char *filename,
@@ -243,11 +268,21 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 
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
index ad5ca29..04c098d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -331,9 +331,7 @@ int security_inode_alloc(struct inode *inode)
 	ret =  security_ops->inode_alloc_security(inode);
 	if (ret)
 		return ret;
-	ret = ima_inode_alloc(inode);
-	if (ret)
-		security_inode_free(inode);
+
 	return ret;
 }
 

