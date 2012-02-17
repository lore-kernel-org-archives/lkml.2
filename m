Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2BQNrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:47:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2BQNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:47:45 -0500
Date: Fri, 17 Feb 2012 05:46:52 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-f069686e4bdc60a637d210ea3eea25fcdb82df88@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120118120711.GB14863@elte.hu>
References: <20120118120711.GB14863@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/softirq: Move __raise_softirq_irqoff()
  out of header
Git-Commit-ID: f069686e4bdc60a637d210ea3eea25fcdb82df88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:47:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f069686e4bdc60a637d210ea3eea25fcdb82df88
Gitweb:     http://git.kernel.org/tip/f069686e4bdc60a637d210ea3eea25fcdb82df88
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 25 Jan 2012 20:18:55 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 3 Feb 2012 09:48:19 -0500

tracing/softirq: Move __raise_softirq_irqoff() out of header

The __raise_softirq_irqoff() contains a tracepoint. As tracepoints in headers
can cause issues, and not to mention, bloats the kernel when they are
in a static inline, it is best to move the function that contains the
tracepoint out of the header and into softirq.c.

Link: http://lkml.kernel.org/r/20120118120711.GB14863@elte.hu

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/interrupt.h |    7 +------
 kernel/irq/chip.c         |    2 ++
 kernel/softirq.c          |    6 ++++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a64b00e..3f830e0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -20,7 +20,6 @@
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
-#include <trace/events/irq.h>
 
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
@@ -456,11 +455,7 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-static inline void __raise_softirq_irqoff(unsigned int nr)
-{
-	trace_softirq_raise(nr);
-	or_softirq_pending(1UL << nr);
-}
+extern void __raise_softirq_irqoff(unsigned int nr);
 
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f7c543a..fc41824 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -16,6 +16,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 
+#include <trace/events/irq.h>
+
 #include "internals.h"
 
 /**
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..06d4099 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -385,6 +385,12 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
 	softirq_vec[nr].action = action;
