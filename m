Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0KXFMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0KXFMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:12:16 -0500
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eugene@redhat.com, vegard.nossum@gmail.com,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] inotify: stop kernel memory leak on file creation failure
Date: Wed, 24 Nov 2010 00:11:38 -0500
Message-Id: <1290575499-32724-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If inotify_init is unable to allocate a new file for the new inotify
group we leak the new group.  This patch drops the reference on the
group on file allocation failure.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/inotify/inotify_user.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 444c305..4cd5d5d 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -752,6 +752,7 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
 	if (ret >= 0)
 		return ret;
 
+	fsnotify_put_group(group);
 	atomic_dec(&user->inotify_devs);
 out_free_uid:
 	free_uid(user);
-- 
1.7.1

