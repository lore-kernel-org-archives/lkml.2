Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0HRQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0HRQaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:30:00 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/5] fsnotify: reset used_inode and used_vfsmount on each pass
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Aug 2010 12:29:59 -0400
Message-ID: <20100818162959.1080.70797.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
References: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsnotify main loop has 2 booleans which tell if a particular mark was
sent to the listeners or if it should be processed in the next pass.  The
problem is that the booleans were not reset on each traversal of the loop.
So marks could get skipped even when they were not sent to the notifiers.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index f3e3b35..59dc7a0 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -220,7 +220,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	struct fsnotify_event *event = NULL;
 	struct vfsmount *mnt;
 	int idx, ret = 0;
-	bool used_inode = false, used_vfsmount = false;
+	bool used_inode, used_vfsmount;
 	/* global tests shouldn't care about events on child only the specific event */
 	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
@@ -261,6 +261,8 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	}
 
 	while (inode_node || vfsmount_node) {
+		used_inode = used_vfsmount = false;
+
 		if (inode_node) {
 			inode_mark = hlist_entry(srcu_dereference(inode_node, &fsnotify_mark_srcu),
 						 struct fsnotify_mark, i.i_list);

