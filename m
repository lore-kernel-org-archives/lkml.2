Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1LNCwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:52:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab1LNCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:52:53 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=umzKb0NKOewA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=oG6XTinB78kSuy_KwR8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111214025237.457632996@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 21:52:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 0/5 v2] x86: Find a way to allow breakpoints in NMIs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this is getting close. Although I'm labeling this as a RFC patchset,
I've already queued it up into my git repo. I did some code cleanups
since the last version, and I also added the IDT update if an
NMI interrupts a process using the debug stack. This way the
NMI wont corrupt it if it hits a breakpoint too.

I've also added code to handle i386, which was quite trivial, as
NMIs and int3s do not change the stack when preempting privilege mode.
That code was done all in C.

I've hammered this code with running perf on top of ftrace using
the breakpoint conversions, and I've done this on two boxes.
Both are holding up very well. I haven't hit any glitches.

With all that said, please take a final look over these patches and
let me know what you think. After that, I'll be pushing this forward
as it is required for my ftrace series.

Note, the below stats look like I added a lot of code. I've actually
added more comments than code, as this needed it.

Thanks!

-- Steve



  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core

Head SHA1: e0b5187d3e29df98ae2b4c71250387d824ac90ae


Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Steven Rostedt (4):
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes
      x86: Keep current stack in NMI breakpoints
      x86: Allow NMIs to hit breakpoints in i386

----
 arch/x86/include/asm/desc.h      |   12 ++
 arch/x86/include/asm/processor.h |    6 +
 arch/x86/kernel/cpu/common.c     |   22 ++++
 arch/x86/kernel/entry_64.S       |  208 ++++++++++++++++++++++++++++++++------
 arch/x86/kernel/head_64.S        |    4 +
 arch/x86/kernel/nmi.c            |  101 ++++++++++++++++++
 arch/x86/kernel/traps.c          |    6 +
 7 files changed, 326 insertions(+), 33 deletions(-)
