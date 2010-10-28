Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550Ab0J1Vdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760641Ab0J1Vcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:42 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 11/20] fanotify: limit the number of marks in a single
	fanotify group
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:38 -0400
Message-ID: <20101028213238.24810.11702.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no limit on the number of marks a given fanotify group
can have.  Since fanotify is gated on CAP_SYS_ADMIN this was not seen as
a serious DoS threat.  This patch implements a default of 8192, the same as
inotify to work towards removing the CAP_SYS_ADMIN gating and eliminating
the default DoS'able status.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    9 +++++++++
 include/linux/fsnotify_backend.h   |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 43d66d9..1d33d7d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -17,6 +17,7 @@
 #include <asm/ioctls.h>
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
+#define FANOTIFY_DEFAULT_MAX_MARKS	8192
 
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
@@ -584,6 +585,9 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 	if (!fsn_mark) {
 		int ret;
 
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+			return -ENOSPC;
+
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
 		if (!fsn_mark)
 			return -ENOMEM;
@@ -626,6 +630,9 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 	if (!fsn_mark) {
 		int ret;
 
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+			return -ENOSPC;
+
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
 		if (!fsn_mark)
 			return -ENOMEM;
@@ -700,6 +707,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
 	}
 
+	group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
+
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
 		goto out_put_group;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b37f3a7..49ceed6 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -169,6 +169,7 @@ struct fsnotify_group {
 			bool bypass_perm; /* protected by access_mutex */
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
 			int f_flags;
+			unsigned int max_marks;
 		} fanotify_data;
 #endif /* CONFIG_FANOTIFY */
 	};

