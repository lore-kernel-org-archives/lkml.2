Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1AFCQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:16:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53097 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1AFCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/12] timers: Add rb_init_node() to allow for stack allocated rb nodes
Date: Wed,  5 Jan 2011 18:15:58 -0800
Message-Id: <1294280159-2513-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cases where a timerqueue_node or some structure that utilizes
a timerqueue_node is allocated on the stack, gcc would give warnings
caused by the timerqueue_init()'s calling RB_CLEAR_NODE, which
self-references the nodes uninitialized data.

The solution is to create an rb_init_node() function that zeros
the rb_node structure out and then calls RB_CLEAR_NODE(), and
then call the new init function from timerqueue_init().

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/rbtree.h     |    8 ++++++++
 include/linux/timerqueue.h |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 7066acb..033b507 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -136,6 +136,14 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 #define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
 #define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
 
+static inline void rb_init_node(struct rb_node *rb)
+{
+	rb->rb_parent_color = 0;
+	rb->rb_right = NULL;
+	rb->rb_left = NULL;
+	RB_CLEAR_NODE(rb);
+}
+
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 406b103..67cca3d 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -26,7 +26,7 @@ extern struct timerqueue_node *timerqueue_iterate_next(
 
 static inline void timerqueue_init(struct timerqueue_node *node)
 {
-	RB_CLEAR_NODE(&node->node);
+	rb_init_node(&node->node);
 }
 
 static inline void timerqueue_init_head(struct timerqueue_head *head)
-- 
1.7.3.2.146.gca209

