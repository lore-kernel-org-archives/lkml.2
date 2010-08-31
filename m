Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0HaPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:32:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0HaPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:32:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=BxAcykQuHfojCi1m5gDf6ImlOQfLwZ1hJqbxMb7ackoFvEj8ehi4d4Y67DaNQmm3I
	wEBr9KDrQWK39NG++7TpA==
Message-ID: <4c7d2072.8eecd80a.6e3a.2dd0@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 31 Aug 2010 17:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com
Subject: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup monitoring
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
counts, not per-thread.

The cgroup to monitor is designated by passing a file descriptor opened
on a new per-cgroup file in the cgroup filesystem (perf_event.perf). The
option must be activated by setting perf_event_attr.cgroup=1 and passing
a valid file descriptor in perf_event_attr.cgroup_fd. Those are the only
two ABI extensions.

The patch also includes changes to the perf tool to make use of cgroup
filtering. Both perf stat and perf record have been extended to support
cgroup via a new -G option. The cgroup is specified per event:

$ perf stat -a -e cycles:u,cycles:u -G test1,test2 -- sleep 1 
 Performance counter stats for 'sleep 1':
         2368881622  cycles                   test1
                  0  cycles                   test2
        1.001938136  seconds time elapsed

Time tracking and scaling are left unmodified at the moment. That means:
  - time_enabled: counts wall-clock between start and stop of the measurement
  - time_running: counts time when event is on the PMU

The scaling done by the perf tool is left unchanged. That means, the
interpretation of the scaled counts is: "number of events if the cgroup
had been active on ALL the monitored CPUs for the ENTIRE duration of the run".
This is all you can infer from what time_enabled and time_running are tracking
today.

The current time tracking is not quite satisfactory. It does not capture the
difference between scaling because of multiplexing of events vs.  cgroup did
not have active threads during the entire measurement. I think this distinction
is important, but tracking it is not obvious given this is not an event-centric
metric.

PATCH 0/2: introduction
PATCH 1/2: kernel changes
PATCH 2/2: perf tool changes

Signed-off-by: Stephane Eranian <eranian@google.com>
