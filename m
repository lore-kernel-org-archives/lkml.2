Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2A0UmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:42:00 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37721 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2A0Ulg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:41:36 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Subject: [PATCH] scripts/coccinelle: semantic patch converting 0 test to null test
Date: Fri, 27 Jan 2012 21:41:28 +0100
Message-Id: <1327696888-8186-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

diff --git a/scripts/coccinelle/null/badzero.cocci b/scripts/coccinelle/null/badzero.cocci
new file mode 100644
index 0000000..5cb7e96
--- /dev/null
+++ b/scripts/coccinelle/null/badzero.cocci
@@ -0,0 +1,237 @@
+/// Compare pointer-typed values to NULL rather than 0
+///
+//# This makes an effort to choose between !x and x == NULL.  !x is used
+//# if it has previously been used with the function used to initialize x.
+//# This relies on type information.  More type information can be obtained
+//# using the option -all_includes and the option -I to specify an
+//# include path.
+//
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options:
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@initialize:ocaml@
+let negtable = Hashtbl.create 101
+
+@depends on patch@
+expression *E;
+identifier f;
+@@
+
+(
+  (E = f(...)) ==
+- 0
++ NULL
+|
+  (E = f(...)) !=
+- 0
++ NULL
+|
+- 0
++ NULL
+  == (E = f(...))
+|
+- 0
++ NULL
+  != (E = f(...))
+)
+
+
+@t1 depends on !patch@
+expression *E;
+identifier f;
+position p;
+@@
+
+(
+  (E = f(...)) ==
+* 0@p
+|
+  (E = f(...)) !=
+* 0@p
+|
+* 0@p
+  == (E = f(...))
+|
+* 0@p
+  != (E = f(...))
+)
+
+@script:python depends on org@
+p << t1.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING comparing pointer to 0")
+
+@script:python depends on report@
+p << t1.p;
+@@
+
+coccilib.report.print_report(p[0], "WARNING comparing pointer to 0")
+
+// Tests of returned values
+
+@s@
+identifier f;
+expression E,E1;
+@@
+
+ E = f(...)
+ ... when != E = E1
+ !E
+
+@script:ocaml depends on s@
+f << s.f;
+@@
+
+try let _ = Hashtbl.find negtable f in ()
+with Not_found -> Hashtbl.add negtable f ()
+
+@ r disable is_zero,isnt_zero exists @
+expression *E;
+identifier f;
+@@
+
+E = f(...)
+...
+(E == 0
+|E != 0
+|0 == E
+|0 != E
+)
+
+@script:ocaml@
+f << r.f;
+@@
+
+try let _ = Hashtbl.find negtable f in ()
+with Not_found -> include_match false
+
+// This rule may lead to inconsistent path problems, if E is defined in two
+// places
+@ depends on patch disable is_zero,isnt_zero @
+expression *E;
+expression E1;
+identifier r.f;
+@@
+
+E = f(...)
+<...
+(
+- E == 0
++ !E
+|
+- E != 0
++ E
+|
+- 0 == E
++ !E
+|
+- 0 != E
++ E
+)
+...>
+?E = E1
+
+@t2 depends on !patch disable is_zero,isnt_zero @
+expression *E;
+expression E1;
+identifier r.f;
+position p1;
+position p2;
+@@
+
+E = f(...)
+<...
+(
+* E == 0@p1
+|
+* E != 0@p2
+|
+* 0@p1 == E
+|
+* 0@p1 != E
+)
+...>
+?E = E1
+
+@script:python depends on org@
+p << t2.p1;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING comparing pointer to 0, suggest !E")
+
+@script:python depends on org@
+p << t2.p2;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING comparing pointer to 0")
+
+@script:python depends on report@
+p << t2.p1;
+@@
+
+coccilib.report.print_report(p[0], "WARNING comparing pointer to 0, suggest !E")
+
+@script:python depends on report@
+p << t2.p2;
+@@
+
+coccilib.report.print_report(p[0], "WARNING comparing pointer to 0")
+
+@ depends on patch disable is_zero,isnt_zero @
+expression *E;
+@@
+
+(
+  E ==
+- 0
++ NULL
+|
+  E !=
+- 0
++ NULL
+|
+- 0
++ NULL
+  == E
+|
+- 0
++ NULL
+  != E
+)
+
+@ t3 depends on !patch disable is_zero,isnt_zero @
+expression *E;
+position p;
+@@
+
+(
+* E == 0@p
+|
+* E != 0@p
+|
+* 0@p == E
+|
+* 0@p != E
+)
+
+@script:python depends on org@
+p << t3.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING comparing pointer to 0")
+
+@script:python depends on report@
+p << t3.p;
+@@
+
+coccilib.report.print_report(p[0], "WARNING comparing pointer to 0")

