Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab0JYSnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab0JYSnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:16 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 05/11] IMA: use inode->i_lock to protect read and write
	counters
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:45 -0400
Message-ID: <20101025184145.20504.25275.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IMA used the iint->mutex to protect the i_readcount and
i_writecount.  This patch uses the inode->i_lock since we are going to
start using in inode objects and that is the most appropriate lock.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h      |    1 +
 security/integrity/ima/ima_main.c |   57 +++++++++++++++----------------------
 2 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f7af011..80aca3d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -106,6 +106,7 @@ struct ima_iint_cache {
 	unsigned char flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
+	/* protected by inode->i_lock */
 	unsigned int readcount;	/* measured files readcount */
 	unsigned int writecount;/* measured files writecount */
 	struct kref refcount;	/* ima_iint_cache reference count */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 5a1bf3d..2f9b5d5 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -85,42 +85,12 @@ out:
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
-				 struct ima_iint_cache *iint,
-				 struct inode *inode,
-				 const unsigned char *filename)
-{
-	switch (error) {
-	case TOMTOU:
-		if (iint->readcount > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "ToMToU");
-		break;
-	case OPEN_WRITERS:
-		if (iint->writecount > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "open_writers");
-		break;
-	}
-}
-
 /*
  * Update the counts given an fmode_t
  */
 static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
 {
-	BUG_ON(!mutex_is_locked(&iint->mutex));
+	assert_spin_locked(&iint->inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		iint->readcount++;
@@ -146,6 +116,7 @@ void ima_counts_get(struct file *file)
 	fmode_t mode = file->f_mode;
 	struct ima_iint_cache *iint;
 	int rc;
+	bool send_tomtou = false, send_writers = false;
 
 	if (!iint_initialized || !S_ISREG(inode->i_mode))
 		return;
@@ -153,22 +124,35 @@ void ima_counts_get(struct file *file)
 	if (!iint)
 		return;
 	mutex_lock(&iint->mutex);
+	spin_lock(&inode->i_lock);
+
 	if (!ima_initialized)
 		goto out;
+
 	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
 	if (rc < 0)
 		goto out;
 
 	if (mode & FMODE_WRITE) {
-		ima_read_write_check(TOMTOU, iint, inode, dentry->d_name.name);
+		if (iint->readcount)
+			send_tomtou = true;
 		goto out;
 	}
-	ima_read_write_check(OPEN_WRITERS, iint, inode, dentry->d_name.name);
+
+	if (atomic_read(&inode->i_writecount) > 0)
+		send_writers = true;
 out:
 	ima_inc_counts(iint, file->f_mode);
+	spin_unlock(&inode->i_lock);
 	mutex_unlock(&iint->mutex);
-
 	kref_put(&iint->refcount, iint_free);
+
+	if (send_tomtou)
+		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
+				  "ToMToU");
+	if (send_writers)
+		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
+				  "open_writers");
 }
 
 /*
@@ -181,6 +165,7 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	bool dump = false;
 
 	BUG_ON(!mutex_is_locked(&iint->mutex));
+	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
 		if (unlikely(iint->readcount == 0))
@@ -223,7 +208,11 @@ void ima_file_free(struct file *file)
 		return;
 
 	mutex_lock(&iint->mutex);
+	spin_lock(&inode->i_lock);
+
 	ima_dec_counts(iint, inode, file);
+
+	spin_unlock(&inode->i_lock);
 	mutex_unlock(&iint->mutex);
 	kref_put(&iint->refcount, iint_free);
 }

