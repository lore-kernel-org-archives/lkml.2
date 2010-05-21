Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0EUOFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:05:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0EUOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=x2L1Jk9lKQfqs9eExfXTFqtLZ17hTWaWAz2BE7VSJSppBvKAVWGQoXQD2XkHSCwrln
         B22zl+7f6pSLpXJLI/CDQZCJPGIyVp/rnSvXkWniFCRAxFqZtn5sE5cEXKSDbp6TEoQH
         Jk/9Hr9TiHUzhUljP1P+QfK690FT/OgaivJkM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] irq: Support to compute context on top of a given preempt_count offset
Date: Fri, 21 May 2010 16:05:12 +0200
Message-Id: <1274450715-23955-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings the support to compute irq/preempt contexts on top
of a a given preempt count offset instead of the current one.

This is going to be useful for perf that needs to know the
preempt_count() of the context that an event has interrupted.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/hardirq.h |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..0195547 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -58,6 +58,7 @@
 #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
 #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
 #define NMI_MASK	(__IRQ_MASK(NMI_BITS)     << NMI_SHIFT)
+#define IRQ_MASK	(SOFTIRQ_MASK | HARDIRQ_MASK | NMI_MASK)
 
 #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
 #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
@@ -74,15 +75,23 @@
 #error PREEMPT_ACTIVE is too low!
 #endif
 
-#define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
-#define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
-#define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK \
-				 | NMI_MASK))
+#define hardirq_count_offset(offset)	((offset) & HARDIRQ_MASK)
+#define softirq_count_offset(offset)	((offset) & SOFTIRQ_MASK)
+#define irq_count_offset(offset)	((offset) & IRQ_MASK)
+
+#define hardirq_count()			hardirq_count_offset(preempt_count())
+#define softirq_count()			softirq_count_offset(preempt_count())
+#define irq_count()			irq_count_offset(preempt_count())
 
 /*
  * Are we doing bottom half or hardware interrupt processing?
  * Are we in a softirq context? Interrupt context?
  */
+#define in_irq_offset(offset)		(hardirq_count_offset(offset))
+#define in_softirq_offset(offset)	(softirq_count_offset(offset))
+#define in_interrupt_offset(offset)	(irq_count_offset(offset))
+
+
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
-- 
1.6.2.3

