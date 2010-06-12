Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0FLHe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:34:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0FLHe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=EqnjMM/Bqv4Z5A17gqUowDBWdu8JZX2Qw48tGB1+FfdjAit5nvUsbnSAm/dgWx2w4u
         1cNO0CCebH+O+tGfcm+ScRcDfkcfQHOudmEgSP1MOSqJ5qcEtLNQwzK/B/HSDOyij+yH
         c2bGXCW6OQujEL59z0Hxhiz9xvEIPgs6fEj3c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/5 v3] perf events finer grained context instrumentation / context exclusion
Date: Sat, 12 Jun 2010 09:34:53 +0200
Message-Id: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this new version, the weird hangs have been fixed. They were
due to some ACTIVE state checks that didn't handle the paused
mode.

And also comes a new pmu->reserve callback to schedule an event
on the cpu without actually starting it (as if ->stop() was
just called in it).
In x86 it is the same than the enable() callback, the decision
to activate the event beeing eventually handled by checking the
PERF_EVENT_STATE_PAUSED. On software events it is a stub as
they can be activated anytime in a lightweight fashion, without
the need to fight against a finite resource.

BTW, there is a quite handy way to make a diff between task
context and task + irq context profiling.

Just run:

sudo ./perf stat -r 10 -e task-clock -e task-clock:t -e cs -e cs:t \
	-e migrations -e migrations:t -e faults -e faults:t -e cycles \
	-e cycles:t -e instructions -e instructions:t -e branches \
	-e branches:t -e branch-misses -e branch-misses:t taskset 1 hackbench 1

(Did I just say handy?)

Example of result:

 Performance counter stats for 'taskset 1 hackbench 1' (10 runs):

         604,727182  task-clock-msecs         #      0,969 CPUs    ( +-   6,176% )
         604,727182  task-clock-msecs         #      0,969 CPUs    ( +-   6,176% )
              11584  context-switches         #      0,019 M/sec   ( +-  26,945% )
              11593  context-switches         #      0,019 M/sec   ( +-  26,909% )
                  1  CPU-migrations           #      0,000 M/sec   ( +-  61,464% )
                  0  CPU-migrations           #      0,000 M/sec   ( +- 100,000% )
               1844  page-faults              #      0,003 M/sec   ( +-   1,425% )
               1847  page-faults              #      0,003 M/sec   ( +-   1,423% )
          917442262  cycles                   #   1517,118 M/sec   ( +-   6,814% )  (scaled from 69,40%)
          908980892  cycles                   #   1503,126 M/sec   ( +-   5,807% )  (scaled from 68,51%)
          335812687  instructions             #      0,368 IPC     ( +-   6,977% )  (scaled from 73,77%)
          321284628  instructions             #      0,352 IPC     ( +-   6,377% )  (scaled from 20,59%)
           48956776  branches                 #     80,957 M/sec   ( +-   5,936% )  (scaled from 22,67%)
           48144741  branches                 #     79,614 M/sec   ( +-   6,480% )  (scaled from 21,68%)
            2310259  branch-misses            #      4,758 %       ( +-   9,698% )  (scaled from 15,11%)
            2200507  branch-misses            #      4,532 %       ( +-   9,294% )  (scaled from 15,35%)

        0,624082951  seconds time elapsed   ( +-   5,939% )


Most of the time, the instruction counter diff shows that irqs take 0.01% of noise
with hackbench. Something that does more IO would probably be a more
interesting example.

The thing is pullable there:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/exclusion-4

Thanks.


Frederic Weisbecker (5):
  perf: Provide a proper stop action for software events
  perf: Support disable() after stop() on software events
  perf: Ability to enable in a paused mode
  perf: Introduce task, softirq and hardirq contexts exclusion
  perf: Support for task/softirq/hardirq exclusion on tools

 arch/x86/kernel/cpu/perf_event.c |    7 +-
 include/linux/perf_event.h       |   52 ++++++++-
 kernel/hw_breakpoint.c           |    1 +
 kernel/perf_event.c              |  257 +++++++++++++++++++++++++++++++-------
 kernel/softirq.c                 |    6 +
 kernel/trace/trace_event_perf.c  |    2 +-
 tools/perf/util/parse-events.c   |   37 ++++--
 7 files changed, 302 insertions(+), 60 deletions(-)

