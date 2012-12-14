Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2LNXEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:04:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:41009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab2LNXEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:04:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 32/37] ring-buffer: Fix race between integrity check and readers
Date: Fri, 14 Dec 2012 15:01:09 -0800
Message-Id: <20121214222258.135834660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 9366c1ba13fbc41bdb57702e75ca4382f209c82f upstream.

The function rb_check_pages() was added to make sure the ring buffer's
pages were sane. This check is done when the ring buffer size is modified
as well as when the iterator is released (closing the "trace" file),
as that was considered a non fast path and a good place to do a sanity
check.

The problem is that the check does not have any locks around it.
If one process were to read the trace file, and another were to read
the raw binary file, the check could happen while the reader is reading
the file.

The issues with this is that the check requires to clear the HEAD page
before doing the full check and it restores it afterward. But readers
require the HEAD page to exist before it can read the buffer, otherwise
it gives a nasty warning and disables the buffer.

By adding the reader lock around the check, this keeps the race from
happening.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3783,12 +3783,17 @@ void
 ring_buffer_read_finish(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	unsigned long flags;
 
 	/*
 	 * Ring buffer is disabled from recording, here's a good place
-	 * to check the integrity of the ring buffer. 
+	 * to check the integrity of the ring buffer.
+	 * Must prevent readers from trying to read, as the check
+	 * clears the HEAD page and readers require it.
 	 */
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_check_pages(cpu_buffer);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->buffer->resize_disabled);


