Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1A1SXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:23:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab1A1SXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:23:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
In-Reply-To: Peter Zijlstra's message of  Friday, 28 January 2011 09:36:38 +0100 <1296203798.15234.249.camel@laptop>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	<20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
	<1295963783.28776.1061.camel@laptop>
	<20110127094041.GR19725@linux.vnet.ibm.com>
	<1296123733.15234.53.camel@laptop>
	<20110127191146.DB22F180999@magilla.sf.frob.com>
	<20110128045721.GV19725@linux.vnet.ibm.com>
	<20110128062316.9515018099A@magilla.sf.frob.com>
	<1296203798.15234.249.camel@laptop>
X-Zippy-Says: Somewhere in suburban Honolulu, an unemployed bellhop is whipping
    up a batch of illegal psilocybin chop suey!!
Message-Id: <20110128182311.B9D57180996@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 10:23:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And reset the hardware back to block step when done, and provide the
> actual break blockstep would have.

Oh, sure, that too.  If you're that ambitious, then the place to start
first is with plain single-step working right.  When TF was already set
(either via user_enable_single_step, so TIF_SINGLESTEP is set, or just from
user mode, so it and TIF_FORCED_TF are not set, but TF is in the user
state's eflags) and you hit a uprobe, then after servicing the uprobe and
stepping over the copied original instruction and restoring the PC to where
it should be, you should let the trap turn into a SIGTRAP as normal rather
than swallowing it.

To support block-step correctly, you have to do something more clever.
If block-step was enabled (TIF_BLOCKSTEP set), then you need to figure
out which of two things is the right one to do.  If the copied original
instruction uprobes just single-stepped over is one that would trigger
block-step, then you should treat it as if plain single-step were
enabled, i.e. let that SIGTRAP go as above.  If not, then you should
swallow the signal, re-enable block-step and set TF (i.e. do the work of
user_enable_block_step) before resuming.  You have to decide which case
it is based on instruction analysis.  If it's a control-flow instruction
(including the syscall instructions), then it would trigger block-step.
IIRC a conditional branch instruction triggers it only if the branch is
taken (check the book), so you have to notice that too.


Thanks,
Roland
