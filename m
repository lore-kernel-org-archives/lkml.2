Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0LWVex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:34:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0LWVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:34:52 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=sqw2Nl7Ct-0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=d-wDrMSHQv5-kywdKZwA:9 a=QkPOL82YO5_bwPJXs87OUEoKP8oA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=hqhBMZh6TR9b-_Li:21 a=sno2uU1qoE7dbd5g:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.37] ring_buffer: Off-by-one and duplicate
 events in ring_buffer_read_page
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Sharp <dhsharp@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 16:34:49 -0500
Message-ID: <1293140089.22802.400.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


David Sharp (1):
      ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page

----
 kernel/trace/ring_buffer.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)
---------------------------
commit e1e359273576ee8fe27021356b064c772ed29af3
Author: David Sharp <dhsharp@google.com>
Date:   Wed Dec 22 16:38:24 2010 -0800

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


