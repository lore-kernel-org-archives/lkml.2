Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2E2Msr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:48:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53902 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2E2Msq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:48:46 -0400
X-AuditID: b753bd60-9a705ba000007aa1-a2-4fc4c5abc778
X-AuditID: b753bd60-9a705ba000007aa1-a2-4fc4c5abc778
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe optimization
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 29 May 2012 21:48:33 +0900
Message-ID: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Here, the series of patches which allows kprobes to use ftrace
for optimizing probing path if the probe on ftrace (mcount call).
The optimization is transparently done by kprobes.

Only if kprobe.break_handler is set, that probe can not be
optimized with ftrace (nor put on ftrace). The reason why this
limitation comes is that this break_handler may be used only
from jprobes which changes ip address (for fetching the function
arguments).
In this series, ftrace doesn't allow to change regs->ip,
since I don't want to make any non-essential trouble ;)

After deep consideration, I've decided to remove "real_addr"
method at this time, since it is hard to achieve complete
transparency with the combination of jprobe and aggregated
kprobes.
And also, at least on x86, ftrace-based kprobes is available.

Anyway, I can say jprobes is an out-dated probe because we 
already has kprobe-tracer and perf-probe which allows us to
get function arguments directly from kprobes. :)

For using ftrace from kprobes, this series introduces two
new interface for ftrace;

 - ftrace_ops.regs_func, which is a callback handler
   invoked with pt_regs as third argument. For enable
   this feature, ftrace_ops.flags must set
   FTRACE_OPS_FL_SAVE_REGS bit.
 - ftrace_set_filter_ip(), which allows to set new
   address-based filter instead of glob pattern.

In this series, FTRACE_OPS_FL_SAVE_REGS feature is supported
only on x86 (x86-64 and i386). It may be possible to port
it on other architectures too.

Also, this makes all __kprobes functions "notrace", because
some of those functions are considered as to be called from
kprobes handler which is called from function tracer.
I think that is another discussion point. Perhaps, we need
to introduce another tag which means "don't put kprobe on
this function" instead of __kprobes and apply that.

Thank you,

---

Masami Hiramatsu (8):
      kprobes/x86: ftrace based optiomization for x86
      kprobes: introduce ftrace based optiomization
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
 include/linux/kprobes.h        |   35 +++++
 kernel/kprobes.c               |  256 +++++++++++++++++++++++++++++-----------
 kernel/trace/ftrace.c          |  103 ++++++++++++++--
 9 files changed, 471 insertions(+), 102 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

