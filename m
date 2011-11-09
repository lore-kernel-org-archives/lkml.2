Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab1KJFRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:17:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935Ab1KJDY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:09 2011
Message-Id: <20111109212709.336176239@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [088/262] tracing: Fix returning of duplicate data after EOF in trace_pipe_raw
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 436fc280261dcfce5af38f08b89287750dc91cd2 upstream.

The trace_pipe_raw handler holds a cached page from the time the file
is opened to the time it is closed. The cached page is used to handle
the case of the user space buffer being smaller than what was read from
the ring buffer. The left over buffer is held in the cache so that the
next read will continue where the data left off.

After EOF is returned (no more data in the buffer), the index of
the cached page is set to zero. If a user app reads the page again
after EOF, the check in the buffer will see that the cached page
is less than page size and will return the cached page again. This
will cause reading the trace_pipe_raw again after EOF to return
duplicate data, making the output look like the time went backwards
but instead data is just repeated.

The fix is to not reset the index right after all data is read
from the cache, but to reset it after all data is read and more
data exists in the ring buffer.

Reported-by: Jeremy Eder <jeder@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3704,8 +3704,6 @@ tracing_buffers_read(struct file *filp,
 	if (info->read < PAGE_SIZE)
 		goto read;
 
-	info->read = 0;
-
 	trace_access_lock(info->cpu);
 	ret = ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
@@ -3715,6 +3713,8 @@ tracing_buffers_read(struct file *filp,
 	if (ret < 0)
 		return 0;
 
+	info->read = 0;
+
 read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)


