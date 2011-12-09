Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1LIWgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:36:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50473 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1LIWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:36:43 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KOSAKI Motohiro <mkosaki@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Doug Ledford <dledford@redhat.com> (commit_signer:5/13=38%),
        Joe Korty <joe.korty@ccur.com> (commit_signer:2/13=15%)
Subject: [resend][PATCH 2/3] mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Date: Fri,  9 Dec 2011 17:35:56 -0500
Message-Id: <1323470163-8723-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

KMALLOC_MAX_SIZE is no good threshold. It is extream high and
problematic. Unfortunately, some silly drivers depend on and
we can't change it. but any new code don't use such extream
ugly high order allocations. It bring us awful fragmentation
issue and system slowdown.

Signed-off-by: KOSAKI Motohiro <mkosaki@jp.fujitsu.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 ipc/mqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c246c83..315f84f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -151,7 +151,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+		if (mq_msg_tblsz > PAGE_SIZE)
 			info->messages = vmalloc(mq_msg_tblsz);
 		else
 			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
@@ -275,7 +275,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+	if (is_vmalloc_addr(info->messages))
 		vfree(info->messages);
 	else
 		kfree(info->messages);
-- 
1.7.1

