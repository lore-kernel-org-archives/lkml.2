Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1BCPnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:43:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1BCPnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:43:01 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [RFC 0/4] tracing,x86_64 - function/graph trace without mcount/-pg/framepointer
Date: Thu,  3 Feb 2011 16:42:37 +0100
Message-Id: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I recently saw the direct jump probing made for kprobes
and tried to use it inside the trace framework.

The global idea is patching the function entry with direct
jump to the trace code, instead of using pregenerated gcc
profile code.

I started this just to see if it would be even possible
to hook with new probing to the current trace code. It
appears it's not that bad. I was able to run function
and function_graph trace on x86_64.

For details on direct jumps probe, please check:
http://www.linuxinsight.com/ols2007-djprobe-kernel-probing-with-the-smallest-overhead.html


I realize using this way to hook the functions has some
drawbacks, from what I can see it's roughly:
- no all functions could be patched
- need to find a way to say which function is safe to patch
- memory consumption for detour buffers and symbol records

but seems there're some advantages as well:
- trace code could be in a module
- no profiling code is needed
- framepointer can be disabled (framepointer is needed for
  generating profile code)


As for the attached implementation it's hack mostly (expect bugs),
especially the ftrace/kprobe integration could be probably done better.
It's only for x86_64.

It can be used like this:

- new menu config item is added (function tracer engine),
  to choose mcount or ktrace
- new file "ktrace" is added to the tracing dir
- to add symbols to trace run:
	echo mutex_unlock > ./ktrace
	echo mutex_lock >> ./ktrace
- to display trace symbols:
	cat ktrace
- to enable the trace, the usual is needed:
	echo function > ./current_tracer
	echo function_graph > ./current_tracer
- to remove symbols from trace:
	echo nop > ./current_tracer 
	echo > ./ktrace 
- if the function is added while the tracer is running,
  the symbol is enabled automatically.
- only all symbols could be removed and only if there's
  no tracer running.

I'm not sure how to choose from kallsyms interface what function
is safe to patch, so I omit patching of all symbols so far.


attached patches:
 1/4 - kprobe - ktrace instruction slot cache interface
     using kprobe detour buffer allocation, adding interface
     to use it from trace framework

 2/4 - tracing - adding size parameter to do_ftrace_mod_code
     adding size parameter to be able to restore the saved
     instructions, which could be longer than relative call

 3/4 - ktrace - function trace support
     adding ktrace support with function tracer

 4/4 - ktrace - function trace support
     adding function graph support


please let me know what you think, thanks
jirka
---
 Makefile                   |    2 +-
 arch/x86/Kconfig           |    4 +-
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/entry_64.S |   50 +++++++
 arch/x86/kernel/ftrace.c   |  157 +++++++++++----------
 arch/x86/kernel/ktrace.c   |  256 ++++++++++++++++++++++++++++++++++
 include/linux/ftrace.h     |   36 +++++-
 include/linux/kprobes.h    |    8 +
 kernel/kprobes.c           |   33 +++++
 kernel/trace/Kconfig       |   28 ++++-
 kernel/trace/Makefile      |    1 +
 kernel/trace/ftrace.c      |   21 +++
 kernel/trace/ktrace.c      |  330 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c       |    1 +
 14 files changed, 846 insertions(+), 82 deletions(-)
