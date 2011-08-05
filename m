Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1HEVNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:13:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1HEVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:13:03 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=YWPKDhu-NCoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=FntdOQR-RHBcUzVSkPAA:9 a=rjX_AomzS2HLdhQJOXIA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110805205921.909038487@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 16:59:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: [RFC][PATCH 0/8] Having perf use libparsevent.a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've spent the week working on getting libparsevent.a working with
perf. After several rewrites, hacking in both perf and the trace-cmd
code, and breaking both beyond repair, I finally got to a point that
it just works.

The library was originally going to be called libperf.so, but after
talking with Arnaldo, he wants the functionality of the libraries
separated more, not combined all in one binary. As this code deals
only with the parsing the event formats and creating a way to read
the binary data from it, we both agreed that it is best to keep its
original name that was in trace-cmd and call it libparsevent.so.

Note, because perf installs in the user's ~/bin and I did not want to
make it a requirement to add ~/bin to LD_LIBRARY_PATH, I kept the
library as a .a that is linked directly into perf.

In the beginning, I tried to work with the library code within the
tools/perf directory, and because of the CFLAGS of perf, it made
compiling the library code very nasty (namely the -Wswitch-enum).
I also talked with Arnaldo and Frederic about the placement of this
code, and we all agreed that tools/lib/events is a good place to
put it.

By keeping the code separate from perf, made the transition from
trace-cmd to tools much easier. I've wasted too many days trying to
get other ways working, and I don't want to rewrite perf to do so.

Thus, this is what I ended up with.

This patch set just gets the libparsevent.a/so working with perf.
New code would be required to get it packaged for distributions to
ship as a library itself. Once it gets there, I'll work on getting
this code to work with code like latencytrace.

Anyway, this is still in the RFC phase. Lets hear what people have to
say.

(some of the patches are quite large as they either insert full
files or remove them, and probably will not make LKML due to the
size constraint.)

This patches can be viewed from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/parse-events

Head SHA1: 781d261ff8241243173cf996ceb068cb19bd5874


Julia Lawall (1):
      perf/events: Correct size given to memset

Steven Rostedt (6):
      perf: Separate out trace-cmd parse-events from perf files
      tools/events: Add files to create libparsevent.a
      perf: Build libparsevent.a
      events: Update tools/lib/events to work with perf
      perf: Have perf use the new libparsevent.a library
      perf/events: Add flag to produce nsec output

Tom Zanussi (1):
      perf/events: Add flag/symbol format_flags

----
 tools/lib/events/Makefile                          |  303 ++
 tools/lib/events/event-parse.c                     | 4991 ++++++++++++++++++++
 tools/lib/events/event-parse.h                     |  804 ++++
 tools/lib/events/event-utils.h                     |   80 +
 tools/lib/events/parse-filter.c                    | 2262 +++++++++
 tools/lib/events/parse-utils.c                     |  110 +
 tools/lib/events/trace-seq.c                       |  200 +
 tools/perf/Makefile                                |   17 +-
 tools/perf/builtin-kmem.c                          |    6 +-
 tools/perf/builtin-lock.c                          |   26 +-
 tools/perf/builtin-sched.c                         |   42 +-
 tools/perf/builtin-script.c                        |    2 +-
 .../util/scripting-engines/trace-event-python.c    |   16 +-
 tools/perf/util/trace-event-info.c                 |    4 +-
 tools/perf/util/trace-event-parse.c                | 3188 +------------
 tools/perf/util/trace-event-read.c                 |   34 +-
 tools/perf/util/trace-event.h                      |  268 +-
 17 files changed, 9070 insertions(+), 3283 deletions(-)
