Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab2GFLCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:02:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2GFLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:02:50 -0400
Date: Fri, 6 Jul 2012 04:02:38 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-48fdc72f23ad9a9956e524a47843135d0bbc3317@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de, teravest@google.com
In-Reply-To: <1340998301-1715-1-git-send-email-vnagarnaik@google.com>
References: <1340998301-1715-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ring-buffer:
  Fix accounting of entries when removing pages
Git-Commit-ID: 48fdc72f23ad9a9956e524a47843135d0bbc3317
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:02:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48fdc72f23ad9a9956e524a47843135d0bbc3317
Gitweb:     http://git.kernel.org/tip/48fdc72f23ad9a9956e524a47843135d0bbc3317
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 29 Jun 2012 12:31:41 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 29 Jun 2012 16:17:17 -0400

ring-buffer: Fix accounting of entries when removing pages

When removing pages from the ring buffer, its state is not reset. This
means that the counters need to be correctly updated to account for the
pages removed.

Update the overrun counter to reflect the removed events from the pages.

Link: http://lkml.kernel.org/r/1340998301-1715-1-git-send-email-vnagarnaik@google.com

Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ba39cba..f765465 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1347,10 +1347,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 			 * If something was added to this page, it was full
 			 * since it is not the tail page. So we deduct the
 			 * bytes consumed in ring buffer from here.
-			 * No need to update overruns, since this page is
-			 * deleted from ring buffer and its entries are
-			 * already accounted for.
+			 * Increment overrun to account for the lost events.
 			 */
+			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 		}
 
