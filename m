Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab0J1WCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:02:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55680 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377Ab0J1WCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:02:31 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3/4] IMA: remove IMA imbalance checking
Date: Thu, 28 Oct 2010 18:02:04 -0400
Message-Id: <1288303325-9628-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that i_readcount is maintained by the VFS layer, remove the
imbalance checking in IMA. Cleans up the IMA code nicely.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima_iint.c |    3 -
 security/integrity/ima/ima_main.c |  104 +++----------------------------------
 2 files changed, 8 insertions(+), 99 deletions(-)

diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index c4e381a..4ae7304 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -137,9 +137,6 @@ void ima_inode_free(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
-	if (inode->i_readcount)
-		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readcount);
-
 	if (!IS_IMA(inode))
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index ce2cd73..8af21e3 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -36,55 +36,6 @@ static int __init hash_setup(char *str)
 }
 __setup("ima_hash=", hash_setup);
 
-struct ima_imbalance {
-	struct hlist_node node;
-	unsigned long fsmagic;
-};
-
-/*
- * ima_limit_imbalance - emit one imbalance message per filesystem type
- *
- * Maintain list of filesystem types that do not measure files properly.
- * Return false if unknown, true if known.
- */
-static bool ima_limit_imbalance(struct file *file)
-{
-	static DEFINE_SPINLOCK(ima_imbalance_lock);
-	static HLIST_HEAD(ima_imbalance_list);
-
-	struct super_block *sb = file->f_dentry->d_sb;
-	struct ima_imbalance *entry;
-	struct hlist_node *node;
-	bool found = false;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(entry, node, &ima_imbalance_list, node) {
-		if (entry->fsmagic == sb->s_magic) {
-			found = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	if (found)
-		goto out;
-
-	entry = kmalloc(sizeof(*entry), GFP_NOFS);
-	if (!entry)
-		goto out;
-	entry->fsmagic = sb->s_magic;
-	spin_lock(&ima_imbalance_lock);
-	/*
-	 * we could have raced and something else might have added this fs
-	 * to the list, but we don't really care
-	 */
-	hlist_add_head_rcu(&entry->node, &ima_imbalance_list);
-	spin_unlock(&ima_imbalance_lock);
-	printk(KERN_INFO "IMA: unmeasured files on fsmagic: %lX\n",
-	       entry->fsmagic);
-out:
-	return found;
-}
-
 /*
  * ima_rdwr_violation_check
  *
@@ -131,27 +82,6 @@ out:
 				  "open_writers");
 }
 
-/*
- * Decrement ima counts
- */
-static void ima_dec_counts(struct inode *inode, struct file *file)
-{
-	mode_t mode = file->f_mode;
-
-	assert_spin_locked(&inode->i_lock);
-
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
-		if (unlikely(inode->i_readcount == 0)) {
-			if (!ima_limit_imbalance(file)) {
-				printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
-				       __func__, inode->i_readcount);
-				dump_stack();
-			}
-			return;
-		}
-	}
-}
-
 static void ima_check_last_writer(struct ima_iint_cache *iint,
 				  struct inode *inode,
 				  struct file *file)
@@ -167,28 +97,6 @@ static void ima_check_last_writer(struct ima_iint_cache *iint,
 		iint->flags &= ~IMA_MEASURED;
 }
 
-static void ima_file_free_iint(struct ima_iint_cache *iint, struct inode *inode,
-			       struct file *file)
-{
-	mutex_lock(&iint->mutex);
-	spin_lock(&inode->i_lock);
-
-	ima_dec_counts(inode, file);
-	ima_check_last_writer(iint, inode, file);
-
-	spin_unlock(&inode->i_lock);
-	mutex_unlock(&iint->mutex);
-}
-
-static void ima_file_free_noiint(struct inode *inode, struct file *file)
-{
-	spin_lock(&inode->i_lock);
-
-	ima_dec_counts(inode, file);
-
-	spin_unlock(&inode->i_lock);
-}
-
 /**
  * ima_file_free - called on __fput()
  * @file: pointer to file structure being freed
@@ -204,12 +112,16 @@ void ima_file_free(struct file *file)
 		return;
 
 	iint = ima_iint_find(inode);
+	if (!iint)
+		return;
 
-	if (iint)
-		ima_file_free_iint(iint, inode, file);
-	else
-		ima_file_free_noiint(inode, file);
+	mutex_lock(&iint->mutex);
+	spin_lock(&inode->i_lock);
+
+	ima_check_last_writer(iint, inode, file);
 
+	spin_unlock(&inode->i_lock);
+	mutex_unlock(&iint->mutex);
 }
 
 static int process_measurement(struct file *file, const unsigned char *filename,
-- 
1.7.2.2

