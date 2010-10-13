Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0JMFHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:07:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JMFHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=Nd/56qdsi+VkgsIWmtqdrQDkrqttZbMSxMFpvd8aQH4eiW/XfNCdJPaDgeFXVZBjKO
         rMcXtFTh9TMN+r8/qv7jOfzU+4fkdQ12pDXxPgAZMyfz+tzCqAa0Y9fGM0Uaqk/sDbWN
         0iCCS+GdDjqCTAlSkuKBZJFYEV6jpQBJ+JeiM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [RFC] perf: Dwarf cfi based user callchains
Date: Wed, 13 Oct 2010 07:06:52 +0200
Message-Id: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This brings dwarf cfi based callchain for userspace apps that don't have
frame pointers.

To test it, you can try:

perf record -g dwarf,24000 -e cycles:u ./hackbench 2
perf report

It seems to work but there are of course many things to improve:

- do only userspace profiling with that mode for now (the :u flag as above).
  The reason is that if you profile also the kernel, the user callchains
  will often start from vdso if the user made a syscall, and vdso doesn't
  have cfi informations, so we get stuck there. I need to find a solution for
  that, like doing a single frame pointer deref on the first entry (vdso)
  and continue with dwarves, but I need to know if we came from a syscall for
  that. Not sure yet how I'll handle that.

- it only works with .eh_frame, I think there is an elf section that is made
  almost the same but with few differences. I don't remember the name at that
  time but that needs a look.

- it's slow. A first improvement to make it faster is to support binary
  search from .eh_frame_hdr. This will probably be one of the next things
  I'll focus in. And the whole needs perhaps more caching and so on.

- only support for x86-32. I need to split some arch specific code from
  generic and add at least x86-64 support.

- there are still some callchains that are not unwind. I need to investigate.

This can be found in:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/unwind-v1

Thanks,
	Frederic
---

Frederic Weisbecker (9):
      uaccess: Make copy_from_user_nmi() globally available
      perf: Add ability to dump user regs
      perf: Add ability to dump part of the user stack
      perf: Don't record frame pointer based user stacktraces if we dump stack and regs
      perf: Support for dwarf mode callchain on perf record
      perf: Build with dwarf cfi
      perf: Support for error passed over pointers
      perf: Add libunwind dependency for dwarf cfi unwinding
      perf: Support for dwarf cfi unwinding on post processing


 arch/x86/include/asm/uaccess.h      |    5 +
 arch/x86/kernel/cpu/perf_event.c    |    4 +-
 include/asm-generic/uaccess.h       |    4 +
 include/linux/perf_event.h          |   15 +-
 kernel/perf_event.c                 |  182 +++++-
 tools/perf/Makefile                 |   23 +-
 tools/perf/builtin-record.c         |   76 +++-
 tools/perf/builtin-report.c         |    9 +-
 tools/perf/feature-tests.mak        |   14 +
 tools/perf/perf.h                   |    5 +
 tools/perf/util/callchain.c         |   35 +-
 tools/perf/util/callchain.h         |   19 +-
 tools/perf/util/event.c             |   29 +
 tools/perf/util/event.h             |    7 +
 tools/perf/util/include/linux/err.h |   24 +
 tools/perf/util/unwind.c            | 1077 +++++++++++++++++++++++++++++++++++
 16 files changed, 1485 insertions(+), 43 deletions(-)
