Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2DQPrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:47:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab2DQPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:47:43 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KOSAKI Motohiro <mkosaki@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [Patch 6/8] mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Date: Tue, 17 Apr 2012 11:46:23 -0400
Message-Id: <a4466082257558adf6654facc633630c14b65033.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
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
index 3ced596..f9f0782 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -150,7 +150,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+		if (mq_msg_tblsz > PAGE_SIZE)
 			info->messages = vmalloc(mq_msg_tblsz);
 		else
 			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
@@ -263,7 +263,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+	if (is_vmalloc_addr(info->messages))
 		vfree(info->messages);
 	else
 		kfree(info->messages);
-- 
1.7.7.6

