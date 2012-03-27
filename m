Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2C0RZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:25:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2C0RZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:25:23 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=n2uh3H6dhQwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5wsI8ZbckJm5MaKEIRwA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332869121.23924.130.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.4] tracing: Fix ent_size in trace output
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Date: Tue, 27 Mar 2012 13:25:21 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 12b5da349a8b94c9dbc3430a6bc42eabd9eaf50b


Steven Rostedt (1):
      tracing: Fix ent_size in trace output

----
 kernel/trace/trace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
---------------------------
commit 12b5da349a8b94c9dbc3430a6bc42eabd9eaf50b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 27 10:43:28 2012 -0400

    tracing: Fix ent_size in trace output
    
    When reading the trace file, the records of each of the per_cpu buffers
    are examined to find the next event to print out. At the point of looking
    at the event, the size of the event is recorded. But if the first event is
    chosen, the other events in the other CPU buffers will reset the event size
    that is stored in the iterator descriptor, causing the event size passed to
    the output functions to be incorrect.
    
    In most cases this is not a problem, but for the case of stack traces, it
    is. With the change to the stack tracing to record a dynamic number of
    back traces, the output depends on the size of the entry instead of the
    fixed 8 back traces. When the entry size is not correct, the back traces
    would not be fully printed.
    
    Note, reading from the per-cpu trace files were not affected.
    
    Reported-by: Thomas Gleixner <tglx@linutronix.de>
    Tested-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: stable@vger.kernel.org
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3a19c35..ed7b5d1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1698,6 +1698,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
+	int next_size = 0;
 	int cpu;
 
 	/*
@@ -1729,9 +1730,12 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 			next_cpu = cpu;
 			next_ts = ts;
 			next_lost = lost_events;
+			next_size = iter->ent_size;
 		}
 	}
 
+	iter->ent_size = next_size;
+
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 


