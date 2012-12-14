Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946041Ab2LNXHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:07:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:41364 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945964Ab2LNXHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:07:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 21/27] ring-buffer: Fix NULL pointer if rb_set_head_page() fails
Date: Fri, 14 Dec 2012 15:01:34 -0800
Message-Id: <20121214222255.945457675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1396,6 +1396,8 @@ rb_insert_pages(struct ring_buffer_per_c
 		struct list_head *head_page_with_bit;
 
 		head_page = &rb_set_head_page(cpu_buffer)->list;
+		if (!head_page)
+			break;
 		prev_page = head_page->prev;
 
 		first_page = pages->next;
@@ -2934,7 +2936,7 @@ unsigned long ring_buffer_oldest_event_t
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret = 0;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2949,7 +2951,8 @@ unsigned long ring_buffer_oldest_event_t
 		bpage = cpu_buffer->reader_page;
 	else
 		bpage = rb_set_head_page(cpu_buffer);
-	ret = bpage->page->time_stamp;
+	if (bpage)
+		ret = bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return ret;
@@ -3260,6 +3263,8 @@ rb_get_reader_page(struct ring_buffer_pe
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 


