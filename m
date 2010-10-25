Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab0JYSm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:42:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0JYSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:42:55 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 02/11] IMA: drop the inode opencount since it isn't needed for
	operation
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:26 -0400
Message-ID: <20101025184126.20504.77463.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opencount was used to help debugging to make sure that everything which
created a struct file also correctly made the IMA calls.  Since we moved
all of that into the VFS this isn't as necessary.  We should be able to get
the same amount of debugging out of just the reader and write count.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h      |    1 -
 security/integrity/ima/ima_iint.c |    6 ------
 security/integrity/ima/ima_main.c |   10 +++-------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 7557791..3d70108 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -108,7 +108,6 @@ struct ima_iint_cache {
 	struct mutex mutex;	/* protects: version, flags, digest */
 	long readcount;		/* measured files readcount */
 	long writecount;	/* measured files writecount */
-	long opencount;		/* opens reference count */
 	struct kref refcount;	/* ima_iint_cache reference count */
 };
 
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 8395f0f..8e64313 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -134,11 +134,6 @@ void iint_free(struct kref *kref)
 		       iint->writecount);
 		iint->writecount = 0;
 	}
-	if (iint->opencount != 0) {
-		printk(KERN_INFO "%s: opencount: %ld\n", __func__,
-		       iint->opencount);
-		iint->opencount = 0;
-	}
 	kref_init(&iint->refcount);
 	kmem_cache_free(iint_cache, iint);
 }
@@ -172,7 +167,6 @@ static void init_once(void *foo)
 	mutex_init(&iint->mutex);
 	iint->readcount = 0;
 	iint->writecount = 0;
-	iint->opencount = 0;
 	kref_init(&iint->refcount);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e662b89..995bd1b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -122,7 +122,6 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
 {
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 
-	iint->opencount++;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		iint->readcount++;
 	if (mode & FMODE_WRITE)
@@ -181,7 +180,6 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	mode_t mode = file->f_mode;
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 
-	iint->opencount--;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		iint->readcount--;
 	if (mode & FMODE_WRITE) {
@@ -192,13 +190,11 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		}
 	}
 
-	if (((iint->opencount < 0) ||
-	     (iint->readcount < 0) ||
+	if (((iint->readcount < 0) ||
 	     (iint->writecount < 0)) &&
 	    !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld o:%ld)\n",
-		       __func__, iint->readcount, iint->writecount,
-		       iint->opencount);
+		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld)\n",
+		       __func__, iint->readcount, iint->writecount);
 		dump_stack();
 	}
 }

