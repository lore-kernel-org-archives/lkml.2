Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2FDINe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:13:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40703 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2FDINH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:13:07 -0400
From: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
Date: Mon,  4 Jun 2012 12:09:37 +0400
Message-Id: <1338797382-287275-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you want to know where your code waits locks for a long time?
Yes! It's for you. This feature helps you to find bottlenecks.

It's not artificial task. Once one of my colleague was investigating a
scalability problem. He pressed sysrq-t some times and tried to merge
call-chains by hand. But perf can do that better.

Here is fourth attempt to add this functionality in the kernel.

Previous attempts:
* [PATCH 0/4] trace: add ability to collect call chains of non-current task.

* [PATCH rh6 0/7] Teach perf tool to collect D-state statistics
This version doesn't work for non-root users.

* "sched/tracing: Add a new tracepoint for sleeptime" by Arun Sharma
It has been committed, but then reverted due to performance reason.

This series resolves a problem with events filtering and non-root users.
Before I tried to use sched_stat* events, but it occurs in a context of
another task. For this case logic of perf_event_context* doesn't work.

This series adds one more event sched:sched_switch_finish, it's sent
when a task starts executing on a cpu. When a task goes out from cpu,
sched:sched_switch is sent.

The time difference between sched_switch and sched_switch_finish is a time
when a task wasn't being executed on a cpu.

For profiling sleep time, events of both types should be collected and
filtered by a defined state (interruptible of uninterruptible sleep).

Then events should be post-processed with help "perf inject". It saves the time
of sched_switch event for each process and when it meets stat_switch_finish,
it sets time difference in sample->period and saves this new sample
in the new perf.data.

./perf record -e sched:sched_switch -g --filter 'prev_state == 1' \
	-e sched:sched_switch_finish --filter 'state == 1' -P  ~/foo

./perf inject -i ~/perf.data -o perf.data.new -s

A test program:
#include<unistd.h>
#include<time.h>
#include<sys/select.h>

int main()
{
          struct timespec ts1;
          struct timeval tv1;
          int i;
        long s;


          for (i = 0; i<  2; i++) {
                  ts1.tv_sec = 0;
                  ts1.tv_nsec = 10000000;
                  nanosleep(&ts1, NULL);

                  tv1.tv_sec = 0;
                  tv1.tv_usec = 40000;
                  select(0, NULL, NULL, NULL,&tv1);
                if (i % 100 == 0) {
                        s = time(NULL);
                        while (time(NULL) - s < 4);
                }
          }
        return 1;
}

Profiling results:
# Overhead  Command      Shared Object                  Symbol
# ........  .......  .................  ......................
#
   100.00%      foo  [kernel.kallsyms]  [k] finish_task_switch
                |
                --- finish_task_switch
                    __schedule
                    schedule
                   |          
                   |--79.85%-- schedule_hrtimeout_range_clock
                   |          schedule_hrtimeout_range
                   |          poll_schedule_timeout
                   |          do_select
                   |          core_sys_select
                   |          sys_select
                   |          system_call
                   |          __select
                   |          __libc_start_main
                   |          
                    --20.15%-- do_nanosleep
                              hrtimer_nanosleep
                              sys_nanosleep
                              system_call
                              __GI___libc_nanosleep
                              __libc_start_main

Andrew Vagin (5):
  event: add an event sched_switch_finish
  sched: send the event sched_switch before perf_event_task_sched_out
  sched: save a previous state on task_struct
  perf: teach "perf inject" to work with files
  perf: teach perf inject to merge sched_switch* events

 include/linux/sched.h        |    3 +
 include/trace/events/sched.h |   29 ++++++++++
 kernel/sched/core.c          |    3 +-
 tools/perf/builtin-inject.c  |  119 +++++++++++++++++++++++++++++++++++++++---
 4 files changed, 146 insertions(+), 8 deletions(-)

