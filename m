Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0HWAhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0HWAhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:37:25 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: [PATCH 4/4] fanotify: drops the packed attribute from userspace event metadata
Date: Sun, 22 Aug 2010 20:37:10 -0400
Message-Id: <1282523830-27751-4-git-send-email-eparis@redhat.com>
In-Reply-To: <1282523830-27751-3-git-send-email-eparis@redhat.com>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com>
 <1282523830-27751-2-git-send-email-eparis@redhat.com>
 <1282523830-27751-3-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace event metadata structure was packed so when sent from a kernel
with a certain set of alignment rules to a userspace listener with a different
set of alignment rules the userspace process would be able to use the
structure.  On some arches just using packed, even if it doesn't do anything
to the alignment can cause a severe performance hit.  From now on we are
not going to set the packed attribute and will just need to be very careful
to make sure the structure is naturally aligned and that explicit padding is
used when necessary.  To make sure noone gets this wrong in the future, we
enforce this fact, at build time, using a similar structure that is packed
and comparing their sizes.

Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c |    2 ++
 include/linux/fanotify.h           |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b966b72..c3a5742 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -778,6 +778,8 @@ SYSCALL_ALIAS(sys_fanotify_mark, SyS_fanotify_mark);
  */
 static int __init fanotify_user_setup(void)
 {
+	BUILD_BUG_ON(sizeof(struct fanotify_event_metadata) !=
+		     sizeof(struct fan_event_meta_packed));
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
 	fanotify_response_event_cache = KMEM_CACHE(fanotify_response_event,
 						   SLAB_PANIC);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 0535461..3d7a9b5 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -66,14 +66,21 @@
 				 FAN_Q_OVERFLOW)
 
 #define FANOTIFY_METADATA_VERSION	1
-
+/*
+ * This structue must be naturally aligned so that a 32 bit userspace process
+ * will find the offsets the same as a 64bit process.  If there would be padding
+ * in the structure it must be added explictly by hand.  Please note that
+ * anything added to this structure must also be added to the fan_event_meta_packed
+ * struct, which is used to enforce the alignment and padding rules at build
+ * time.
+ */
 struct fanotify_event_metadata {
 	__u32 event_len;
 	__u32 vers;
 	__u64 mask;
 	__s32 fd;
 	__s32 pid;
-} __attribute__ ((packed));
+};
 
 struct fanotify_response {
 	__s32 fd;
@@ -95,4 +102,15 @@ struct fanotify_response {
 				(long)(meta)->event_len >= (long)FAN_EVENT_METADATA_LEN && \
 				(long)(meta)->event_len <= (long)(len))
 
+#ifdef __KERNEL__
+/* see struct fanotify_event_metadata for the reason this exists */
+struct fan_event_meta_packed {
+	__u32 event_len;
+	__u32 vers;
+	__u64 mask;
+	__s32 fd;
+	__s32 pid;
+} __attribute__ ((packed));
+
+#endif /* __KERNEL__ */
 #endif /* _LINUX_FANOTIFY_H */
-- 
1.6.5.3

