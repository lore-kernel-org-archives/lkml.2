Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3AHXgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:63275 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab3AHXgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 16/77] inotify: stop kernel memory leak on file creation failure
Date: Tue, 8 Jan 2013 18:34:55 -0500
Message-ID: <1357688156-25387-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a2ae4cc9a16e211c8a128ba10d22a85431f093ab upstream.

If inotify_init is unable to allocate a new file for the new inotify
group we leak the new group.  This patch drops the reference on the
group on file allocation failure.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 0c6bbc0..72f8825 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -674,6 +674,7 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
 	if (ret >= 0)
 		return ret;
 
+	fsnotify_put_group(group);
 	atomic_dec(&user->inotify_devs);
 out_free_uid:
 	free_uid(user);
-- 
1.7.12.1

