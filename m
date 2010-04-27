Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0D0TZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:25:54 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:59614 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0D0TZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aRc2oFjqnudwoejLzQi8bY9dYK3o0CpxTMvCoZClumLa8YvW6gdhqqQLKAP1fmZvlR
         8w7Vr6j84hKPSKyO2P4B9eIHr+VIGOTTTMmIDbTsx3Jlgk5548GnOVkHT9Ujsqty8pgO
         z6MopKJXAssDeBtK0j5JDbKkrLs7rrKoAYvW4=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH:resend] rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT, and fix reminder block
Date: Tue, 27 Apr 2010 21:25:42 +0200
Message-Id: <1272396342-12504-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix does two things.

1. It reverts commit 3e39399ef4a742d994570488994be93ef17d4ef5.
- The above commit added back a warning about CONFIG_STACK_TRACER
NOT because the warning was necessary but to fix-up a problem where you could
get an empty REMINDER block in the demg.

However, CONFIG_STACK_TRACER really should not be in the reminder block.
Even when configured-in it is not enabled, and thus has neglible impact.

2. It removes CONFIG_STACK_TRACER from DEBUG_COUNT which is the proper fix
for the empty REMINDER block problem.

This patch is for rt only. (this code doesn't exist in mainline)

Signed-off-by: John Kacur <jkacur@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 init/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 592c16a..f26cb63 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -928,9 +928,6 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_STACK_TRACER
-	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
-#endif
 #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
 	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
 #endif
-- 
1.6.6.1

