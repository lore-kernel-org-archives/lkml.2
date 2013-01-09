Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3AIQq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:46:57 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56480 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3AIQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:46:17 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/5] buffer: make touch_buffer() an exported function
Date: Wed,  9 Jan 2013 08:45:06 -0800
Message-Id: <1357749908-16562-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to add a trace point to touch_buffer() but macros and inline
functions defined in header files can't have tracing points.  Move
touch_buffer() to fs/buffer.c and make it a proper function.

The new exported function is also declared inline.  As most uses of
touch_buffer() are inside buffer.c with nilfs2 as the only other user,
the effect of this change should be negligible.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 fs/buffer.c                 | 6 ++++++
 include/linux/buffer_head.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c017a2d..a8c2dfb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -53,6 +53,12 @@ void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 }
 EXPORT_SYMBOL(init_buffer);
 
+inline void touch_buffer(struct buffer_head *bh)
+{
+	mark_page_accessed(bh->b_page);
+}
+EXPORT_SYMBOL(touch_buffer);
+
 static int sleep_on_buffer(void *word)
 {
 	io_schedule();
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..5afc4f9 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -126,7 +126,6 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
-#define touch_buffer(bh)	mark_page_accessed(bh->b_page)
 
 /* If we *know* page->private refers to buffer_heads */
 #define page_buffers(page)					\
@@ -142,6 +141,7 @@ BUFFER_FNS(Unwritten, unwritten)
 
 void mark_buffer_dirty(struct buffer_head *bh);
 void init_buffer(struct buffer_head *, bh_end_io_t *, void *);
+void touch_buffer(struct buffer_head *bh);
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
 int try_to_free_buffers(struct page *);
-- 
1.8.0.2

