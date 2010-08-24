Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0HXPkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47797 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab0HXPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:52 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 06/18] Coccinelle: Add locks/mini_lock.cocci
Date: Tue, 24 Aug 2010 17:39:00 +0200
Message-Id: <1282664352-15882-7-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find missing unlocks.  This semantic match considers the specific case
where the unlock is missing from an if branch, and there is a lock
before the if and an unlock after the if.  False positives are due to
cases where the if branch represents a case where the function is
supposed to exit with the lock held, or where there is some preceding
function call that releases the lock.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/locks/mini_lock.cocci |   95 ++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/locks/mini_lock.cocci

diff --git a/scripts/coccinelle/locks/mini_lock.cocci b/scripts/coccinelle/locks/mini_lock.cocci
new file mode 100644
index 0000000..7641a29
--- /dev/null
+++ b/scripts/coccinelle/locks/mini_lock.cocci
@@ -0,0 +1,95 @@
+/// Find missing unlocks.  This semantic match considers the specific case
+/// where the unlock is missing from an if branch, and there is a lock
+/// before the if and an unlock after the if.  False positives are due to
+/// cases where the if branch represents a case where the function is
+/// supposed to exit with the lock held, or where there is some preceding
+/// function call that releases the lock.
+///
+// Confidence: Moderate
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual org
+virtual report
+
+@prelocked@
+position p1,p;
+expression E1;
+@@
+
+(
+mutex_lock@p1
+|
+mutex_trylock@p1
+|
+spin_lock@p1
+|
+spin_trylock@p1
+|
+read_lock@p1
+|
+read_trylock@p1
+|
+write_lock@p1
+|
+write_trylock@p1
+|
+read_lock_irq@p1
+|
+write_lock_irq@p1
+|
+read_lock_irqsave@p1
+|
+write_lock_irqsave@p1
+|
+spin_lock_irq@p1
+|
+spin_lock_irqsave@p1
+) (E1@p,...);
+
+@looped@
+position r;
+@@
+
+for(...;...;...) { <+... return@r ...; ...+> }
+
+@err@
+expression E1;
+position prelocked.p;
+position up != prelocked.p1;
+position r!=looped.r;
+identifier lock,unlock;
+@@
+
+lock(E1@p,...);
+<+... when != E1
+if (...) {
+  ... when != E1
+  return@r ...;
+}
+...+>
+unlock@up(E1,...);
+
+@script:python depends on org@
+p << prelocked.p1;
+lock << err.lock;
+unlock << err.unlock;
+p2 << err.r;
+@@
+
+cocci.print_main(lock,p)
+cocci.print_secs(unlock,p2)
+
+@script:python depends on report@
+p << prelocked.p1;
+lock << err.lock;
+unlock << err.unlock;
+p2 << err.r;
+@@
+
+msg = "preceding lock on line %s" % (p[0].line)
+coccilib.report.print_report(p2[0],msg)
-- 
1.7.0.4

