Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab0KXFMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:12:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0KXFMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:12:21 -0500
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eugene@redhat.com, vegard.nossum@gmail.com,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] fanotify: do not leak user reference on allocation failure
Date: Wed, 24 Nov 2010 00:11:39 -0500
Message-Id: <1290575499-32724-2-git-send-email-eparis@redhat.com>
In-Reply-To: <1290575499-32724-1-git-send-email-eparis@redhat.com>
References: <1290575499-32724-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fanotify_init is unable to allocate a new fsnotify group it will
return but will not drop its reference on the associated user struct.
Drop that reference on error.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index a2538b6..eddad55 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -695,8 +695,10 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 
 	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
 	group = fsnotify_alloc_group(&fanotify_fsnotify_ops);
-	if (IS_ERR(group))
+	if (IS_ERR(group)) {
+		free_uid(user);
 		return PTR_ERR(group);
+	}
 
 	group->fanotify_data.user = user;
 	atomic_inc(&user->fanotify_listeners);
-- 
1.7.1

