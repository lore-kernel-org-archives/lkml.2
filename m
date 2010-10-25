Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab0JYSpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab0JYSmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:42:51 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 03/11] IMA: use unsigned int instead of long for counters
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:32 -0400
Message-ID: <20101025184132.20504.2026.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
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
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h      |    4 ++--
 security/integrity/ima/ima_iint.c |    4 ++--
 security/integrity/ima/ima_main.c |   15 ++++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3d70108..000d13a 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -106,8 +106,8 @@ struct ima_iint_cache {
 	unsigned long flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
-	long readcount;		/* measured files readcount */
-	long writecount;	/* measured files writecount */
+	unsigned int readcount;	/* measured files readcount */
+	unsigned int writecount;/* measured files writecount */
 	struct kref refcount;	/* ima_iint_cache reference count */
 };
 
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 8e64313..db71a13 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -125,12 +125,12 @@ void iint_free(struct kref *kref)
 	iint->version = 0;
 	iint->flags = 0UL;
 	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %ld\n", __func__,
+		printk(KERN_INFO "%s: readcount: %u\n", __func__,
 		       iint->readcount);
 		iint->readcount = 0;
 	}
 	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %ld\n", __func__,
+		printk(KERN_INFO "%s: writecount: %u\n", __func__,
 		       iint->writecount);
 		iint->writecount = 0;
 	}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 995bd1b..5a1bf3d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -178,11 +178,18 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 			   struct file *file)
 {
 	mode_t mode = file->f_mode;
+	bool dump = false;
+
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
+		if (unlikely(iint->readcount == 0))
+			dump = true;
 		iint->readcount--;
+	}
 	if (mode & FMODE_WRITE) {
+		if (unlikely(iint->writecount == 0))
+			dump = true;
 		iint->writecount--;
 		if (iint->writecount == 0) {
 			if (iint->version != inode->i_version)
@@ -190,10 +197,8 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 		}
 	}
 
-	if (((iint->readcount < 0) ||
-	     (iint->writecount < 0)) &&
-	    !ima_limit_imbalance(file)) {
-		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld)\n",
+	if (dump && !ima_limit_imbalance(file)) {
+		printk(KERN_INFO "%s: open/free imbalance (r:%u w:%u)\n",
 		       __func__, iint->readcount, iint->writecount);
 		dump_stack();
 	}

