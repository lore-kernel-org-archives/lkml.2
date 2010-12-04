Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0LDANv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:51 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0LDANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=d0FiuHUscIOlnVRN36HJt72UmJqtfaIPqQoulQyMlIwdrbABdqpauO6ID+jm7nOU5
	xIcnstSe/Y221SeH/u5WA==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 03/15] ring_buffer: Align buffer_page struct allocations only to fit the flags.
Date: Fri,  3 Dec 2010 16:13:17 -0800
Message-Id: <1291421609-14665-4-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffer_page structs need to be aligned to 4 byte boundaries because the page
flags are stored in the two least-significant bits of the pointers in the page
list. Aligning to cache lines is sufficient, but doesn't seem to be necessary.
Reducing the alignement to only 4 bytes may improve cache efficiency.

Testing with Autotest's tracing_microbenchmark, there was no significant change
in overhead with this change.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/ring_buffer.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8ef7cc4..957a8b8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -644,8 +644,14 @@ EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 #define RB_PAGE_HEAD		1UL
 #define RB_PAGE_UPDATE		2UL
 
-
 #define RB_FLAG_MASK		3UL
+#define RB_PAGE_ALIGNMENT	(RB_FLAG_MASK+1)
+
+/* Ensure alignment of struct buffer_page */
+static __attribute__((unused)) void check_buffer_page_alignment(void)
+{
+        BUILD_BUG_ON(__alignof__(struct buffer_page) % RB_PAGE_ALIGNMENT != 0);
+}
 
 /* PAGE_MOVED is not part of the mask */
 #define RB_PAGE_MOVED		4UL
@@ -1004,8 +1010,8 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	WARN_ON(!nr_pages);
 
 	for (i = 0; i < nr_pages; i++) {
-		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+		bpage = kzalloc_node(sizeof(*bpage), GFP_KERNEL,
+				     cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
 
@@ -1059,8 +1065,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
-	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-			    GFP_KERNEL, cpu_to_node(cpu));
+	bpage = kzalloc_node(sizeof(*bpage), GFP_KERNEL, cpu_to_node(cpu));
 	if (!bpage)
 		goto fail_free_buffer;
 
@@ -1375,9 +1380,8 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
-			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
-						  cache_line_size()),
-					    GFP_KERNEL, cpu_to_node(cpu));
+			bpage = kzalloc_node(sizeof(*bpage), GFP_KERNEL,
+					     cpu_to_node(cpu));
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-- 
1.7.3.1

