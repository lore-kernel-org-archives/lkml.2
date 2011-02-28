Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1B1PYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:24:09 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33207 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754421Ab1B1PYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:24:08 -0500
Date: Mon, 28 Feb 2011 10:24:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86: stop machine text poke should issue sync core
Message-ID: <20110228152405.GA7064@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:21:31 up 96 days, 20:24,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Archiecture Software Developer's Manual section 7.1.3 specifies that a
core serializing instruction such as "cpuid" should be executed on _each_ core
before the new instruction is made visible.

Failure to do so can lead to unspecified behavior (Intel XMC erratas include
General Protection Fault in the list), so we should avoid this at all cost.

This problem can affect modified code executed by interrupt handlers after
interrupt are re-enabled at the end of stop_machine, because no core serializing
instruction is executed between the code modification and the moment interrupts
are reenabled.

Because stop_machine_text_poke performs the text modification from the first CPU
decrementing stop_machine_first, modified code executed in thread context is
also affected by this problem. To explain why, we have to split the CPUs in two
categories: the CPU that initiates the text modification (calls text_poke_smp)
and all the others. The scheduler, executed on all other CPUs after
stop_machine, issues an "iret" core serializing instruction, and therefore
handles core serialization for all these CPUs. However, the text modification
initiator can continue its execution on the same thread and access the modified
text without any scheduler call. Given that the CPU that initiates the code
modification is not guaranteed to be the one actually performing the code
modification, it falls into the XMC errata.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/alternative.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c
@@ -612,6 +612,12 @@ static int __kprobes stop_machine_text_p
 
 	flush_icache_range((unsigned long)tpp->addr,
 			   (unsigned long)tpp->addr + tpp->len);
+	/*
+	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
+	 * that a core serializing instruction such as "cpuid" should be
+	 * executed on _each_ core before the new instruction is made visible.
+	 */
+	sync_core();
 	return 0;
 }
 
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
