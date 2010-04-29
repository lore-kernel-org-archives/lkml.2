Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666Ab0D3VYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:24:09 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:63183 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0D3VYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CrqfxnvKCD++mWWOXxxtXuyPkNTHYkI7G0LNPEy8ep+EE5O+CFmr54q2yvKAY/8wXW
         AFOCF64Oqj8qoA2xmOC/jj0ZL+Tw2I+HAYN00c2ul1F6OPr3q95bp5+NO5Y4V1U0Wqfn
         CSqnSQ5YLJj1JyOauVHT6wIQA8iIk7m2w0wL0=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: [PATCH] rt: Fix the reminder block accounting for CONFIG_FUNCTION_TRACER
Date: Thu, 29 Apr 2010 22:07:32 +0200
Message-Id: <1272571652-5719-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the accounting for CONFIG_FUNCTION_TRACER in DEBUG_COUNT
match that in the reminder block reporting.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/main.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/init/main.c b/init/main.c
index 622fe30..d4b3bf5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,15 +908,17 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT	(defined(CONFIG_DEBUG_RT_MUTEXES) +	\
-			defined(CONFIG_IRQSOFF_TRACER) +	\
-			defined(CONFIG_PREEMPT_TRACER) +	\
-			defined(CONFIG_FUNCTION_TRACER) +	\
-			defined(CONFIG_INTERRUPT_OFF_HIST) +	\
-			defined(CONFIG_PREEMPT_OFF_HIST) +	\
-			defined(CONFIG_DEBUG_SLAB) +		\
-			defined(CONFIG_PREEMPT_OFF_HIST) +	\
-			defined(CONFIG_LOCKDEP))
+#define DEBUG_COUNT	(				\
+		defined(CONFIG_DEBUG_RT_MUTEXES) +	\
+		defined(CONFIG_IRQSOFF_TRACER) +	\
+		defined(CONFIG_PREEMPT_TRACER) +	\
+		defined(CONFIG_INTERRUPT_OFF_HIST) +	\
+		defined(CONFIG_PREEMPT_OFF_HIST) +	\
+		defined(CONFIG_DEBUG_SLAB) +		\
+		defined(CONFIG_PREEMPT_OFF_HIST) +	\
+		defined(CONFIG_LOCKDEP) +		\
+		(defined(CONFIG_FUNCTION_TRACER) -	\
+		 defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -936,7 +938,7 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
+#if defined(CONFIG_FUNCTION_TRACER) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
 	printk(KERN_ERR "*        CONFIG_FUNCTION_TRACER                                              *\n");
 #endif
 #ifdef CONFIG_INTERRUPT_OFF_HIST
-- 
1.6.6.1

