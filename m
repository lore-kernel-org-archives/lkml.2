Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab2BJVF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:05:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:53184 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760158Ab2BJVF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:05:27 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        bruce.w.allan@intel.com, joe@perches.com, rusty@rustcorp.com.au
Subject: [PATCH v3] scripts/coccinelle/misc/boolinit.cocci: semantic patch for bool issues
Date: Fri, 10 Feb 2012 22:05:18 +0100
Message-Id: <1328907918-31335-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
ERROR's changed to WARNING, except in assignment to non-0/1 case.

 scripts/coccinelle/misc/boolinit.cocci |  178 +++++++++++++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/scripts/coccinelle/misc/boolinit.cocci b/scripts/coccinelle/misc/boolinit.cocci
new file mode 100644
index 0000000..b7edfdb
--- /dev/null
+++ b/scripts/coccinelle/misc/boolinit.cocci
@@ -0,0 +1,178 @@
+/// Bool initializations should use true and false.  Bool tests don't need
+/// comparisons.  Based on contributions from Joe Perches, Rusty Russell
+/// and Bruce W Allan.
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options: -include_headers
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@depends on patch@
+bool t;
+symbol true;
+symbol false;
+@@
+
+(
+- t == true
++ t
+|
+- true == t
++ t
+|
+- t != true
++ !t
+|
+- true != t
++ !t
+|
+- t == false
++ !t
+|
+- false == t
++ !t
+|
+- t != false
++ t
+|
+- false != t
++ t
+)
+
+@depends on patch disable is_zero, isnt_zero@
+bool t;
+@@
+
+(
+- t == 1
++ t
+|
+- t != 1
++ !t
+|
+- t == 0
++ !t
+|
+- t != 0
++ t
+)
+
+@depends on patch@
+bool b;
+@@
+(
+ b =
+- 0
++ false
+|
+ b =
+- 1
++ true
+)
+
+// ---------------------------------------------------------------------
+
+@r1 depends on !patch@
+bool t;
+position p;
+@@
+
+(
+* t@p == true
+|
+* true == t@p
+|
+* t@p != true
+|
+* true != t@p
+|
+* t@p == false
+|
+* false == t@p
+|
+* t@p != false
+|
+* false != t@p
+)
+
+@r2 depends on !patch disable is_zero, isnt_zero@
+bool t;
+position p;
+@@
+
+(
+* t@p == 1
+|
+* t@p != 1
+|
+* t@p == 0
+|
+* t@p != 0
+)
+
+@r3 depends on !patch@
+bool b;
+position p1,p2;
+constant c;
+@@
+(
+*b@p1 = 0
+|
+*b@p1 = 1
+|
+*b@p2 = c
+)
+
+@script:python depends on org@
+p << r1.p;
+@@
+
+cocci.print_main("WARNING: Comparison to bool",p)
+
+@script:python depends on org@
+p << r2.p;
+@@
+
+cocci.print_main("WARNING: Comparison of bool to 0/1",p)
+
+@script:python depends on org@
+p1 << r3.p1;
+@@
+
+cocci.print_main("WARNING: Assignment of bool to 0/1",p1)
+
+@script:python depends on org@
+p2 << r3.p2;
+@@
+
+cocci.print_main("ERROR: Assignment of bool to non-0/1 constant",p2)
+
+@script:python depends on report@
+p << r1.p;
+@@
+
+coccilib.report.print_report(p[0],"WARNING: Comparison to bool")
+
+@script:python depends on report@
+p << r2.p;
+@@
+
+coccilib.report.print_report(p[0],"WARNING: Comparison of bool to 0/1")
+
+@script:python depends on report@
+p1 << r3.p1;
+@@
+
+coccilib.report.print_report(p1[0],"WARNING: Assignment of bool to 0/1")
+
+@script:python depends on report@
+p2 << r3.p2;
+@@
+
+coccilib.report.print_report(p2[0],"ERROR: Assignment of bool to non-0/1 constant")

