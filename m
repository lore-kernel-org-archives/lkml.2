Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0DFV66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0DFV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:58:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 0/8] perf-probe updates - data-structure support
	improvements, etc.
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 06 Apr 2010 18:05:42 -0400
Message-ID: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several updates of perf-probe. This series improves
data structure accessing. In this version, I added 'removing die()'
patches.

- Set the name of argument which traces a data structure member
  as the last member of the data structure reference (e.g. f_mode
  of file->f_mode). This allows us to use perf-trace for tracin
  data-structure members.

- Add the basic type support. This allows us to fetch the memory
  with specified bitwidth. Usually, data-structure members are
  packed on the memory, this means if we want to read a member
  from memory, we have to access it with type casting.
  kprobe-tracer now support tracing argument with basic types
  (u8,u16,u32,u64,s8,s16,s32,s64), and perf-probe decodes the type
  information of the members.

- Support canonical frame address, which is used for refering
  frame-base on the kernel built without CONFIG_FRAME_POINTER.

- Remove almost all die()s from util code, according to acme's
  advice. Thanks!

TODOs (possible features):
  - Support array element (var[N])
  - Support string/dynamic arrays (*var, var[N..M])
  - Support tracing static variables (non global)
  - Support dynamic array-indexing (var[var2])
  - Support force type-casting ((type)var)
  - Show what deta-structure member is assigned to each argument.
  - Better support for probes on modules
  - More debugger like enhancements(%next, --disasm, etc.)

Thank you,

---

Masami Hiramatsu (8):
      perf probe: Remove die() from probe-event code
      perf probe: Remove die() from probe-finder code
      perf probe: Support DW_OP_call_frame_cfa in debuginfo
      perf probe: Support basic type casting
      perf probe: Query basic types from debuginfo
      tracing/kprobes: Support basic types on dynamic events
      perf probe: Use the last field name as the argument name
      perf probe: Support argument name


 Documentation/trace/kprobetrace.txt     |    4 
 kernel/trace/trace.h                    |   16 -
 kernel/trace/trace_kprobe.c             |  535 +++++++++++++++---------
 tools/perf/Documentation/perf-probe.txt |   11 
 tools/perf/builtin-probe.c              |   74 ++-
 tools/perf/util/probe-event.c           |  683 ++++++++++++++++++++++---------
 tools/perf/util/probe-event.h           |   27 +
 tools/perf/util/probe-finder.c          |  586 ++++++++++++++++++---------
 tools/perf/util/probe-finder.h          |    1 
 9 files changed, 1283 insertions(+), 654 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
