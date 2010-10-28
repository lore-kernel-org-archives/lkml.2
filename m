Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab0J1Vde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934571Ab0J1VdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:00 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 14/20] fanotify: do not send events for irregular files
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:55 -0400
Message-ID: <20101028213255.24810.74011.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify_should_send_event has a test to see if an object is a file or
directory and does not send an event otherwise.  The problem is that the
test is actually checking if the object with a mark is a file or directory,
not if the object the event happened on is a file or directory.  We should
check the latter.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 60c11c3..8d98e1f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -160,20 +160,21 @@ static bool fanotify_should_send_event(struct fsnotify_group *group,
 				       __u32 event_mask, void *data, int data_type)
 {
 	__u32 marks_mask, marks_ignored_mask;
+	struct path *path = data;
 
 	pr_debug("%s: group=%p to_tell=%p inode_mark=%p vfsmnt_mark=%p "
 		 "mask=%x data=%p data_type=%d\n", __func__, group, to_tell,
 		 inode_mark, vfsmnt_mark, event_mask, data, data_type);
 
-	/* sorry, fanotify only gives a damn about files and dirs */
-	if (!S_ISREG(to_tell->i_mode) &&
-	    !S_ISDIR(to_tell->i_mode))
-		return false;
-
 	/* if we don't have enough info to send an event to userspace say no */
 	if (data_type != FSNOTIFY_EVENT_PATH)
 		return false;
 
+	/* sorry, fanotify only gives a damn about files and dirs */
+	if (!S_ISREG(path->dentry->d_inode->i_mode) &&
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		return false;
+
 	if (inode_mark && vfsmnt_mark) {
 		marks_mask = (vfsmnt_mark->mask | inode_mark->mask);
 		marks_ignored_mask = (vfsmnt_mark->ignored_mask | inode_mark->ignored_mask);

