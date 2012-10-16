Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2JPIAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:00:06 -0400
Received: from odpn1.odpn.net ([212.40.96.53]:60901 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab2JPIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:00:03 -0400
X-Greylist: delayed 1649 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 04:00:02 EDT
From: "Gabor Z. Papp" <gzp@papp.hu>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Linux 2.6.32.xx build breaks with gcc 4.7
References: <20121012114302.GB14734@1wt.eu> <x6lifb3o0t@gzp>
	<20121012120829.GD14734@1wt.eu> <x6vcecp44c@gzp>
	<20121015102505.GE24159@1wt.eu> <x6a9voowqv@gzp>
	<20121015105710.GF24159@1wt.eu> <x61uh0oun5@gzp>
	<20121015114528.GJ24159@1wt.eu> <x6y5j7392k@gzp>
	<20121015191705.GO24159@1wt.eu>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
Date: Tue, 16 Oct 2012 09:32:29 +0200
Message-ID: <x6r4oyzxbm@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lo lo,

I'm trying to compile 2.6.32.60 with gcc 4.7.2, and getting the
following error:

  CC      arch/x86/kernel/ptrace.o
arch/x86/kernel/ptrace.c:1472:17: error: conflicting types for 'syscall_trace_enter'
In file included from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/vm86.h:130:0,
                 from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/processor.h:10,
                 from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/x86/kernel/ptrace.c:11:
/usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/ptrace.h:145:13: note: previous declaration of 'syscall_trace_enter' was here
arch/x86/kernel/ptrace.c:1517:17: error: conflicting types for 'syscall_trace_leave'
In file included from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/vm86.h:130:0,
                 from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/processor.h:10,
                 from /usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/x86/kernel/ptrace.c:11:
/usr/src/linux-2.6.32.60-gzpLinux/arch/x86/include/asm/ptrace.h:146:13: note: previous declaration of 'syscall_trace_leave' was here
make[2]: *** [arch/x86/kernel/ptrace.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

My environment looks like:

Linux 3.2.30, glibc 2.16, gcc 4.7.2

If I comment out the ancient line, kernel compiles fine.

Willy says:

| The affected entry is only used there :

| arch/x86/include/asm/ptrace.h:extern void syscall_trace_leave(struct pt_regs *);
| arch/x86/include/asm/thread_info.h:/* work to do in syscall_trace_leave() */
| arch/x86/kernel/entry_32.S:     ENABLE_INTERRUPTS(CLBR_ANY)     # could let syscall_trace_leave() call
| arch/x86/kernel/entry_32.S:     call syscall_trace_leave
| arch/x86/kernel/entry_64.S:     call syscall_trace_leave
| arch/x86/kernel/ptrace.c:asmregparm void syscall_trace_leave(struct pt_regs *regs)

| So if the two calls above don't need the include then maybe we can
| safely remove it.
