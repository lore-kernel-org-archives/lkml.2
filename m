Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2DEWsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:48:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63387 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2DEWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:48:11 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: [RFC][PATCH 00/15] tools: Unify perf and trace-cmd trace event format parsing v2
Date: Fri,  6 Apr 2012 00:47:51 +0200
Message-Id: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

So this is a new iteration of the libtracevent library, basically a
rebase of https://lkml.org/lkml/2011/8/5/299 against latest progresses
(latest tip/perf/core + tip/perf/urgent).

This library unifies the trace events parsing code between perf and
trace-cmd. I initially took this parsing code from trace-cmd to make
perf able to display trace-events and play with their contents.

But there is a continuous drift between perf and trace-cmd trace event
parsing code since then because the fork I did and the original code in
trace-cmd have never merged into a common entity. As a result, perf
stays backward because we haven't ported all the progresses that
trace-cmd did in this area.

Considering the reactions after the last attempt, it appears the
unification of this code is uncontroversial. What seem to cause 
problems is how we do it:

- as an internal library inside perf, where other tools can hook
- as a self-contained library in tools/lib, independant from perf

The argument for the first solution was that trace events format
is not mature enough to be available for any tool and thus it's too
early to release a library that would engrave into the stone an
interface to it, preventing the events format from evolving in the
future.

However users of trace events are there already and they all use
their own parsing. They sometimes wrongly rely on the stability of a
whole event layout or its ascii structure. The lack of a common and
independant library is eventually what prevents us from doing progresses
or make evolutions on trace events.

So I think we really need to restart the debate. We strongly need to make
progresses in this area so I'm posting this iteration in the hope we
can move forward. With the coming of uprobes, there are some chances
that our tracing becomes more important in the future. Let's join
our efforts.

Thanks.

Julia Lawall (1):
  perf/events: Correct size given to memset

Steven Rostedt (10):
  perf: Separate out trace-cmd parse-events from perf files
  tools/events: Add files to create libtraceevent.a
  perf: Build libtraceevent.a
  events: Update tools/perf/lib/traceevent to work with perf
  perf: Have perf use the new libtraceevent.a library
  perf/events: Add flag to produce nsec output
  parse-events: Let pevent_free() take a NULL pointer
  parse-events: Allow '*' and '/' operations in TP_printk
  parse-event: Fix memset pointer size bug in handle
  parse-events: Rename struct record to struct pevent_record

Tom Zanussi (1):
  perf/events: Add flag/symbol format_flags

Vaibhav Nagarnaik (3):
  parse-events: Handle invalid opcode parsing gracefully
  parse-events: Handle opcode parsing error
  parse-events: Support '+' opcode in print format

 tools/lib/traceevent/Makefile                      |  303 ++
 tools/lib/traceevent/event-parse.c                 | 5065 ++++++++++++++++++++
 tools/lib/traceevent/event-parse.h                 |  804 ++++
 tools/lib/traceevent/event-utils.h                 |   80 +
 tools/lib/traceevent/parse-filter.c                | 2262 +++++++++
 tools/lib/traceevent/parse-utils.c                 |  110 +
 tools/lib/traceevent/trace-seq.c                   |  200 +
 tools/perf/Makefile                                |   17 +-
 tools/perf/builtin-kmem.c                          |    6 +-
 tools/perf/builtin-lock.c                          |   26 +-
 tools/perf/builtin-sched.c                         |   42 +-
 tools/perf/builtin-script.c                        |    2 +-
 .../util/scripting-engines/trace-event-python.c    |   16 +-
 tools/perf/util/trace-event-info.c                 |    4 +-
 tools/perf/util/trace-event-parse.c                | 3220 +------------
 tools/perf/util/trace-event-read.c                 |   44 +-
 tools/perf/util/trace-event.h                      |  269 +-
 17 files changed, 9157 insertions(+), 3313 deletions(-)
 create mode 100644 tools/lib/traceevent/Makefile
 create mode 100644 tools/lib/traceevent/event-parse.c
 create mode 100644 tools/lib/traceevent/event-parse.h
 create mode 100644 tools/lib/traceevent/event-utils.h
 create mode 100644 tools/lib/traceevent/parse-filter.c
 create mode 100644 tools/lib/traceevent/parse-utils.c
 create mode 100644 tools/lib/traceevent/trace-seq.c

-- 
1.7.5.4

