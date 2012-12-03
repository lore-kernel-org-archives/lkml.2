Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2LCU7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:59:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2LCU7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:41 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 20/26] aio: Give shared kioctx fields their own cachelines
Date: Mon,  3 Dec 2012 12:58:36 -0800
Message-Id: <1354568322-29029-21-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index cebd8f2..70a34f6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -67,13 +67,6 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
-	wait_queue_head_t	wait;
-
-	spinlock_t		ctx_lock;
-
-	atomic_t		reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
-
 	unsigned		nr;
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -85,6 +78,18 @@ struct kioctx {
 	struct page		**ring_pages;
 	long			nr_pages;
 
+	struct rcu_head		rcu_head;
+	struct work_struct	rcu_work;
+
+	struct {
+		atomic_t	reqs_active;
+	} ____cacheline_aligned;
+
+	struct {
+		spinlock_t	ctx_lock;
+		struct list_head active_reqs;	/* used for cancellation */
+	} ____cacheline_aligned;
+
 	struct {
 		struct mutex	ring_lock;
 	} ____cacheline_aligned;
@@ -94,10 +99,11 @@ struct kioctx {
 		spinlock_t	completion_lock;
 	} ____cacheline_aligned;
 
-	struct page		*internal_pages[AIO_RING_PAGES];
+	struct {
+		wait_queue_head_t wait;
+	} ____cacheline_aligned;
 
-	struct rcu_head		rcu_head;
-	struct work_struct	rcu_work;
+	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
 /*------ sysctl variables----*/
-- 
1.7.12

