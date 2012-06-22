Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2FVSuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:50:13 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56258 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2FVSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:50:11 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] tracing: Fix crash due to uninitialized new_pages list head
Date: Fri, 22 Jun 2012 11:50:05 -0700
Message-Id: <1340391005-10880-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new_pages list head in the cpu_buffer is not initialized. When
adding pages to the ring buffer, if the memory allocation fails in
ring_buffer_resize, the clean up handler tries to free up the allocated
pages from all the cpu buffers. The panic is caused by referencing the
uninitialized new_pages list head.

Initializing the new_pages list head in rb_allocate_cpu_buffer fixes
this.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a2bec4c..c5a5479 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1075,6 +1075,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 
 	ret = rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
-- 
1.7.7.3

