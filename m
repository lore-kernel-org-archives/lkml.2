Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab0JFJLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:11:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0JFJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=nGucGkv8kpbKBj2R3PyBtevmPisfap7EgE8+UeIJ8smvkIhrrnJp3RTsEHdn6RRqUJ
         UVSz0V1/k00UqPdZwiGw==
Message-ID: <4cac3d28.aae9d80a.24a1.1990@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 6 Oct 2010 11:08:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup monitoring (v4)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds per-container (cgroup) filtering capability
to per-cpu monitoring. In other words, we can monitor all threads belonging
to a specific cgroup and running on a specific CPU. 

This is useful to measure what is going on inside a cgroup. Something that
cannot easily and cheaply be achieved with either per-thread or per-cpu mode.
Cgroups can span multiple CPUs. CPUs can be shared between cgroups. Cgroups
can have lots of threads. Threads can come and go during a measurement.

To measure per-cgroup today requires using per-thread mode and attaching to
all the current threads inside a cgroup and tracking new threads. That would
require scanning of /proc/PID, which is subject to race conditions, and
creating an event for each thread, each event requiring kernel memory.

The approach taken by this patch is to leverage the per-cpu mode by simply
adding a filtering capability on context switch only when necessary. That
way the amount of kernel memory used remains bound by the number of CPUs.
We also do not have to scan /proc. We are only interested in cgroup level
counts, samples and not thread level.

The cgroup to monitor is designated by passing a file descriptor opened
on the cgroup directory name in the cgroup filesystem. The cgroup mode
is activated by passing a flag value in the perf_event syscall.

The patch also includes changes to the perf tool to make use of cgroup
filtering. Both perf stat and perf record have been extended to support
cgroup via a new -G option. The cgroup is specified per event:

$ perf stat -B -a -e cycles:u,cycles:u,cycles:u -G test1,,test2 -- sleep 1
 Performance counter stats for 'sleep 1':

      2,368,667,414  cycles                   test1
      2,369,661,459  cycles                  
      <not counted>  cycles                   test2

        1.001856890  seconds time elapsed

Here, we measure cycles in 3 different cgroups. When a cgroup is omitted,
the "root" cgroup is used, i.e., all threads executing on the monitored
CPUs are measured.

In the second version, time tracking has been updated. In cgroup mode,
time_enabled tracks the time during which the cgroup was active, i.e., threads
from the cgroup executed on the monitored CPU. The meaning of time_running
is unchanged. In non-cgroup mode, time_enabled stills tracks wall-clock time
for per-cpu events. Here is an example:

In one shell I do:
$ echo $$ >/cgroup/test1/perf_events.perf
$ taskset -c 1 noploop 600
In another shell I do:
$ taskset -c 1 noploop 600

Both noploops are competing on CPU1 (part of cgroup test1)

$ perf stat -B -a -e cycles:u,cycles:u,cycles:u -G test1,,test2 -- sleep 1
 Performance counter stats for 'sleep 1':

      1,190,595,954  cycles                   test1
      2,372,471,023  cycles                  
      <not counted>  cycles                   test2

        1.001845567  seconds time elapsed

The second count reflects activity across all CPUs and cgroups.
The first count reflects was happened inside cgroup test1. As shown,
the noploop running inside test1, only got half the CPU time.

In the third version, we have dropped dependency on NR_CPUS
in favor of dynamic allocation with alloc_percpu(). We have
also renamed get_event_time() to something more explicit:
perf_event_time(). We cleaned the code so it compiles with
CONFIG_CGROUPS disabled. We have also fixed a bug in the
perf tool sampling module builtin-record.c

In this fourth version, we have dropped changes to perf_event_attr.
Instead we pass the cgroup file descriptor in the pid argument to
the syscall and we active cgroup mode by passing PERF_FLAG_PID_CGROUP
into flags.

PATCH 0/2: introduction
PATCH 1/2: kernel changes
PATCH 2/2: perf tool changes

Signed-off-by: Stephane Eranian <eranian@google.com>
