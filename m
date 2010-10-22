Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab0JVTNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0JVTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=uORtqNJQvoyJGpOlQ/PFjQXLobXF2JdRsuCk1syyAlCELfY2Vr91hTvB2zA/jkRFVL
         BT6nSgE7q624q/pqcLWMuneB1dtJTfrK01tU4D6rGh4IiX3Wa7g7fbBAf8wPSDNfRtNi
         sykojAkTnyjPR21LG6puRerJKoF0ZF/mXWlt0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch . Eigler" <fche@redhat.com>
Subject: [RFC v2] perf: Dwarf cfi based user callchains
Date: Fri, 22 Oct 2010 21:13:01 +0200
Message-Id: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various things have changed in this set.

- copy_from_user_nmi() renamed into copy_from_user_gup()

- regs dumping uses a version now and the user can select
  its own subset flavour of the regs proposed by the arch.
  But look: there is an open question in the 3rd patch to handle
  the compat stuff.

- new exclude_user_callchain attribute, instead of dropping fp based
  user callchains if we dump regs and stack.

- etc...

Important things to be done:

- Still no dwarf cfi from vdso. But I've read somewhere that vdso has
  dwarf cfi info. I need to handle that somewhow. Until then, it is
  only usable if you profile only userspace (use the :u flag in your event,
  as in the example below).

- Split generic/arch code in tools/perf/util/unwind.c

- Use .eh_frame_hdr for binary searching

- Make it much faster, it's too slow right now. Perhaps that needs some
  cfi info caching.

- handle compat regs, look at the open question in 3rd patch.

How to test:

	perf record -g dwarf -e cycles:u ./hackbench 10
	perf report

You can increase the stack dump by playing with the size, it is about 4000 by
default, if you want 10000 bytes:

	perf record -g dwarf,10000 -e cycles:u ./hackbench 10

You can pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/unwind-v2

Thanks.

---

Frederic Weisbecker (11):
      uaccess: New copy_from_user_gup() API
      perf: Unified API to record selective sets of arch registers
      perf: Add ability to dump user regs
      perf: Add ability to dump part of the user stack
      perf: New attribute to filter out user callchains
      perf: Support for dwarf mode callchain on perf record
      perf: Build with dwarf cfi
      perf: Support for error passed over pointers
      perf: Add libunwind dependency for dwarf cfi unwinding
      perf: Support user regs and stack in sample parsing
      perf: Support for dwarf cfi unwinding on post processing


 arch/Kconfig                              |    7 +
 arch/x86/Kconfig                          |    1 +
 arch/x86/include/asm/perf_regs.h          |   10 +
 arch/x86/include/asm/perf_regs_32.h       |   85 +++
 arch/x86/include/asm/uaccess.h            |    5 +
 arch/x86/kernel/cpu/perf_event.c          |    8 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 include/asm-generic/uaccess.h             |    4 +
 include/linux/perf_event.h                |   40 +-
 kernel/perf_event.c                       |  194 +++++-
 tools/perf/Makefile                       |   30 +-
 tools/perf/arch/x86/include/perf_regs.h   |   11 +
 tools/perf/builtin-kmem.c                 |    2 +-
 tools/perf/builtin-lock.c                 |    2 +-
 tools/perf/builtin-record.c               |   78 ++-
 tools/perf/builtin-report.c               |    9 +-
 tools/perf/builtin-sched.c                |    2 +-
 tools/perf/builtin-timechart.c            |    2 +-
 tools/perf/builtin-trace.c                |    2 +-
 tools/perf/feature-tests.mak              |   14 +
 tools/perf/util/callchain.c               |   35 +-
 tools/perf/util/callchain.h               |   19 +-
 tools/perf/util/event.c                   |   28 +-
 tools/perf/util/event.h                   |   15 +-
 tools/perf/util/header.c                  |   33 +-
 tools/perf/util/header.h                  |    3 +-
 tools/perf/util/include/linux/err.h       |   24 +
 tools/perf/util/perf_regs.h               |   11 +
 tools/perf/util/session.c                 |    4 +-
 tools/perf/util/session.h                 |    6 +
 tools/perf/util/unwind.c                  | 1112 +++++++++++++++++++++++++++++
 31 files changed, 1739 insertions(+), 59 deletions(-)
