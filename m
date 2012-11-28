Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2K1QrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:47:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57123 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2K1QoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:25 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 19/25] aio: Give shared kioctx fields their own cachelines
Date: Wed, 28 Nov 2012 08:43:43 -0800
Message-Id: <1354121029-1376-20-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1ff4d3b..7dee3aa 100644
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
@@ -86,6 +79,15 @@ struct kioctx {
 	long			nr_pages;
 
 	struct {
+		atomic_t	reqs_active;
+	} ____cacheline_aligned;
+
+	struct {
+		spinlock_t	ctx_lock;
+		struct list_head active_reqs;	/* used for cancellation */
+	} ____cacheline_aligned;
+
+	struct {
 		struct mutex	ring_lock;
 	} ____cacheline_aligned;
 
@@ -94,6 +96,10 @@ struct kioctx {
 		spinlock_t	completion_lock;
 	} ____cacheline_aligned;
 
+	struct {
+		wait_queue_head_t wait;
+	} ____cacheline_aligned;
+
 	struct page		*internal_pages[AIO_RING_PAGES];
 
 };
-- 
1.7.12

