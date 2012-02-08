Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2BHMJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:09:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2BHMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:09:21 -0500
From: Naohiro Aota <naota@elisp.net>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Naohiro Aota <naota@elisp.net>
Subject: [PATCH] fsnotify: handle subfiles' perm events
Date: Wed,  8 Feb 2012 20:58:48 +0900
Message-Id: <1328702328-1808-1-git-send-email-naota@elisp.net>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS_OPEN_PERM and FS_ACCESS_PERM are not listed on
FS_EVENTS_POSS_ON_CHILD. Due to fsnotify_inode_watches_children()
check, if you only specify only these events as fsnotify_mask, you
don't get subfiles' perm events notified.

This patch add the events to FS_EVENTS_POSS_ON_CHILD to get them
notified even if only these events are specified to fsnotify_mask.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---

Recently I'm working on fanotify and found the following strange
behaviors.

I wrote a program to set fanotify_mark on "/tmp/block" and FAN_DENY
all events notified.

fanotify_mask = FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD:
$ cd /tmp/block; cat foo
cat: foo: Operation not permitted

Operation on the file is blocked as expected. 

But,

fanotify_mask = FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD:
$ cd /tmp/block; cat foo
aaa

It's not blocked anymore. This is confusing behavior. Also reading
commit "fsnotify: call fsnotify_parent in perm events", it seems like
fsnotify should handle subfiles' perm events as well as the other
notify events.

With this patch, regardless of FAN_ALL_EVENTS set or not:
$ cd /tmp/block; cat foo
cat: foo: Operation not permitted

Operation on the file is now blocked properly.

 include/linux/fsnotify_backend.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 91d0e0a3..63d966d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -60,7 +60,7 @@
 #define FS_EVENTS_POSS_ON_CHILD   (FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
 				   FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
 				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
-				   FS_DELETE)
+				   FS_DELETE | FS_OPEN_PERM | FS_ACCESS_PERM)
 
 #define FS_MOVE			(FS_MOVED_FROM | FS_MOVED_TO)
 
-- 
1.7.8.4

