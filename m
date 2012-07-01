Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2GALNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:13:37 -0400
Received: from smtp-out-136.synserver.de ([212.40.185.136]:1109 "EHLO
	smtp-out-134.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932134Ab2GALNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:13:36 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1847
From: Lars-Peter Clausen <lars@metafoo.de>
To: Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] scripts/coccinelle: Find threaded IRQs requests which are missing IRQF_ONESHOT
Date: Sun,  1 Jul 2012 13:17:07 +0200
Message-Id: <1341141427-14424-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 1c6c69525b ("genirq: Reject bogus threaded irq requests") threaded
IRQs without a primary handler need to be requested with IRQF_ONESHOT, otherwise
the request will fail. This semantic patch will help to statically identify
(and fix) such cases.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 scripts/coccinelle/misc/irqf_oneshot.cocci |   65 ++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 scripts/coccinelle/misc/irqf_oneshot.cocci

diff --git a/scripts/coccinelle/misc/irqf_oneshot.cocci b/scripts/coccinelle/misc/irqf_oneshot.cocci
new file mode 100644
index 0000000..6cfde94
--- /dev/null
+++ b/scripts/coccinelle/misc/irqf_oneshot.cocci
@@ -0,0 +1,65 @@
+/// Make sure threaded IRQs without a primary handler are always request with
+/// IRQF_ONESHOT
+///
+//
+// Confidence: Good
+// Comments:
+// Options: --no-includes
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@r1@
+expression irq;
+expression thread_fn;
+expression flags;
+position p;
+@@
+request_threaded_irq@p(irq, NULL, thread_fn,
+(
+flags | IRQF_ONESHOT
+|
+IRQF_ONESHOT
+)
+, ...)
+
+@depends on patch@
+expression irq;
+expression thread_fn;
+expression flags;
+position p != r1.p;
+@@
+request_threaded_irq@p(irq, NULL, thread_fn,
+(
+-0
++IRQF_ONESHOT
+|
+-flags
++flags | IRQF_ONESHOT
+)
+, ...)
+
+@depends on context@
+position p != r1.p;
+@@
+*request_threaded_irq@p(...)
+
+@match depends on report || org@
+expression irq;
+position p != r1.p;
+@@
+request_threaded_irq@p(irq, NULL, ...)
+
+@script:python depends on org@
+p << match.p;
+@@
+msg = "ERROR: Threaded IRQ with no primary handler requested without IRQF_ONESHOT"
+coccilib.org.print_todo(p[0],msg)
+
+@script:python depends on report@
+p << match.p;
+@@
+msg = "ERROR: Threaded IRQ with no primary handler requested without IRQF_ONESHOT"
+coccilib.report.print_report(p[0],msg)
-- 
1.7.10

