Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0JSW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0JSW7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:33 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/6] IMA: drop the inode opencount since it isn't needed for
	operation
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:19 -0400
Message-ID: <20101019225819.12396.50299.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opencount was used to help depugging to make sure that everything which
created a struct file also correctly made the IMA calls.  Since we moved
all of that into the VFS this isn't as necessary.  We should be able to get
the same amount of debugging out of just the reader and write count.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fs.h                |    1 -
 security/integrity/ima/ima_iint.c |    3 ---
 security/integrity/ima/ima_main.c |   10 +++-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a402b3..593bb4d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -780,7 +780,6 @@ struct inode {
 	/* all protected by i_mutex */
 	long			i_readers; /* struct files open RO */
 	long			i_writers; /* struct files open WR */
-	long			i_opencount; /* total open files (readers + writers) */
 #endif
 #ifdef CONFIG_FS_POSIX_ACL
 	struct posix_acl	*i_acl;
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index c584938..2dc32d6 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -79,12 +79,9 @@ void ima_check_counters(struct inode *inode)
 		printk(KERN_INFO "%s: readcount: %ld\n", __func__, inode->i_readers);
 	if (inode->i_writers)
 		printk(KERN_INFO "%s: writers: %ld\n", __func__, inode->i_writers);
-	if (inode->i_opencount)
-		printk(KERN_INFO "%s: opencount: %ld\n", __func__, inode->i_opencount);
 
 	inode->i_readers = 0;
 	inode->i_writers = 0;
-	inode->i_opencount = 0;
 }
 
 /* iint_free - called when the iint refcount goes to zero */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a70700b..92235a0 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -123,7 +123,6 @@ static void ima_inc_counts(struct inode *inode, fmode_t mode)
 {
 	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
-	inode->i_opencount++;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		inode->i_readers++;
 	if (mode & FMODE_WRITE)
@@ -185,7 +184,6 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
-	inode->i_opencount--;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		inode->i_readers--;
 	if (mode & FMODE_WRITE) {
@@ -196,13 +194,11 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		}
 	}
 
-	if (((inode->i_opencount < 0) ||
-	     (inode->i_readers < 0) ||
+	if (((inode->i_readers < 0) ||
 	     (inode->i_writers < 0)) &&
 	    !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld o:%ld)\n",
-		       __func__, inode->i_readers, inode->i_writers,
-		       inode->i_opencount);
+		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld)\n",
+		       __func__, inode->i_readers, inode->i_writers);
 		dump_stack();
 	}
 }

