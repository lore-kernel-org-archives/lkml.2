Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0JLRyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:54:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52276 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab0JLRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:54:06 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=Gd5JVupL5ikA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=yppLX3Z0qnt9SQBmu7QA:9 a=yxhx1AI7oME6mdu1f4MA:7 a=783DsFpV42vdo0A2YG7CFN-tdFoA:4 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=gLI6-oKHPfr-19uV:21 a=EEbfmz9ckX6A5Geh:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] ring-buffer: Fix typo of time extends per page
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 13:54:00 -0400
Message-ID: <1286906040.4519.16.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is a one line fix to a false positive warning that disables tracing.
It may be too late for 2.6.36, but I'll let the powers that be decide that.
I've Cc'd stable just in case.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Steven Rostedt (1):
      ring-buffer: Fix typo of time extends per page

----
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit d01343244abdedd18303d0323b518ed9cdcb1988
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Oct 12 12:06:43 2010 -0400

    ring-buffer: Fix typo of time extends per page
    
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
    Cc: Stable Kernel <stable@kernel.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 492197e..bca9637 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,7 +405,7 @@ static inline int test_time_stamp(u64 delta)
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
 /* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
 
 int ring_buffer_print_page_header(struct trace_seq *s)
 {


