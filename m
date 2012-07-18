Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2GRLDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:03:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60340 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2GRLD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:03:27 -0400
Date: Wed, 18 Jul 2012 04:03:20 -0700
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH] ipc/mqueue: remove unnecessary rb_init_node calls
Message-ID: <20120718110320.GA32698@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I previously sent out my rbtree patches against v3.4, however in private
email Andrew notified me that they broke some builds due to some new
rb_init_node calls that have been introduced after v3.4. No big deal
and it's an easy fix, but I forgot to CC the usual lists and now some
people need the fix in order to try out the patches. So here it is :)

----- Forwarded message from Michel Lespinasse <walken@google.com> -----

Date: Tue, 17 Jul 2012 17:30:35 -0700
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>
Subject: [PATCH] ipc/mqueue: remove unnecessary rb_init_node calls

Commits d6629859 and ce2d52cc introduced an rbtree of message
priorities, and usage of rb_init_node() to initialize the corresponding
nodes. As it turns out, rb_init_node() is unnecessary here, as the
nodes are fully initialized on insertion by rb_link_node() and the
code doesn't access nodes that aren't inserted on the rbtree.

Removing the rb_init_node() calls as I removed that function during
rbtree API cleanups (the only other use of it was in a place that similarly
didn't require it).

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Doug Ledford <dledford@redhat.com>
---
 ipc/mqueue.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 8ce5769..4439c69 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -142,7 +142,6 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
 		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
 		if (!leaf)
 			return -ENOMEM;
-		rb_init_node(&leaf->rb_node);
 		INIT_LIST_HEAD(&leaf->msg_list);
 		info->qsize += sizeof(*leaf);
 	}
@@ -1041,7 +1040,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
@@ -1149,7 +1147,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
-- 
1.7.7.3
