Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2KEN4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:56:10 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:54252 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2KEN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:56:01 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 2/4] kref: Implement kref_get_unless_zero v2
Date: Mon,  5 Nov 2012 14:55:42 +0100
Message-Id: <1352123744-13269-3-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352123744-13269-1-git-send-email-thellstrom@vmware.com>
References: <1352123744-13269-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is intended to simplify locking around refcounting for
objects that can be looked up from a lookup structure, and which are
removed from that lookup structure in the object destructor.
Operations on such objects require at least a read lock around
lookup + kref_get, and a write lock around kref_put + remove from lookup
structure. Furthermore, RCU implementations become extremely tricky.
With a lookup followed by a kref_get_unless_zero *with return value check*
locking in the kref_put path can be deferred to the actual removal from
the lookup structure and RCU lookups become trivial.

v2: Formatting fixes.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 include/linux/kref.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 65af688..bae91d0 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -111,4 +111,25 @@ static inline int kref_put_mutex(struct kref *kref,
 	}
 	return 0;
 }
+
+/**
+ * kref_get_unless_zero - Increment refcount for object unless it is zero.
+ * @kref: object.
+ *
+ * Return 0 if the increment succeeded. Otherwise return non-zero.
+ *
+ * This function is intended to simplify locking around refcounting for
+ * objects that can be looked up from a lookup structure, and which are
+ * removed from that lookup structure in the object destructor.
+ * Operations on such objects require at least a read lock around
+ * lookup + kref_get, and a write lock around kref_put + remove from lookup
+ * structure. Furthermore, RCU implementations become extremely tricky.
+ * With a lookup followed by a kref_get_unless_zero *with return value check*
+ * locking in the kref_put path can be deferred to the actual removal from
+ * the lookup structure and RCU lookups become trivial.
+ */
+static inline int __must_check kref_get_unless_zero(struct kref *kref)
+{
+	return !atomic_add_unless(&kref->refcount, 1, 0);
+}
 #endif /* _KREF_H_ */
-- 
1.7.4.4

