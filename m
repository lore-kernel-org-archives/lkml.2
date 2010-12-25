Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0LYI7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 03:59:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:51285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0LYI72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 03:59:28 -0500
Date: Sat, 25 Dec 2010 08:59:15 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
References: <1293064704-8101-1-git-send-email-dhsharp@google.com>
	<AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page
Message-ID: <tip-e1e359273576ee8fe27021356b064c772ed29af3@git.kernel.org>
Git-Commit-ID: e1e359273576ee8fe27021356b064c772ed29af3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 25 Dec 2010 08:59:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1e359273576ee8fe27021356b064c772ed29af3
Gitweb:     http://git.kernel.org/tip/e1e359273576ee8fe27021356b064c772ed29af3
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Wed, 22 Dec 2010 16:38:24 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Dec 2010 12:09:30 -0500

ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page

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
LKML-Reference: <1293064704-8101-1-git-send-email-dhsharp@google.com>
LKML-Reference: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
