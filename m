Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0JYSoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411Ab0JYSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:04 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 06/11] IMA: use i_writecount rather than a private counter
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:52 -0400
Message-ID: <20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA tracks the number of struct files which are holding a given inode
readonly and the number which are holding the inode write or r/w.  It needs
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
i_writecount field actually embeds more information in it's value than IMA
needs but it should work for our purposes and allow us to shrink the struct
inode even more.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h      |    1 -
 security/integrity/ima/ima_iint.c |    6 ------
 security/integrity/ima/ima_main.c |   16 ++++++----------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 80aca3d..b546b90 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -108,7 +108,6 @@ struct ima_iint_cache {
 	struct mutex mutex;	/* protects: version, flags, digest */
 	/* protected by inode->i_lock */
 	unsigned int readcount;	/* measured files readcount */
-	unsigned int writecount;/* measured files writecount */
 	struct kref refcount;	/* ima_iint_cache reference count */
 };
 
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index db71a13..e68891f 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -129,11 +129,6 @@ void iint_free(struct kref *kref)
 		       iint->readcount);
 		iint->readcount = 0;
 	}
-	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %u\n", __func__,
-		       iint->writecount);
-		iint->writecount = 0;
-	}
 	kref_init(&iint->refcount);
 	kmem_cache_free(iint_cache, iint);
 }
@@ -166,7 +161,6 @@ static void init_once(void *foo)
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
 	iint->readcount = 0;
-	iint->writecount = 0;
 	kref_init(&iint->refcount);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2f9b5d5..24660bf 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -94,8 +94,6 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		iint->readcount++;
-	if (mode & FMODE_WRITE)
-		iint->writecount++;
 }
 
 /*
@@ -173,18 +171,16 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		iint->readcount--;
 	}
 	if (mode & FMODE_WRITE) {
-		if (unlikely(iint->writecount == 0))
+		if (atomic_read(&inode->i_writecount) <= 0)
 			dump = true;
-		iint->writecount--;
-		if (iint->writecount == 0) {
-			if (iint->version != inode->i_version)
-				iint->flags &= ~IMA_MEASURED;
-		}
+		if (atomic_read(&inode->i_writecount) == 1 &&
+		    iint->version != inode->i_version)
+			iint->flags &= ~IMA_MEASURED;
 	}
 
 	if (dump && !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%u w:%u)\n",
-		       __func__, iint->readcount, iint->writecount);
+		printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
+		       __func__, iint->readcount);
 		dump_stack();
 	}
 }

