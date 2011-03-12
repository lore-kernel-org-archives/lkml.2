Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1CLW7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:59:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1CLW7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:59:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: [PATCH 0/2] tracing - avoid soft lockup in trace_pipe
Date: Sat, 12 Mar 2011 23:59:44 +0100
Message-Id: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

running following commands:

  echo 1 > ./options/bin
  echo 0 > ./options/context-info 
  echo 1 > ./events/enable
  cat trace_pipe

is causing soft lockup inside tracing_read_pipe function.

The reason is, that bin/hex/raw output functions for events
are set to trace_nop_print function, which prints nothing
and returns TRACE_TYPE_HANDLED value.

So, choosing:
	- NON preemptive kernel
	- trace only events
	- enable bin/hex options
	  (raw option traces new line always, so it will get out eventually).
	- disable all other output (context-info option)

will cause the tracing_read_pipe to loop forever, because the only
loop escapes are:
	1) ring buffer is empty
	2) TRACE_TYPE_PARTIAL_LINE returned from trace output function
	3) trace_seq buffer limit is reached

ad 1)
with all events enabled, the other CPU(s) keep ring buffer full
(did not try on single CPU machine)

ad 2)
with all other output disabled, the only called trace function
is trace_nop_print, which returns TRACE_TYPE_HANDLED

ad 3)
the only traced information is LOST EVENT trace, but it's
without the check for the trace_seq limit crossing, so
we stay in the loop


The attached patch (1/2) fixies handling of lost event trace.
This change will also make the soft lockup practically disappear,
since I think there will allways be some lost events, which will
cause the trace_seq buffer overflow and escape the loop.


To improve the latency and make sure we won't stuck if there are no
lost events, I added to the loop (patch 2/2):
	- cond_resched call
	- check for signal to leave the loop


Attached patches:
1/2 - tracing - trace lost events properly
2/2 - tracing - putting cond_resched into tace_pipe loop

Thanks a lot to Oleg Nestorov for helping me to nail this down.

..hopefully I haven't missed anything ;)

wbr,
jirka
---
 kernel/trace/trace.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)
