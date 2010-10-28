Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0J1Vf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411Ab0J1Vcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:35 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 10/20] fanotify: allow userspace to override max queue depth
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:32 -0400
Message-ID: <20101028213232.24810.78.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify has a defualt max queue depth.  This patch allows processes which
explicitly request it to have an 'unlimited' queue depth.  These processes
need to be very careful to make sure they cannot fall far enough behind
that they OOM the box.  Thus this flag is gated on CAP_SYS_ADMIN.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    9 ++++++++-
 include/linux/fanotify.h           |    5 +++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 04f2fe4..43d66d9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -691,7 +691,14 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		goto out_put_group;
 	}
 
-	group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
+	if (flags & FAN_UNLIMITED_QUEUE) {
+		fd = -EPERM;
+		if (!capable(CAP_SYS_ADMIN))
+			goto out_put_group;
+		group->max_events = UINT_MAX;
+	} else {
+		group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
+	}
 
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index ed479b6..e37f559 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -28,12 +28,13 @@
 #define FAN_CLASS_NOTIF		0x00000000
 #define FAN_CLASS_CONTENT	0x00000004
 #define FAN_CLASS_PRE_CONTENT	0x00000008
-
 #define FAN_ALL_CLASS_BITS	(FAN_CLASS_NOTIF | FAN_CLASS_CONTENT | \
 				 FAN_CLASS_PRE_CONTENT)
 
+#define FAN_UNLIMITED_QUEUE	0x00000010
+
 #define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
-				 FAN_ALL_CLASS_BITS)
+				 FAN_ALL_CLASS_BITS | FAN_UNLIMITED_QUEUE)
 
 /* flags used for fanotify_modify_mark() */
 #define FAN_MARK_ADD		0x00000001

