Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0CPEPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 00:15:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:44322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0CPEPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 00:15:00 -0400
From: NeilBrown <neilb@suse.de>
To: Greg KH <gregkh@suse.de>
Date: Tue, 16 Mar 2010 15:14:51 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19359.1467.612457.401272@notabene.brown>
Subject: [PATCH] kref: remove kref_set
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E "." Hallyn <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Of the three uses of kref_set in the kernel:

 One really should be kref_put as the code is letting go of a
    reference,
 Two really should be kref_init because the kref is being
    initialised.

This suggests that making kref_set available encourages bad code.
So fix the three uses and remove kref_set completely.

Signed-off-by: NeilBrown <neilb@suse.de>
--

The two 'kref_init' calls in ima_iint.c could equally be a single
call after the kmem_cache_alloc in ima_inode_alloc, but this version
was the minimal code change.


diff --git a/include/linux/kref.h b/include/linux/kref.h
index b0cb0eb..13003ee 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -21,7 +21,6 @@ struct kref {
 	atomic_t refcount;
 };
 
-void kref_set(struct kref *kref, int num);
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 076c7c8..b2d70d3 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -54,8 +54,8 @@ int create_user_ns(struct cred *new)
 #endif
 	/* tgcred will be cleared in our caller bc CLONE_THREAD won't be set */
 
-	/* alloc_uid() incremented the userns refcount.  Just set it to 1 */
-	kref_set(&ns->kref, 1);
+	/* root_user holds a reference to ns, our reference can be dropped */
+	put_user_ns(ns);
 
 	return 0;
 }
diff --git a/lib/kref.c b/lib/kref.c
index 9ecd6e8..69761d3 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -15,23 +15,13 @@
 #include <linux/module.h>
 
 /**
- * kref_set - initialize object and set refcount to requested number.
- * @kref: object in question.
- * @num: initial reference counter
- */
-void kref_set(struct kref *kref, int num)
-{
-	atomic_set(&kref->refcount, num);
-	smp_mb();
-}
-
-/**
  * kref_init - initialize object.
  * @kref: object in question.
  */
 void kref_init(struct kref *kref)
 {
-	kref_set(kref, 1);
+	atomic_set(&kref->refcount, 1);
+	smp_mb();
 }
 
 /**
@@ -71,7 +61,6 @@ int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 	return 0;
 }
 
-EXPORT_SYMBOL(kref_set);
 EXPORT_SYMBOL(kref_init);
 EXPORT_SYMBOL(kref_get);
 EXPORT_SYMBOL(kref_put);
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 2d4d05d..91c31d8 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -93,7 +93,7 @@ void iint_free(struct kref *kref)
 		       iint->opencount);
 		iint->opencount = 0;
 	}
-	kref_set(&iint->refcount, 1);
+	kref_init(&iint->refcount);
 	kmem_cache_free(iint_cache, iint);
 }
 
@@ -132,7 +132,7 @@ static void init_once(void *foo)
 	iint->readcount = 0;
 	iint->writecount = 0;
 	iint->opencount = 0;
-	kref_set(&iint->refcount, 1);
+	kref_init(&iint->refcount);
 }
 
 static int __init ima_iintcache_init(void)
