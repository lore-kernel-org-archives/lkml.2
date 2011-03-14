Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1CNTSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:18:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1CNTSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ywg0fUpsPcOrDgXWWAwj7AhFByJVcek1aui47TAU/M2bZ0uB1/pRv1plZ/YZDit2Pd
         COOL0ypXOZ7X+S+Ma7/aUMhD6ZVbtgB2FCuEhsgqLnKHNKZt0lxYWmsFID9SaaQwfbCU
         Hh1aDwgAq6xsscZpVV9fFFNdJWX/wFs7G2DhY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [RFC PATCH 0/4] perf: Custom contexts
Date: Mon, 14 Mar 2011 20:17:59 +0100
Message-Id: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follows an old patchset I did which was called context
exclusion, which implemented a suggestion from Ingo to
exclude interrupt contexts from counting/sampling on
chosen events. Besides, he also suggested to use the
function graph tracer to count/sample events inside
a function boundaries.

All in one, this is all about events that activate/deactivate
others. So it sounds quite natural to use what we already use to
abstract events: perf events, in order to start/stop other perf events.
May be that was also suggested by Ingo or someone else, or not,
can't remember.

This is implemented using a pair of events: a starter and a stopper.
One can attribute one starter and one stopper to a target event.

When the starter generates an events, it starts the target,
making it counting and sampling. When the stopper generates
an event, it stops the target. That combined with an attribute
called "enable_on_starter" that put the event into a paused state,
even when it is scheduled, waiting for the starter to start it
once.

We have three new options:

	* --starter and --stopper. These follow the target event
	and must be followed by the index of the starter/stopper event
	in the command line.
	
	* --enable-on-starter creates the event in pause mode, it won't
	be started until the starter triggers.
	
Some examples:

- Trace lock events inside irqs

	$ perf record -e irq:irq_handler_entry -e irq:irq_handler_exit \
		-e lock:lock_acquire --starter 0 --stopper 1 --enable-on-starter \
		perf bench sched messaging
		
	$ perf script
	
	perf-4300  [000]  2000.209721: irq_handler_entry: irq=40 name=ahci
            perf-4300  [000]  2000.209725: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
            perf-4300  [000]  2000.209731: irq_handler_exit: irq=40 ret=handled
            perf-4300  [000]  2000.209821: irq_handler_entry: irq=40 name=ahci
            perf-4300  [000]  2000.209823: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
            perf-4300  [000]  2000.209828: irq_handler_exit: irq=40 ret=handled

- Count instructions inside softirqs, outside softirqs and everywhere:

	$ perf stat -e irq:softirq_entry -e irq:softirq_exit \
		-e instructions --starter 0 --stopper 1 --enable-on-starter \
		-e instructions --starter 1 --stopper 0 \
		-e instructions ./perf bench sched messaging
		
	# Running sched/messaging benchmark...
	# 20 sender and receiver processes per group
	# 10 groups == 400 processes run

	     Total time: 1.056 [sec]

	 Performance counter stats for './perf bench sched messaging':

		       114 irq:softirq_entry       
		       114 irq:softirq_exit        
		   821 503 instructions             #      0,000 IPC  <-- inside softirq
	       243 985 460 instructions             #      0,000 IPC  <-- outside softirq
	       244 594 383 instructions             #      0,000 IPC  <-- all

		1,157462964  seconds time elapsed
		
	All instructions must be inside + outside softirqs. However there is always a small
	delta (here the delta is of 212 580) due to some noise.
	
There is another example with lock events in the last patch.

It's supposed to support infinite combinations with starter having starters
themselves, plus filters, etc...
	
Some limitations:

* An event can only have one starter and one stopper. This can be
changed if necessary. Letting more would allow us to union custom
contexts.

* Starters and stoppers must be on the same context (task + cpu) than
the target. That can probably be more or less easy to change too.

* There are many code duplications. But I wanted to know if it's
worth continuing that direction before cleaning up.

* What you'll find.

Adventurers can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/custom-ctx-v1
	
This is on top of three previous patches I posted lately.

Thanks.
	

Frederic Weisbecker (4):
  perf: Starter and stopper events
  perf: New enable_on_starter attribute
  perf: Support for starter and stopper in tools
  perf: New --enable-on-starter option

 include/linux/perf_event.h     |   14 ++-
 kernel/perf_event.c            |  298 +++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-record.c    |   20 +++-
 tools/perf/builtin-stat.c      |   22 +++-
 tools/perf/util/evlist.c       |   12 +-
 tools/perf/util/evlist.h       |    4 +-
 tools/perf/util/evsel.c        |   53 +++++++
 tools/perf/util/evsel.h        |   13 ++
 tools/perf/util/parse-events.c |   78 +++++++++++
 tools/perf/util/parse-events.h |    3 +
 10 files changed, 485 insertions(+), 32 deletions(-)

-- 
1.7.3.2

