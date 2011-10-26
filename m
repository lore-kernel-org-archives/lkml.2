Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab1JZPg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:36:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46654 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab1JZPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:36:57 -0400
Message-ID: <4EA8294C.2050703@gmail.com>
Date: Wed, 26 Oct 2011 11:37:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: dledford@redhat.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com
Subject: [PATCH 6/4] ipc/mqueue: don't use kmalloc(KMALLOC_MAX_SIZE)
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com> <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com> <4EA828E4.1070409@gmail.com>
In-Reply-To: <4EA828E4.1070409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


KMALLOC_MAX_SIZE is no good threshold. It is extream high and
problematic. Unfortunately, some silly drivers depend on and
we can't change it. but any new code don't use such extream
ugly high order allocations. It bring us awful fragmentation
issue and system slowdown.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Korty <joe.korty@ccur.com>
---
 ipc/mqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 229a5fb..91ca145 100644
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
1.7.5.2


