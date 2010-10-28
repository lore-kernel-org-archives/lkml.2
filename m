Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0J1VdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab0J1Vca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:30 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 09/20] fsnotify: implement a default maximum queue depth
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:26 -0400
Message-ID: <20101028213226.24810.78038.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently fanotify has no maximum queue depth.  Since fanotify is
CAP_SYS_ADMIN only this does not pose a normal user DoS issue, but it
certianly is possible that an fanotify listener which can't keep up could
OOM the box.  This patch implements a default 16k depth.  This is the same
default depth used by inotify, but given fanotify's better queue merging in
many situations this queue will contain many additional useful events by
comparison.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    4 ++++
 include/linux/fanotify.h           |    1 -
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b265936..04f2fe4 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -16,6 +16,8 @@
 
 #include <asm/ioctls.h>
 
+#define FANOTIFY_DEFAULT_MAX_EVENTS	16384
+
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
@@ -689,6 +691,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		goto out_put_group;
 	}
 
+	group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
+
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
 		goto out_put_group;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index a97c96d..ed479b6 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -12,7 +12,6 @@
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* interested in child events */
 
-/* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
 
 #define FAN_OPEN_PERM		0x00010000	/* File open in perm check */

