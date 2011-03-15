Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1COQni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:52024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332Ab1COQnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:43:37 -0400
Date: Tue, 15 Mar 2011 16:43:03 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, mathieu.desnoyers@efficios.com,
        peterz@infradead.org, arjan@infradead.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, andi@firstfloor.org,
        peterz@infradead.org, arjan@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, stable@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110303160137.GB1590@Krystal>
References: <20110303160137.GB1590@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: stop_machine_text_poke() should issue sync_core()
Message-ID: <tip-0e00f7aed6af21fc09b2a94d28bc34e449bd3a53@git.kernel.org>
Git-Commit-ID: 0e00f7aed6af21fc09b2a94d28bc34e449bd3a53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Mar 2011 16:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e00f7aed6af21fc09b2a94d28bc34e449bd3a53
Gitweb:     http://git.kernel.org/tip/0e00f7aed6af21fc09b2a94d28bc34e449bd3a53
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Thu, 3 Mar 2011 11:01:37 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 15 Mar 2011 08:36:37 -0700

x86: stop_machine_text_poke() should issue sync_core()

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

Q: Isn't this executed from an IPI handler, which will return with IRET (a
   serializing instruction) anyway?
A: No, now stop_machine uses per-cpu workqueue, so that handler will be
   executed from worker threads. There is no iret anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110303160137.GB1590@Krystal>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: <stable@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/alternative.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7038b95..4db3554 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -620,7 +620,12 @@ static int __kprobes stop_machine_text_poke(void *data)
 		flush_icache_range((unsigned long)p->addr,
 				   (unsigned long)p->addr + p->len);
 	}
-
+	/*
+	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
+	 * that a core serializing instruction such as "cpuid" should be
+	 * executed on _each_ core before the new instruction is made visible.
+	 */
+	sync_core();
 	return 0;
 }
 
