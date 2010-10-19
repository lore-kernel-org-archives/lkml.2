Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0JSXAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:00:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0JSW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:59 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 6/6] IMA: use i_writecount rather than a private counter
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:46 -0400
Message-ID: <20101019225846.12396.34131.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA tracks the number of struct files which are holding a given inode
readonly and the number white are holding the inode write or r/w.  It needs
this information so when a new reader or writer comes in it can tell if
this new file will be able to invalidate results it already made about
existing files.

aka if a task is holding a struct file open RO, IMA measured the file and
recorded those measurements and then a task opens the file RW IMA needs to
note in the logs that the old measurement may not be correct.  It's called
a "Time of Measure Time of Use" (ToMToU) issue.  The same is true is a RO
file is opened to an inode which has an open writer.  We cannot, with any
validity, measure the file in question since it could be changing.

This patch attempts to use the i_writecount field to track writers.  The
i_writecount field actually embeds more information in it's value that IMA
needs but it should work for our purposes and allow us to shrink the struct
inode even more.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fs.h                |    3 -
 security/integrity/ima/ima_iint.c |    3 -
 security/integrity/ima/ima_main.c |   95 +++++++++++++------------------------
 3 files changed, 34 insertions(+), 67 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8f46e5b..5dbbf6b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -777,9 +777,8 @@ struct inode {
 	void			*i_security;
 #endif
 #ifdef CONFIG_IMA
-	/* all protected by i_mutex */
+	/* all protected by i_lock */
 	unsigned int		i_readers; /* struct files open RO */
-	unsigned int		i_writers; /* struct files open WR */
 #endif
 #ifdef CONFIG_FS_POSIX_ACL
 	struct posix_acl	*i_acl;
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index bef6e8f..6e82324 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -118,11 +118,8 @@ void ima_check_counters(struct inode *inode)
 {
 	if (inode->i_readers)
 		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readers);
-	if (inode->i_writers)
-		printk(KERN_INFO "%s: writers: %u\n", __func__, inode->i_writers);
 
 	inode->i_readers = 0;
-	inode->i_writers = 0;
 }
 
 /* iint_free - called when the iint refcount goes to zero */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 860e161..668ea93 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -85,48 +85,15 @@ out:
 	return found;
 }
 
-/* ima_read_write_check - reflect possible reading/writing errors in the PCR.
- *
- * When opening a file for read, if the file is already open for write,
- * the file could change, resulting in a file measurement error.
- *
- * Opening a file for write, if the file is already open for read, results
- * in a time of measure, time of use (ToMToU) error.
- *
- * In either case invalidate the PCR.
- */
-enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
-static void ima_read_write_check(enum iint_pcr_error error,
-				 struct inode *inode,
-				 const unsigned char *filename)
-{
-	BUG_ON(!mutex_is_locked(&inode->i_mutex));
-
-	switch (error) {
-	case TOMTOU:
-		if (inode->i_readers > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "ToMToU");
-		break;
-	case OPEN_WRITERS:
-		if (inode->i_writers > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "open_writers");
-		break;
-	}
-}
-
 /*
  * Update the counts given an fmode_t
  */
 static void ima_inc_counts(struct inode *inode, fmode_t mode)
 {
-	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		inode->i_readers++;
-	if (mode & FMODE_WRITE)
-		inode->i_writers++;
 }
 
 /*
@@ -146,11 +113,12 @@ void ima_counts_get(struct file *file)
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
 	int rc;
+	bool send_tomtou = false, send_writers = false;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return;
 
-	mutex_lock(&inode->i_mutex);
+	spin_lock(&inode->i_lock);
 
 	if (!ima_initialized)
 		goto out;
@@ -160,13 +128,23 @@ void ima_counts_get(struct file *file)
 		goto out;
 
 	if (mode & FMODE_WRITE) {
-		ima_read_write_check(TOMTOU, inode, dentry->d_name.name);
+		if (inode->i_readers)
+			send_tomtou = true;
 		goto out;
 	}
-	ima_read_write_check(OPEN_WRITERS, inode, dentry->d_name.name);
+
+	if (atomic_read(&inode->i_writecount) > 0)
+		send_writers = true;
 out:
 	ima_inc_counts(inode, file->f_mode);
-	mutex_unlock(&inode->i_mutex);
+	spin_unlock(&inode->i_lock);
+
+	if (send_tomtou)
+		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
+				  "ToMToU");
+	if (send_writers)
+		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
+				  "open_writers");
 }
 
 /*
@@ -175,25 +153,18 @@ out:
 static void ima_dec_counts(struct inode *inode, struct file *file)
 {
 	mode_t mode = file->f_mode;
-	bool dump = false;
 
-	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
-		if (unlikely(inode->i_readers == 0))
-			dump = true;
-		inode->i_readers--;
-	}
-	if (mode & FMODE_WRITE) {
-		if (unlikely(inode->i_writers == 0))
-			dump = true;
-		inode->i_writers--;
-	}
-
-	if (dump && !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%u w:%u)\n",
-		       __func__, inode->i_readers, inode->i_writers);
-		dump_stack();
+		if (unlikely(inode->i_readers == 0) &&
+		    !ima_limit_imbalance(file)) {
+			printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
+			       __func__, inode->i_readers);
+			dump_stack();
+		} else {
+			inode->i_readers--;
+		}
 	}
 }
 
@@ -204,10 +175,10 @@ static void ima_check_last_writer(struct ima_iint_cache *iint,
 	mode_t mode = file->f_mode;
 
 	BUG_ON(!mutex_is_locked(&iint->mutex));
-	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+	assert_spin_locked(&inode->i_lock);
 
 	if (mode & FMODE_WRITE &&
-	    inode->i_writers == 0 &&
+	    atomic_read(&inode->i_writecount) <= 0 &&
 	    iint->version != inode->i_version)
 		iint->flags &= ~IMA_MEASURED;
 }
@@ -216,12 +187,12 @@ static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
 			       struct file *file)
 {
 	mutex_lock(&iint->mutex);
-	mutex_lock(&inode->i_mutex);
+	spin_lock(&inode->i_lock);
 
 	ima_dec_counts(inode, file);
 	ima_check_last_writer(iint, inode, file);
 
-	mutex_unlock(&inode->i_mutex);
+	spin_unlock(&inode->i_lock);
 	mutex_unlock(&iint->mutex);
 
 	kref_put(&iint->refcount, iint_free);
@@ -229,11 +200,11 @@ static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
 
 static void ima_file_free_noiint(struct inode *inode, struct file *file)
 {
-	mutex_lock(&inode->i_mutex);
+	spin_lock(&inode->i_lock);
 
 	ima_dec_counts(inode, file);
 
-	mutex_unlock(&inode->i_mutex);
+	spin_unlock(&inode->i_lock);
 }
 
 /**
@@ -241,7 +212,7 @@ static void ima_file_free_noiint(struct inode *inode, struct file *file)
  * @file: pointer to file structure being freed
  *
  * Flag files that changed, based on i_version;
- * and decrement the i_readers/i_writers.
+ * and decrement the i_readers.
  */
 void ima_file_free(struct file *file)
 {

