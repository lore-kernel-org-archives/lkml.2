Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1BQS07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:26:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42135 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab1BQS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:26:58 -0500
Date: Thu, 17 Feb 2011 19:26:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Funny perf
Message-ID: <20110217182658.GA23443@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've been playing with latest perf (tip/perf/core) and I'm hitting the
warning in perf_session_queue_event() "Warning: Timestamp below last
timeslice flush" which means IMHO that the timestamps of each sample are
not monotonically increasing, as expected. But here's what I do, it could very
well be that I'm doing it wrong:

$ perf probe sched_clock_tick
$ perf record -f -e probe:sched_clock_tick -a -g ./nbench
$ perf report -g --stdio

Warning:...

The interesting thing is that dropping the '-a', i.e. "all-cpus" option
from perf record doesn't trigger the warning anymore.

Then, I added some silly debug output to see what happens:

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..79c7184 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -622,6 +622,7 @@ static int perf_session_queue_event(struct perf_session *s, union perf_event *ev
 
        if (timestamp < s->ordered_samples.last_flush) {
                printf("Warning: Timestamp below last timeslice flush\n");
+               printf("ts: %lu <-> %lu (last_flush), cpu: %d\n", timestamp, s->ordered_samples.last_flush, sample->cpu)
                return -EINVAL;
        }

Result:

...

Warning: Timestamp below last timeslice flush
ts: 10304235947415373581 <-> 18446744069414589173 (last_flush), cpu: -8321639
Warning: Timestamp below last timeslice flush
ts: 72057594029606669 <-> 18446744069414589173 (last_flush), cpu: 0
Warning: Timestamp below last timeslice flush
ts: 18446744069414584320 <-> 18446744069414589173 (last_flush), cpu: 0
Warning: Timestamp below last timeslice flush
ts: 6052837899177642039 <-> 18446744069414589173 (last_flush), cpu: -8323025
Warning: Timestamp below last timeslice flush
ts: 8502796096467174809 <-> 18446744069414589173 (last_flush), cpu: -8321142
Warning: Timestamp below last timeslice flush
ts: 648518346358128639 <-> 18446744069414589173 (last_flush), cpu: 16777216
Warning: Timestamp below last timeslice flush
ts: 11 <-> 18446744069414589173 (last_flush), cpu: -128
Warning: Timestamp below last timeslice flush
ts: 4755801206503243774 <-> 18446744069414589173 (last_flush), cpu: 16441
Warning: Timestamp below last timeslice flush
ts: 4294967295 <-> 18446744069414589173 (last_flush), cpu: 9
Warning: Timestamp below last timeslice flush
ts: 17654401922121072640 <-> 18446744069414589173 (last_flush), cpu: -16777198
Warning: Timestamp below last timeslice flush
ts: 2017612633061998649 <-> 18446744069414589173 (last_flush), cpu: -637534208
...

so this looks like some of the samples do not belong in the perf.data
output with that garbled cpu field. It lets me also assume that the
sample->time field is also crap so the timestamp check is falsely
tripped.

But this is all I got, now you can tell me how much I suck :).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
