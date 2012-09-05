Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2IEOcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:32:20 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41063 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2IEOcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:32:19 -0400
X-AuditID: b753bd60-91ec3ba0000047ca-21-50476270cec4
X-AuditID: b753bd60-91ec3ba0000047ca-21-50476270cec4
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/4][BUGFIX] Fix ftrace-based kprobes 
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 05 Sep 2012 23:30:46 +0900
Message-ID: <20120905143045.10329.64502.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches fixes some bugs and corrects behaviors
of ftrace and ftrace-based kprobe.

As Fengguang reported at https://lkml.org/lkml/2012/8/24/45
ftrace-based kprobes and -mfentry option caused failures
on kprobe smoke test. This basically comes from the initial
design of ftrace-based kprobe which prohibits jprobe on
ftraced kprobe.
Without -mfentry support, this works well because NO mcount
call is at the first instruction of any function. However,
-mfentry calls it at the first one and it conflicts with
jprobe.

On this series, kprobe allows jprobe even if it is based on
ftrace. For this fix, I need following fixes.

- Make ftrace-handler interface same on x86/x86-64
  On x86, ftrace_regs_caller puts a same address on ip and 
  regs.ip, however those are different on x86-64. I've
  modified x86 to fit to x86-64 ABI.
- Fix kprobe ftrace handler for above ABI change
  Current kprobe_ftrace_handler expects ip == regs.ip, but
  it's not correct on x86-64 (and now on x86 too). This should
  be fixed.
- Use regs.ip for return address on ftrace
  From Steven, this change is suggested. Thanks!


Thank you,

---

Masami Hiramatsu (3):
      [BUGFIX] kprobes/x86: Fix to support jprobes on ftrace-based kprobe
      [BUGFIX] kprobes/x86: Fix kprobes to collectly handle IP on ftrace
      [BUGFIX] ftrace/x86: Adjust x86 regs.ip as like as x86-64

Steven Rostedt (1):
      ftrace/x86-64: Allow to change RIP in handlers


 arch/x86/kernel/entry_32.S |    3 +--
 arch/x86/kernel/entry_64.S |    4 ++++
 arch/x86/kernel/kprobes.c  |   43 +++++++++++++++++++++++++++++++------------
 kernel/kprobes.c           |    3 ---
 4 files changed, 36 insertions(+), 17 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

