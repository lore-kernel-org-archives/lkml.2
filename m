Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0JSW7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0JSW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:40 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/6] IMA: use unsigned int instead of long for counters
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:26 -0400
Message-ID: <20101019225826.12396.52631.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IMA uses 2 longs in struct inode.  To save space (and as it seems
impossible to overflow 32 bits) we switch these to unsigned int.  The
switch to unsigned does require slightly different checks for underflow,
but it isn't complex.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fs.h                |    4 ++--
 security/integrity/ima/ima_iint.c |    4 ++--
 security/integrity/ima/ima_main.c |   15 ++++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 593bb4d..8f46e5b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -778,8 +778,8 @@ struct inode {
 #endif
 #ifdef CONFIG_IMA
 	/* all protected by i_mutex */
-	long			i_readers; /* struct files open RO */
-	long			i_writers; /* struct files open WR */
+	unsigned int		i_readers; /* struct files open RO */
+	unsigned int		i_writers; /* struct files open WR */
 #endif
 #ifdef CONFIG_FS_POSIX_ACL
 	struct posix_acl	*i_acl;
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 2dc32d6..d327840 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -76,9 +76,9 @@ out:
 void ima_check_counters(struct inode *inode)
 {
 	if (inode->i_readers)
-		printk(KERN_INFO "%s: readcount: %ld\n", __func__, inode->i_readers);
+		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readers);
 	if (inode->i_writers)
-		printk(KERN_INFO "%s: writers: %ld\n", __func__, inode->i_writers);
+		printk(KERN_INFO "%s: writers: %u\n", __func__, inode->i_writers);
 
 	inode->i_readers = 0;
 	inode->i_writers = 0;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 92235a0..68ecb43 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -181,12 +181,19 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 			   struct file *file)
 {
 	mode_t mode = file->f_mode;
+	bool dump = false;
+
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
+		if (unlikely(inode->i_readers == 0))
+			dump = true;
 		inode->i_readers--;
+	}
 	if (mode & FMODE_WRITE) {
+		if (unlikely(inode->i_writers == 0))
+			dump = true;
 		inode->i_writers--;
 		if (inode->i_writers == 0) {
 			if (iint->version != inode->i_version)
@@ -194,10 +201,8 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		}
 	}
 
-	if (((inode->i_readers < 0) ||
-	     (inode->i_writers < 0)) &&
-	    !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld)\n",
+	if (dump && !ima_limit_imbalance(file)) {
+		printk(KERN_INFO "%s: open/free imbalance (r:%u w:%u)\n",
 		       __func__, inode->i_readers, inode->i_writers);
 		dump_stack();
 	}

