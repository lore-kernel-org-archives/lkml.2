Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0HXPkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47697 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab0HXPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:47 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 05/18] Coccinelle: Add locks/double_lock.cocci
Date: Tue, 24 Aug 2010 17:38:59 +0200
Message-Id: <1282664352-15882-6-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find double locks.  False positives may occur when some paths cannot
occur at execution, due to the values of variables, and when there is
an intervening function call that releases the lock.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/locks/double_lock.cocci |   92 ++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/locks/double_lock.cocci

diff --git a/scripts/coccinelle/locks/double_lock.cocci b/scripts/coccinelle/locks/double_lock.cocci
new file mode 100644
index 0000000..63b24e6
--- /dev/null
+++ b/scripts/coccinelle/locks/double_lock.cocci
@@ -0,0 +1,92 @@
+/// Find double locks.  False positives may occur when some paths cannot
+/// occur at execution, due to the values of variables, and when there is
+/// an intervening function call that releases the lock.
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
+@locked@
+position p1;
+expression E1;
+position p;
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
+) (E1@p,...);
+
+@balanced@
+position p1 != locked.p1;
+position locked.p;
+identifier lock,unlock;
+expression x <= locked.E1;
+expression E,locked.E1;
+expression E2;
+@@
+
+if (E) {
+ <+... when != E1
+ lock(E1@p,...)
+ ...+>
+}
+... when != E1
+    when != \(x = E2\|&x\)
+    when forall
+if (E) {
+ <+... when != E1
+ unlock@p1(E1,...)
+ ...+>
+}
+
+@r depends on !balanced exists@
+expression x <= locked.E1;
+expression locked.E1;
+expression E2;
+identifier lock;
+position locked.p,p1,p2;
+@@
+
+lock@p1 (E1@p,...);
+... when != E1
+    when != \(x = E2\|&x\)
+lock@p2 (E1,...);
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+lock << r.lock;
+@@
+
+cocci.print_main(lock,p1)
+cocci.print_secs("second lock",p2)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+lock << r.lock;
+@@
+
+msg = "second lock on line %s" % (p2[0].line)
+coccilib.report.print_report(p1[0],msg)
-- 
1.7.0.4

