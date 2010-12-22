Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0LVXpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:45:51 -0500
Received: from smtp-out.google.com ([74.125.121.67]:50100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab0LVXpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:45:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=GESgAUr3TbQgJtwvgZvrfJu4lZ6hxcXpQjUhvw40Tc4J33VTdYR0XGk8tFtFrat0F
	ncYHGrsN3j6pduuOVF0YQ==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.net
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        David Sharp <dhsharp@google.com>
Subject: [PATCH] ring_buffer: off-by-one and duplicate events in ring_buffer_read_page
Date: Wed, 22 Dec 2010 15:45:34 -0800
Message-Id: <1293061534-6947-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
References: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two related problems in the event-copying loop of
ring_buffer_read_page.

The loop condition for copying events is off-by-one.
"len" is the remaining space in the caller-supplied page.
"size" is the size of the next event (or two events).
If len == size, then there is just enough space for the next event.

size was set to rb_event_ts_length, which may include the size of two
events if the first event is a time-extend, in order to assure time-
extends are kept together with the event after it. However,
rb_advance_reader always advances by one event. This would result in the
event after any time-extend being duplicated. Instead, get the size of
a single event for the memcpy, but use rb_event_ts_length for the loop
condition.

Signed-off-by: David Sharp <dhsharp@google.com>
CC: Steven Rostedt <rostedt@goodmis.net>
LKML-Reference: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
---
 kernel/trace/ring_buffer.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9ed509a..bd1c35a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3853,6 +3853,13 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 		/* Need to copy one event at a time */
 		do {
+			/* We need the size of one event, because
+			 * rb_advance_reader only advances by one event,
+			 * whereas rb_event_ts_length may include the size of
+			 * one or two events.
+			 * We have already ensured there's enough space if this
+			 * is a time extend. */
+			size = rb_event_length(event);
 			memcpy(bpage->data + pos, rpage->data + rpos, size);
 
 			len -= size;
@@ -3867,7 +3874,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			event = rb_reader_event(cpu_buffer);
 			/* Always keep the time extend and data together */
 			size = rb_event_ts_length(event);
-		} while (len > size);
+		} while (len >= size);
 
 		/* update bpage */
 		local_set(&bpage->commit, pos);
-- 
1.7.3.1

