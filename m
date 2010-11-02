Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0KBRIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:08:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51350 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0KBRIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:08:38 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.2 1/5] IMA: convert i_readcount to atomic
Date: Tue,  2 Nov 2010 13:08:23 -0400
Message-Id: <1288717707-5295-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1288717707-5295-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288717707-5295-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the inode's i_readcount from an unsigned int to atomic.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/fs.h                |    3 +--
 security/integrity/ima/ima_iint.c |    7 ++++---
 security/integrity/ima/ima_main.c |   11 ++++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 334d68a..442fceb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -787,8 +787,7 @@ struct inode {
 	unsigned int		i_flags;
 
 #ifdef CONFIG_IMA
-	/* protected by i_lock */
-	unsigned int		i_readcount; /* struct files open RO */
+	atomic_t		i_readcount; /* struct files open RO */
 #endif
 	atomic_t		i_writecount;
 #ifdef CONFIG_SECURITY
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index c442e47..f005355 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -137,10 +137,11 @@ void ima_inode_free(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
-	if (inode->i_readcount)
-		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readcount);
+	if (atomic_read(&inode->i_readcount))
+		printk(KERN_INFO "%s: readcount: %u\n", __func__,
+		       atomic_read(&inode->i_readcount));
 
-	inode->i_readcount = 0;
+	atomic_set(&inode->i_readcount, 0);
 
 	if (!IS_IMA(inode))
 		return;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 203de97..a189197 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -113,7 +113,7 @@ void ima_counts_get(struct file *file)
 		goto out;
 
 	if (mode & FMODE_WRITE) {
-		if (inode->i_readcount && IS_IMA(inode))
+		if (atomic_read(&inode->i_readcount) && IS_IMA(inode))
 			send_tomtou = true;
 		goto out;
 	}
@@ -127,7 +127,7 @@ void ima_counts_get(struct file *file)
 out:
 	/* remember the vfs deals with i_writecount */
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		inode->i_readcount++;
+		atomic_inc(&inode->i_readcount);
 
 	spin_unlock(&inode->i_lock);
 
@@ -149,15 +149,16 @@ static void ima_dec_counts(struct inode *inode, struct file *file)
 	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
-		if (unlikely(inode->i_readcount == 0)) {
+	    	if (unlikely(atomic_read(&inode->i_readcount) == 0)) {
 			if (!ima_limit_imbalance(file)) {
 				printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
-				       __func__, inode->i_readcount);
+				       __func__,
+				       atomic_read(&inode->i_readcount));
 				dump_stack();
 			}
 			return;
 		}
-		inode->i_readcount--;
+		atomic_dec(&inode->i_readcount);
 	}
 }
 
-- 
1.7.2.2

