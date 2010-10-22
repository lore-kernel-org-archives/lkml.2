Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0JVSig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:36 -0400
Received: from kroah.org ([198.145.64.141]:45700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab0JVSic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:58 2010
Message-Id: <20101022183558.468329162@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [25/66] ring-buffer: Fix typo of time extends per page
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -389,7 +389,7 @@ static inline int test_time_stamp(u64 de
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
 /* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
 
 int ring_buffer_print_page_header(struct trace_seq *s)
 {


