Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0KXR2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:28:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755538Ab0KXR16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:27:58 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18c56o1YI8ce+jXe3JWcVIwcwDdRw86yV3b/FTgEP
	xZthcUeGowijTQ
Date: Wed, 24 Nov 2010 18:26:04 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] fanotify: Dont try to open a file descriptor for the
	overflow event
Message-ID: <20101124172604.GC18135@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should not try to open a file descriptor for the overflow event since this
will always fail.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index eddad55..5d2e683 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -121,6 +121,8 @@ static int fill_event_metadata(struct fsnotify_group *group,
 				   struct fanotify_event_metadata *metadata,
 				   struct fsnotify_event *event)
 {
+	int ret = 0;
+
 	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__,
 		 group, metadata, event);
 
@@ -128,9 +130,15 @@ static int fill_event_metadata(struct fsnotify_group *group,
 	metadata->vers = FANOTIFY_METADATA_VERSION;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
-	metadata->fd = create_fd(group, event);
+	if (unlikely(event->mask & FAN_Q_OVERFLOW))
+		metadata->fd = FAN_NOFD;
+	else {
+		metadata->fd = create_fd(group, event);
+		if (metadata->fd < 0)
+			ret = metadata->fd;
+	}
 
-	return metadata->fd;
+	return ret;
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
@@ -264,7 +272,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (ret < 0)
 		goto out;
 
-	fd = ret;
+	fd = fanotify_event_metadata.fd;
 	ret = prepare_for_access_response(group, event, fd);
 	if (ret)
 		goto out_close_fd;
@@ -278,7 +286,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 out_kill_access_response:
 	remove_access_response(group, event, fd);
 out_close_fd:
-	sys_close(fd);
+	if (fd != FAN_NOFD)
+		sys_close(fd);
 out:
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
-- 
1.5.6.5

