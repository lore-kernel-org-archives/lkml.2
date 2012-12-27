Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2L0CBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:01:07 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42918 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab2L0CAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:00:52 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 20/32] aio: Give shared kioctx fields their own cachelines
Date: Wed, 26 Dec 2012 17:59:59 -0800
Message-Id: <1356573611-18590-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 96fbd6b..fa87732 100644
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
@@ -85,19 +78,29 @@ struct kioctx {
 	struct page		**ring_pages;
 	long			nr_pages;
 
+	struct rcu_head		rcu_head;
+	struct work_struct	rcu_work;
+
 	struct {
-		struct mutex	ring_lock;
+		atomic_t	reqs_active;
 	} ____cacheline_aligned;
 
 	struct {
+		spinlock_t	ctx_lock;
+		struct list_head active_reqs;	/* used for cancellation */
+	} ____cacheline_aligned_in_smp;
+
+	struct {
+		struct mutex	ring_lock;
+		wait_queue_head_t wait;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
 		unsigned	tail;
 		spinlock_t	completion_lock;
-	} ____cacheline_aligned;
+	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
-
-	struct rcu_head		rcu_head;
-	struct work_struct	rcu_work;
 };
 
 /*------ sysctl variables----*/
-- 
1.7.12

