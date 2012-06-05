Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701Ab2FEK1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:27:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50057 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab2FEK1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:27:45 -0400
X-AuditID: b753bd60-939c7ba000002ea5-9e-4fcddf1f3986
X-AuditID: b753bd60-939c7ba000002ea5-9e-4fcddf1f3986
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 0/9]ftrace,kprobes: Ftrace-based kprobe optimization
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 05 Jun 2012 19:27:34 +0900
Message-ID: <20120605102734.27845.43401.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Here is the version 2 patches for kprobe-ftrace. Since I didn't
touch ftrace part in this version, old gcc bug still be there.
So, if you have another implementation, prease replace former 3
patches in this series with your patch.

In this version, I've fixed kprobe-ftrace recursion problem
by initializing ftrace_ops filter correctly and registering/
unregistering on-demand.

This series of patches which allows kprobes to use ftrace
for optimizing probing path if the probe on ftrace (mcount call).
The optimization is transparently done by kprobes.

Only if kprobe.break_handler is set, that probe can not be
optimized with ftrace (nor put on ftrace). The reason why this
limitation comes is that this break_handler may be used only
from jprobes which changes ip address (for fetching the function
arguments). In this series, ftrace doesn't allow to change regs->ip,
since I don't want to make any non-essential trouble ;)

After deep consideration, I've decided to remove "real_addr"
method at this time, since it is hard to achieve complete
transparency with the combination of jprobe and aggregated
kprobes.
And also, at least on x86, ftrace-based kprobes is available.

Anyway, I can say jprobes is an out-dated probe because we 
already has kprobe-tracer and perf-probe which allows us to
get function arguments directly from kprobes. :)

On the other hand, since kprobes has self-recursion check,
it is safe if a probe is recursively hit, or hit a fault and
call fault_handler.

For using ftrace from kprobes, this series introduces two
new interface for ftrace;

 - ftrace_ops.regs_func, which is a callback handler
   invoked with pt_regs as third argument. For enable
   this feature, ftrace_ops.flags must set
   FTRACE_OPS_FL_SAVE_REGS bit.
 - ftrace_set_filter_ip(), which allows to set new
   address-based filter instead of glob pattern.

ftrace_ops.regs_func is still under discussion because older
gcc doesn't support initalizing unnamed union member.

In this version, I've removed notrace dependency from __kprobes.
Instead, it just set filter correctly before adding ftrace_ops
not to trace all functions.

Changes in v2:
 - Fix ftrace_ops registering right after setting its filter.
 - Unregister ftrace_ops if there is no kprobe useing.
 - Remove notrace dependency from __kprobes macro.

Thank you,

---

Masami Hiramatsu (8):
      kprobes/x86: ftrace based optimization for x86
      kprobes: introduce ftrace based optimization
      kprobes: Move locks into appropriate functions
      kprobes: cleanup to separate probe-able check
      ftrace: add ftrace_set_filter_ip() for address based filter
      ftrace/x86: Support SAVE_REGS feature on i386
      ftrace/x86-64: support SAVE_REGS feature on x86-64
      ftrace: Add pt_regs acceptable trace callback

Steven Rostedt (1):
      kprobes: Inverse taking of module_mutex with kprobe_mutex


 arch/x86/include/asm/ftrace.h  |    4 +
 arch/x86/include/asm/kprobes.h |    1 
 arch/x86/kernel/entry_32.S     |   64 +++++++++-
 arch/x86/kernel/entry_64.S     |   38 +++++-
 arch/x86/kernel/kprobes.c      |   48 ++++++++
 include/linux/ftrace.h         |   24 ++++
 include/linux/kprobes.h        |   27 ++++
 kernel/kprobes.c               |  250 +++++++++++++++++++++++++++++-----------
 kernel/trace/ftrace.c          |  103 ++++++++++++++--
 9 files changed, 458 insertions(+), 101 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

