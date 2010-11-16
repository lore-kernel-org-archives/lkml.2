Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0KPOVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:21:25 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56114 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab0KPOVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:21:24 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 1/2] kref: Add a kref_sub function
Date: Tue, 16 Nov 2010 15:21:07 +0100
Message-Id: <1289917268-4922-2-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1289917268-4922-1-git-send-email-thellstrom@vmware.com>
References: <1289917268-4922-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it possible to optimize batched multiple unrefs.
Initial user will be drivers/gpu/ttm which accumulates unrefs to be
processed outside of atomic code.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 include/linux/kref.h |    2 ++
 lib/kref.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 6cc38fc..d4a62ab 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -24,5 +24,7 @@ struct kref {
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
+int kref_sub(struct kref *kref, unsigned int count,
+	     void (*release) (struct kref *kref));
 
 #endif /* _KREF_H_ */
diff --git a/lib/kref.c b/lib/kref.c
index d3d227a..3efb882 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -62,6 +62,36 @@ int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 	return 0;
 }
 
+
+/**
+ * kref_sub - subtract a number of refcounts for object.
+ * @kref: object.
+ * @count: Number of recounts to subtract.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ *
+ * Subtract @count from the refcount, and if 0, call release().
+ * Return 1 if the object was removed, otherwise return 0.  Beware, if this
+ * function returns 0, you still can not count on the kref from remaining in
+ * memory.  Only use the return value if you want to see if the kref is now
+ * gone, not present.
+ */
+int kref_sub(struct kref *kref, unsigned int count,
+	     void (*release)(struct kref *kref))
+{
+	WARN_ON(release == NULL);
+	WARN_ON(release == (void (*)(struct kref *))kfree);
+
+	if (atomic_sub_and_test((int) count, &kref->refcount)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
+
 EXPORT_SYMBOL(kref_init);
 EXPORT_SYMBOL(kref_get);
 EXPORT_SYMBOL(kref_put);
+EXPORT_SYMBOL(kref_sub);
-- 
1.6.2.5

