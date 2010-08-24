Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0HXUnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0HXUnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:43:10 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Andreas Schwab <schwab@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH -v2] fanotify: drops the packed attribute from userspace event metadata
Date: Tue, 24 Aug 2010 16:43:02 -0400
Message-Id: <1282682582-15980-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace event metadata structure was packed so when sent from a kernel
with a certain set of alignment rules to a userspace listener with a different
set of alignment rules the userspace process would be able to use the
structure.  On some arches just using packed, even if it doesn't do anything
to the alignment can cause a severe performance hit.  From now on we are
not going to set the packed attribute and will just need to be very careful
to make sure the structure is naturally aligned.

Cc: Andreas Schwab <schwab@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 include/linux/fanotify.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 0535461..b892e46 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -65,20 +65,23 @@
 				 FAN_ALL_PERM_EVENTS |\
 				 FAN_Q_OVERFLOW)
 
-#define FANOTIFY_METADATA_VERSION	1
-
+#define FANOTIFY_METADATA_VERSION	2
+/*
+ * These structures must be naturally aligned so that a 32 bit userspace process
+ * will find the offsets the same as a 64bit process.
+ */
 struct fanotify_event_metadata {
 	__u32 event_len;
 	__u32 vers;
-	__u64 mask;
+	aligned_u64 mask;
 	__s32 fd;
 	__s32 pid;
-} __attribute__ ((packed));
+};
 
 struct fanotify_response {
 	__s32 fd;
 	__u32 response;
-} __attribute__ ((packed));
+};
 
 /* Legit userspace responses to a _PERM event */
 #define FAN_ALLOW	0x01
-- 
1.7.1

