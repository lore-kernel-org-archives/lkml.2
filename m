Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2F2PQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:16:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2F2POm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:42 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/11] UBI: Fastmap: Remove forward declaration
Date: Fri, 29 Jun 2012 17:14:21 +0200
Message-Id: <1340982869-77042-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |  186 ++++++++++++++++++++++------------------------
 1 files changed, 89 insertions(+), 97 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index f1dfb63..e88521b 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -89,15 +89,7 @@
 #include <linux/random.h>
 #include "ubi.h"
 
-/*
- * TODO: please, no forward declarations. We do not use them in UBI code.
- * Actually initially I did use them a lot, but when upstreaming, I was asked
- * to remove. Please, follow this convention as well. Please, change globally.
- * I mean, I am already used to that _all_ the code is upside-down, let's keep
- * it that way, or re-structure all the code. :-)
- */
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
-static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
 
 /* Temporary variables used during scanning */
 static struct ubi_ec_hdr *ech;
@@ -1132,6 +1124,95 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
 }
 
 /**
+ * destroy_av - free volume attaching information.
+ * @av: volume attaching information
+ * @ai: attaching information
+ *
+ * This function destroys the volume attaching information.
+ */
+static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
+{
+	struct ubi_ainf_peb *aeb;
+	struct rb_node *this = av->root.rb_node;
+
+	while (this) {
+		if (this->rb_left)
+			this = this->rb_left;
+		else if (this->rb_right)
+			this = this->rb_right;
+		else {
+			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
+			this = rb_parent(this);
+			if (this) {
+				if (this->rb_left == &aeb->u.rb)
+					this->rb_left = NULL;
+				else
+					this->rb_right = NULL;
+			}
+
+			kmem_cache_free(ai->aeb_slab_cache, aeb);
+		}
+	}
+	kfree(av);
+}
+
+/**
+ * destroy_ai - destroy attaching information.
+ * @ubi: UBI device object
+ * @ai: attaching information
+ */
+static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
+{
+	struct ubi_ainf_peb *aeb, *aeb_tmp;
+	struct ubi_ainf_volume *av;
+	struct rb_node *rb;
+
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->erase, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->corr, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+	list_for_each_entry_safe(aeb, aeb_tmp, &ai->free, u.list) {
+		list_del(&aeb->u.list);
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
+	}
+
+	/* Destroy the volume RB-tree */
+	rb = ai->volumes.rb_node;
+	while (rb) {
+		if (rb->rb_left)
+			rb = rb->rb_left;
+		else if (rb->rb_right)
+			rb = rb->rb_right;
+		else {
+			av = rb_entry(rb, struct ubi_ainf_volume, rb);
+
+			rb = rb_parent(rb);
+			if (rb) {
+				if (rb->rb_left == &av->rb)
+					rb->rb_left = NULL;
+				else
+					rb->rb_right = NULL;
+			}
+
+			destroy_av(ai, av);
+		}
+	}
+
+	if (ai->aeb_slab_cache)
+		kmem_cache_destroy(ai->aeb_slab_cache);
+
+	kfree(ai);
+}
+
+/**
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
  * @ai: attach info object
@@ -1354,95 +1435,6 @@ out_ai:
 }
 
 /**
- * destroy_av - free volume attaching information.
- * @av: volume attaching information
- * @ai: attaching information
- *
- * This function destroys the volume attaching information.
- */
-static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
-{
-	struct ubi_ainf_peb *aeb;
-	struct rb_node *this = av->root.rb_node;
-
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &aeb->u.rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-
-			kmem_cache_free(ai->aeb_slab_cache, aeb);
-		}
-	}
-	kfree(av);
-}
-
-/**
- * destroy_ai - destroy attaching information.
- * @ubi: UBI device object
- * @ai: attaching information
- */
-static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
-{
-	struct ubi_ainf_peb *aeb, *aeb_tmp;
-	struct ubi_ainf_volume *av;
-	struct rb_node *rb;
-
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->erase, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->corr, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-	list_for_each_entry_safe(aeb, aeb_tmp, &ai->free, u.list) {
-		list_del(&aeb->u.list);
-		kmem_cache_free(ai->aeb_slab_cache, aeb);
-	}
-
-	/* Destroy the volume RB-tree */
-	rb = ai->volumes.rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			av = rb_entry(rb, struct ubi_ainf_volume, rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &av->rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
-
-			destroy_av(ai, av);
-		}
-	}
-
-	if (ai->aeb_slab_cache)
-		kmem_cache_destroy(ai->aeb_slab_cache);
-
-	kfree(ai);
-}
-
-/**
  * self_check_ai - check the attaching information.
  * @ubi: UBI device description object
  * @ai: attaching information
-- 
1.7.6.5

