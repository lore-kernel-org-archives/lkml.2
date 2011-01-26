Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1AZEKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:10:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1AZEKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:10:16 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=Ogxe_jRkZ3YA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Y0HsYtvwzFbRsqBQSF0A:9 a=1T8ly2VlRkhsKGF75uuANvxd6WoA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110126040459.289776311@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 Jan 2011 23:04:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3] [GIT PULL][v2.6.38] tracing: fix unaligned event arrays
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

It was discovered that the alignment of the trace event sections
break sparc64. The trace events are created by linker magic, so
gcc does not realize that the structures being allocated will end
up in an array. Without adding any alignment, x86_64 would create
the trace event arrays with holes that would break reading the
events in serial. The fix for that was to force a align(4) to
keep gcc and the linker from spacing the event structures at various
alignments. But recent changes have caused this change to break
sparc due to bad alignment in the structures, caused by the 4 byte
alignment.

After some discussions, Mathieu came up with the following patch set
to correctly fix the alignment issues with the trace event structures.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Mathieu Desnoyers (3):
      Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
      tracing: Fix sparc64 alignment crash with __u64_aligned/U64_ALIGN()
      tracepoints: Use __u64_aligned/U64_ALIGN()

----
 include/asm-generic/vmlinux.lds.h |   27 +++++++++++-------
 include/linux/align-section.h     |   54 +++++++++++++++++++++++++++++++++++++
 include/linux/compiler.h          |    8 +++--
 include/linux/ftrace_event.h      |    2 +-
 include/linux/syscalls.h          |   12 ++++----
 include/linux/tracepoint.h        |   12 +++-----
 include/trace/ftrace.h            |    8 +++---
 include/trace/syscall.h           |    2 +-
 kernel/trace/trace.h              |    2 +-
 kernel/trace/trace_export.c       |    2 +-
 10 files changed, 94 insertions(+), 35 deletions(-)
