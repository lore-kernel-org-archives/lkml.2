Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2L1TSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab2L1TSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:34 -0500
Message-Id: <20121228190349.925265935@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 094/173] ring-buffer: Fix NULL pointer if rb_set_head_page() fails
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 54f7be5b831254199522523ccab4c3d954bbf576 upstream.

The function rb_set_head_page() searches the list of ring buffer
pages for a the page that has the HEAD page flag set. If it does
not find it, it will do a WARN_ON(), disable the ring buffer and
return NULL, as this should never happen.

But if this bug happens to happen, not all callers of this function
can handle a NULL pointer being returned from it. That needs to be
fixed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2683,7 +2683,7 @@ unsigned long ring_buffer_oldest_event_t
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret = 0;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2698,7 +2698,8 @@ unsigned long ring_buffer_oldest_event_t
 		bpage = cpu_buffer->reader_page;
 	else
 		bpage = rb_set_head_page(cpu_buffer);
-	ret = bpage->page->time_stamp;
+	if (bpage)
+		ret = bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return ret;
@@ -3005,6 +3006,8 @@ rb_get_reader_page(struct ring_buffer_pe
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 


