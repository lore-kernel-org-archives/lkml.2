Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1ABHkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:40:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:36660 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1ABHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 182/260] ring-buffer: Fix typo of time extends per page
Date: Sun,  2 Jan 2011 02:17:58 -0500
Message-Id: <1293952756-15010-183-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:30.0166 (UTC) FILETIME=[F4839960:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

commit d01343244abdedd18303d0323b518ed9cdcb1988 upstream.

Time stamps for the ring buffer are created by the difference between
two events. Each page of the ring buffer holds a full 64 bit timestamp.
Each event has a 27 bit delta stamp from the last event. The unit of time
is nanoseconds, so 27 bits can hold ~134 milliseconds. If two events
happen more than 134 milliseconds apart, a time extend is inserted
to add more bits for the delta. The time extend has 59 bits, which
is good for ~18 years.

Currently the time extend is committed separately from the event.
If an event is discarded before it is committed, due to filtering,
the time extend still exists. If all events are being filtered, then
after ~134 milliseconds a new time extend will be added to the buffer.

This can only happen till the end of the page. Since each page holds
a full timestamp, there is no reason to add a time extend to the
beginning of a page. Time extends can only fill a page that has actual
data at the beginning, so there is no fear that time extends will fill
more than a page without any data.

When reading an event, a loop is made to skip over time extends
since they are only used to maintain the time stamp and are never
given to the caller. As a paranoid check to prevent the loop running
forever, with the knowledge that time extends may only fill a page,
a check is made that tests the iteration of the loop, and if the
iteration is more than the number of time extends that can fit in a page
a warning is printed and the ring buffer is disabled (all of ftrace
is also disabled with it).

There is another event type that is called a TIMESTAMP which can
hold 64 bits of data in the theoretical case that two events happen
18 years apart. This code has not been implemented, but the name
of this event exists, as well as the structure for it. The
size of a TIMESTAMP is 16 bytes, where as a time extend is only
8 bytes. The macro used to calculate how many time extends can fit on
a page used the TIMESTAMP size instead of the time extend size
cutting the amount in half.

The following test case can easily trigger the warning since we only
need to have half the page filled with time extends to trigger the
warning:

 # cd /sys/kernel/debug/tracing/
 # echo function > current_tracer
 # echo 'common_pid < 0' > events/ftrace/function/filter
 # echo > trace
 # echo 1 > trace_marker
 # sleep 120
 # cat trace

Enabling the function tracer and then setting the filter to only trace
functions where the process id is negative (no events), then clearing
the trace buffer to ensure that we have nothing in the buffer,
then write to trace_marker to add an event to the beginning of a page,
sleep for 2 minutes (only 35 seconds is probably needed, but this
guarantees the bug), and then finally reading the trace which will
trigger the bug.

This patch fixes the typo and prevents the false positive of that warning.

Reported-by: Hans J. Koch <hjk@linutronix.de>
Tested-by: Hans J. Koch <hjk@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1b6197a..f25b8af 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -399,7 +399,7 @@ static inline int test_time_stamp(u64 delta)
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
 /* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
 
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
-- 
1.7.3.3

