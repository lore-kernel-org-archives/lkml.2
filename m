Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2FRTMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:12:08 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41268 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2FRTMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:12:06 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] tracing: Update entries counter when removing pages
Date: Mon, 18 Jun 2012 12:12:02 -0700
Message-Id: <1340046722-11477-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing pages from the ring buffer, its state is not reset. This
means that the counters need to be correctly updated to account for the
pages removed.

Update the entries counter to reflect the removed events from the
pages just like entries_bytes counter.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 96c2dd1..a2bec4c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1346,10 +1346,10 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 			 * If something was added to this page, it was full
 			 * since it is not the tail page. So we deduct the
 			 * bytes consumed in ring buffer from here.
-			 * No need to update overruns, since this page is
-			 * deleted from ring buffer and its entries are
-			 * already accounted for.
+			 * No need to update overruns, since updating
+			 * 'entries' accounts for that.
 			 */
+			local_sub(page_entries, &cpu_buffer->entries);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 		}
 
-- 
1.7.7.3

