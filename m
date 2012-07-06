Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab2GFKuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:50:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2GFKuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:50:00 -0400
Date: Fri, 6 Jul 2012 03:49:46 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-a5fb833172eca69136e9ee1ada778e404086ab8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, dhsharp@google.com,
        tglx@linutronix.de
In-Reply-To: <1340060577-9112-1-git-send-email-dhsharp@google.com>
References: <1340060577-9112-1-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer: Fix uninitialized read_stamp
Git-Commit-ID: a5fb833172eca69136e9ee1ada778e404086ab8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:49:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5fb833172eca69136e9ee1ada778e404086ab8a
Gitweb:     http://git.kernel.org/tip/a5fb833172eca69136e9ee1ada778e404086ab8a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 28 Jun 2012 13:35:04 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 28 Jun 2012 13:52:15 -0400

ring-buffer: Fix uninitialized read_stamp

The ring buffer reader page is used to swap a page from the writable
ring buffer. If the writer happens to be on that page, it ends up on the
reader page, but will simply move off of it, back into the writable ring
buffer as writes are added.

The time stamp passed back to the readers is stored in the cpu_buffer per
CPU descriptor. This stamp is updated when a swap of the reader page takes
place, and it reads the current stamp from the page taken from the writable
ring buffer. Everytime a writer goes to a new page, it updates the time stamp
of that page.

The problem happens if a reader reads a page from an empty per CPU ring buffer.
If the buffer is empty, the swap still takes place, placing the writer at the
start of the reader page. If at a later time, a write happens, it updates the
page's time stamp and continues. But the problem is that the read_stamp does
not get updated, because the page was already swapped.

The solution to this was to not swap the page if the ring buffer happens to
be empty. This also removes the side effect that the writes on the reader
page will not get updated because the writer never gets back on the reader
page without a swap. That is, if a read happens on an empty buffer, but then
no reads happen for a while. If a swap took place, and the writer were to start
writing a lot of data (function tracer), it will start overflowing the ring buffer
and overwrite the older data. But because the writer never goes back onto the
reader page, the data left on the reader page never gets overwritten. This
causes the reader to see really old data, followed by a jump to newer data.

Link: http://lkml.kernel.org/r/1340060577-9112-1-git-send-email-dhsharp@google.com
Google-Bug-Id: 6410455
Reported-by: David Sharp <dhsharp@google.com>
tested-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..82a3e0c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3239,6 +3239,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
 		goto out;
 
+	/* Don't bother swapping if the ring buffer is empty */
+	if (rb_num_of_entries(cpu_buffer) == 0)
+		goto out;
+
 	/*
 	 * Reset the reader page to size zero.
 	 */
