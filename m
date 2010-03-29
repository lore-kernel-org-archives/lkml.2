Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0C2UaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0C2UaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:30:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/7] perf-probe updates - data-structure support
	improvements, etc.
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 29 Mar 2010 16:37:36 -0400
Message-ID: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several updates of perf-probe. This series improves
data structure accessing.

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

TODOs (possible features):
  - Support array element (var[N])
  - Support string/dynamic arrays (*var, var[N..M])
  - Support tracing static variables (non global)
  - Support dynamic array-indexing (var[var2])
  - Support force type-casting ((type)var)
  - Show what deta-structure member is assigned to each argument.
  - Better support for probes on modules
  - More debugger like enhancements(%next, --disasm, etc.)

I decided to drop non-root user support (for --add/--del),
because this can set probes for getting sensitive data...

Thank you,

---

Masami Hiramatsu (7):
      perf probe: Support DW_OP_call_frame_cfa in debuginfo
      perf probe: Support basic type casting
      perf probe: Query basic types from debuginfo
      trace/kprobes: Support basic types
      perf probe: Use the last field name as the argument name
      perf probe: Support argument name
      [BUGFIX] perf probe: Fix to close dwarf when failing to analyze it


 Documentation/trace/kprobetrace.txt     |    4 
 kernel/trace/trace.h                    |   16 -
 kernel/trace/trace_kprobe.c             |  535 +++++++++++++++++++------------
 tools/perf/Documentation/perf-probe.txt |   11 +
 tools/perf/builtin-probe.c              |    4 
 tools/perf/util/probe-event.c           |   70 +++-
 tools/perf/util/probe-event.h           |    3 
 tools/perf/util/probe-finder.c          |  131 ++++++--
 tools/perf/util/probe-finder.h          |    1 
 9 files changed, 516 insertions(+), 259 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
