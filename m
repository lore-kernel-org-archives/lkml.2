Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0LGCNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:13:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0LGCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:30 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=CwHn0hkZcEYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=x1W9GSJL98-rpIlwNZIA:9 a=vCd2TE0DBUYIMB8mEwQA:7 a=LDaQq2ygF38VwiFlvC-qc8ayEbYA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207015834.196176991@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 00/10] incorrect unlikely() and likely() cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my end of year branch annotation cleanups. I compiled my
kernel with:

CONFIG_PROFILE_ANNOTATED_BRANCHES

And booted this on my main work station, as well as a couple of
test boxes. Letting it run for a while I then looked at the results.

 cat /debug/tracing/trace_stat/branch_annotated

Which gives a result looking something like this:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0 366631256 100 sched_info_switch              sched_stats.h        269
       0 211488512 100 sched_info_queued              sched_stats.h        222
       0 197083456 100 sched_info_dequeued            sched_stats.h        177
       0 130545377 100 syscall_trace_enter            ptrace.c             1375
       0 130545340 100 syscall_trace_leave            ptrace.c             1403
       0   326960 100 pre_schedule_rt                sched_rt.c           1476
       0     5214 100 signal_pending                 sched.h              2313
       0     1305 100 trylock_page                   pagemap.h            316

It sorts the list with those that have the highest percentage of
incorrect uses and the largest number of them.

The sched_info_switch() is part of the sched_stats which falls into:

	if (unlikely(1))

And gcc is smart enough to ignore it, but because it uses a static
inline function that returns 1, the branch profiler misses that it
is indeed a constant.

I also ignored those that only had a few hits, like the signal_pending
above.

Anyway, there are 10 areas that I found that really do not need to have
an annotated branch, or the annotation is simply the opposite of
what it should be.

If people are fine with these, I'm hoping to get acks and then push this
out as a real clean up for 2.6.38.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: unlikely/core


Steven Rostedt (10):
      sched: Change rt_task(prev) in pre_schedule_rt to likely
      mm: Remove likely() from mapping_unevictable()
      workqueue: It is likely that WORKER_NOT_RUNNING is true
      sched: Change pick_next_task_rt from unlikely to likely
      mm: Remove likely() from grab_cache_page_write_begin()
      sched: Remove unlikely() from rt_policy() in sched.c
      x86: Remove unlikey()'s from sched_switch segment tests
      fs: Remove unlikely() from fput_light()
      fs: Remove unlikely() from fget_light()
      sched: Remove unlikely() from ttwu_post_activation

----
 arch/x86/kernel/process_64.c |    6 +++---
 fs/file_table.c              |    2 +-
 include/linux/file.h         |    2 +-
 include/linux/pagemap.h      |    2 +-
 kernel/sched.c               |    4 ++--
 kernel/sched_rt.c            |    4 ++--
 kernel/workqueue.c           |    4 ++--
 mm/filemap.c                 |    2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)
