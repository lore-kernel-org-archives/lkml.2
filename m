Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab0EAGl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 02:41:29 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:63512 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0EAGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 02:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WcAE6XRBNh/MbHC/DTbi6zOC2YtA8mH+N92BXlbqcrYyPjT4RbGHMhi/uYXJCz1pIX
         xPg0o1Jdih0Y3i27Y2qDtAfLRiuXp779DqfFdmUr7KwX8q9T6FSZqJDEbW8+vA66K3e+
         aSMuIInXuClhOEozqKW/k5OVxDsLZuCdpd/oE=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [RFC][PATCH 0/2] perf/live buildid
Date: Sat,  1 May 2010 01:41:18 -0500
Message-Id: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this patchset removes the current live-mode build
id support, which probably makes sense to apply independent of the
second.

The second is an RFC patch whose immediate purpose is to replace the
current build-id support in 'live mode' with something that makes more
sense for live mode - injecting the build ids before the samples that
use them.

To do that, a new perf command, perf-inject, is introduced.

perf-inject basically pipes the stdout received from live-mode
perf-record to the stdin of live-mode perf-report, but in-between
provides a means for the event stream to be interpreted and augmented
with 'injected events'.

In this case, the injected events are the same build-ids recorded in
the current version, but provided in a more timely fashion.

perf-inject is meant to be a live-mode-only utility and normally
provides no output other than the stdout piping that is its purpose;
the output below uses the -v options on both perf-inject and
perf-report to show what it's basically doing.

I haven't had time to try it out yet, but the idea would be that if
you had the relevant build-ids on a remote system, say via
perf-archive, you'd be able to run a live-mode perf session on one
system and have the output displayed live on the remote system.

Currently perf-inject is used only to provide build-ids, but it should
be easy to add support for other injected events e.g. it could be used
to look up and create uid->user name events, or syscall id->syscall
name events.

root@tropicana:~/perf-scripts# perf record -o - ./hackbench 10 | perf inject -v -b | perf report -v -i -

Running with 10*40 (== 400) tasks.
Time: 0.696
Looking at the vmlinux_path (5 entries long)
Using /lib/modules/2.6.34-rc5/build/vmlinux for symbols
build id found for /lib/modules/2.6.34-rc5/build/vmlinux: a925642e28500d4aeaffc62b2fc9071641ba303c
build id event received for /lib/modules/2.6.34-rc5/build/vmlinux: a925642e28500d4aeaffc62b2fc9071641ba303c
Looking at the vmlinux_path (5 entries long)
no build_id found for /lib/libc-2.8.90.so
build id found for ./hackbench: 1f1a90c20ffd00527b6002483df73a96540f041e
no build_id found for /lib/libpthread-2.8.90.so
Using /lib/modules/2.6.34-rc5/build/vmlinux for symbols
build id event received for ./hackbench: 1f1a90c20ffd00527b6002483df73a96540f041e
build id found for /lib/modules/2.6.34-rc5/kernel/drivers/net/forcedeth.ko: fdeed20f17ce5ba3c12d9a0f5d9add57db7e8d3f
build id event received for /lib/modules/2.6.34-rc5/kernel/drivers/net/forcedeth.ko: fdeed20f17ce5ba3c12d9a0f5d9add57db7e8d3f
no build_id found for /lib/ld-2.8.90.so
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.121 MB - (~5299 samples) ]
# Samples: 2019104685
#
# Overhead    Command                                            Shared Object  Symbol
# ........  .........  .......................................................  ......
#
     8.22%  hackbench  /lib/modules/2.6.34-rc5/build/vmlinux                    0xffffffff811fbb5d ! [k] copy_user_generic_string
     7.12%  hackbench  /lib/modules/2.6.34-rc5/build/vmlinux                    0xffffffff8111ef55 ! [k] kfree

Tom Zanussi (2):
  perf/live: don't synthesize build ids at the end of a live mode trace
  perf: add perf-inject builtin

 tools/perf/Makefile                |    1 +
 tools/perf/builtin-annotate.c      |    2 +-
 tools/perf/builtin-buildid-list.c  |    2 +-
 tools/perf/builtin-diff.c          |    4 +-
 tools/perf/builtin-inject.c        |  228 ++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-kmem.c          |    2 +-
 tools/perf/builtin-lock.c          |    2 +-
 tools/perf/builtin-record.c        |    9 +--
 tools/perf/builtin-report.c        |    2 +-
 tools/perf/builtin-sched.c         |    2 +-
 tools/perf/builtin-timechart.c     |    2 +-
 tools/perf/builtin-top.c           |    2 +-
 tools/perf/builtin-trace.c         |    2 +-
 tools/perf/builtin.h               |    1 +
 tools/perf/perf.c                  |    1 +
 tools/perf/util/header.c           |   96 +++++-----------
 tools/perf/util/header.h           |    2 -
 tools/perf/util/session.c          |    3 +-
 tools/perf/util/session.h          |    3 +-
 tools/perf/util/trace-event-read.c |   19 +++-
 tools/perf/util/trace-event.h      |    2 +-
 21 files changed, 293 insertions(+), 94 deletions(-)
 create mode 100644 tools/perf/builtin-inject.c

