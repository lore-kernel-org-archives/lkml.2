Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab0EIUnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:43:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0EIUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=R/rVT1Htkb1yM8H2IdOGVBbV60QxYB1+CHmQBo2++yWIWMj0pmcLdz20qf1ok8X/JQ
         RgiN+2jv9Q9DSEcntoQg1jvR3QlJIB7grQYsMsBlxS6Zzn145F/gXWafwyjxuwDYOixa
         3YG255ZsLXiD4D+E1cWHUvznoQGQS9VL44VuQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf updates
Date: Sun,  9 May 2010 22:43:28 +0200
Message-Id: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/test branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/test

I've already posted the new reordering patches.

Summary:

- Now the reordering works with any kind of raw sample flow. I
  know I already said that with the previous period based reordering,
  but now it seems to be true. I hope...

- Perf lock cleanups and improvements.

- Lock events cleanups

Now I observed we lose a lot of events with perf lock. It's just
that the flow can be so huge that perf record can't keep up with
the buffers, and the kernel often meets the buffer size limit.
Increasing the buffers size makes the things better but it's still not
enough.

In fact we have strong scalability problems that can be solved after
we reach the two following steps:

- I need to unearth the injection thing, so that I'll be able to reduce
the size of the lock events: putting the name in the lock_init event only
and only pass the address of the lock instance in the other lock events.

- Introducing "perf muliplex". The way perf record saves the events by
walking through every counters in a linear way is nice if you have a small
flow and few cpus. I did all my tests on an SMT 2 threads machine (Atom) and
it loses lots of lock events (even with 8192 pages per counters), due to the
huge flow, and this linear walking: the time you read a counter and write the
events to the file, another counter may have reached its buffer size limit already.

Now I can imagine what will be the result after a test on this sparc machine
with 64 cpus.

So we need a perf record mode that does this: multiplex counters buffers per
cpu, so that we have one buffer per cpu. Having one thread per cpu that does its
own cpu record in its own file. Then pass the whole to perf multiplex that can
handle the multiplexing into a single file (useful as a multiplexing remote point
too for perf pipe).

Anyway, lot of work in prevision.

Thanks,
	Frederic
---

Frederic Weisbecker (9):
      perf: Introduce a new "round of buffers read" pseudo event
      perf: Provide a new deterministic events reordering algorithm
      perf: Cleanup perf lock broken states
      perf: Humanize lock flags in perf lock
      perf: Fix perf lock bad rate
      perf lock: Always check min AND max wait time
      tracing: Drop lock_acquired waittime field
      tracing: Drop the nested field from lock_release event
      tracing: Factorize lock events in a lock class

Hitoshi Mitake (2):
      perf lock: Add "info" subcommand for dumping misc information
      perf lock: Drop "-a" option from cmd_record() default arguments set

Tom Zanussi (1):
      perf/live-mode: Handle payload-less events


 include/trace/events/lock.h |   55 +++++-----------
 kernel/lockdep.c            |    4 +-
 tools/perf/builtin-lock.c   |  145 +++++++++++++++++++++++++++++++------------
 tools/perf/builtin-record.c |   34 +++++++---
 tools/perf/util/event.h     |    3 +-
 tools/perf/util/session.c   |  125 ++++++++++++++++++++++++++-----------
 tools/perf/util/session.h   |   36 ++++++-----
 7 files changed, 257 insertions(+), 145 deletions(-)
