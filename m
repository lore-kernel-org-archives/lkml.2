Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0HXPkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47836 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0HXPj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:58 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 10/18] Coccinelle: Add free/kfree.cocci
Date: Tue, 24 Aug 2010 17:39:04 +0200
Message-Id: <1282664352-15882-11-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find a use after free.  Values of variables may imply that some
execution paths are not possible, resulting in false positives.
Another source of false positives are macros such as
SCTP_DBG_OBJCNT_DEC that do not actually evaluate their argument

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/free/kfree.cocci |  116 +++++++++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/free/kfree.cocci

diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
new file mode 100644
index 0000000..c13a539
--- /dev/null
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -0,0 +1,116 @@
+/// Find a use after free.  Values of variables may imply that some
+/// execution paths are not possible, resulting in false positives.
+/// Another source of false positives are macros such as
+/// SCTP_DBG_OBJCNT_DEC that do not actually evaluate their argument
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
+@free@
+expression E;
+position p1;
+@@
+
+kfree@p1(E)
+
+@print expression@
+constant char *c;
+expression free.E,E2;
+type T;
+position p;
+identifier f;
+@@
+
+(
+ f(...,c,...,(T)E@p,...)
+|
+ E@p == E2
+|
+ E@p != E2
+|
+ !E@p
+|
+ E@p || ...
+)
+
+@sz@
+expression free.E;
+position p;
+@@
+
+ sizeof(<+...E@p...+>)
+
+@loop exists@
+expression E;
+identifier l;
+position ok;
+@@
+
+while (1) { ...
+  kfree@ok(E)
+  ... when != break;
+      when != goto l;
+      when forall
+}
+
+@r exists@
+expression free.E, subE<=free.E, E2;
+expression E1;
+iterator iter;
+statement S;
+position free.p1!=loop.ok,p2!={print.p,sz.p};
+@@
+
+kfree@p1(E,...)
+...
+(
+ iter(...,subE,...) S // no use
+|
+ list_remove_head(E1,subE,...)
+|
+ subE = E2
+|
+ subE++
+|
+ ++subE
+|
+ --subE
+|
+ subE--
+|
+ &subE
+|
+ BUG(...)
+|
+ BUG_ON(...)
+|
+ return_VALUE(...)
+|
+ return_ACPI_STATUS(...)
+|
+ E@p2 // bad use
+)
+
+@script:python depends on org@
+p1 << free.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("kfree",p1)
+cocci.print_secs("ref",p2)
+
+@script:python depends on report@
+p1 << free.p1;
+p2 << r.p2;
+@@
+
+msg = "reference preceded by free on line %s" % (p1[0].line)
+coccilib.report.print_report(p2[0],msg)
-- 
1.7.0.4

