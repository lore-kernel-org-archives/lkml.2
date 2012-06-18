Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2FRXDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:03:31 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53953 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2FRXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:03:30 -0400
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: vnagarnaik@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH] ring-buffer: fix uninitialized read_stamp
Date: Mon, 18 Jun 2012 16:02:57 -0700
Message-Id: <1340060577-9112-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a scenario in which trace_pipe_raw will return events with invalid
timestamps when events are copied out one at a time (instead of swapping out
the reader page with a spare page). In this scenario, ring_buffer_read_page()
uses cpu_buffer->read_stamp to keep track of the time of the earliest event.
However, cpu_buffer->read_stamp was not always updated. The only function that
sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
only by rb_get_reader_page(). rb_reset_reader_page() was not called when there
is data immediately available on the page to read (read < rb_page_size()). This
is the bug.

Setting the read_stamp on the first read from a page fixes the bug.

Tested: On certain lightly-loaded machines, repetitive reads from
trace_pipe_raw without using splice() would sometimes result in invalid
timestamps. Poisoning bpage->timestamp in rb_init_page() with a negative value
makes the problem more visible. After this fix, the invalid timstamps
disappear.

Google-Bug-Id: 6410455
Signed-off-by: David Sharp <dhsharp@google.com>
---

Steve, did you see this? It fixes a data-accuracy bug in ftrace. Also taking
this reminder as an opportunity to correct that typo in the description.

 kernel/trace/ring_buffer.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..ad0239b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3226,8 +3226,15 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
-	if (cpu_buffer->reader_page->read < rb_page_size(reader))
+	if (cpu_buffer->reader_page->read < rb_page_size(reader)) {
+		/*
+		 * If this is the first read from this page,
+		 * initialize the read timestamp.
+		 */
+		if (cpu_buffer->reader_page->read == 0)
+			cpu_buffer->read_stamp = reader->page->time_stamp;
 		goto out;
+	}
 
 	/* Never should we have an index greater than the size */
 	if (RB_WARN_ON(cpu_buffer,
-- 
1.7.7.3

