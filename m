Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2ANWmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 17:42:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56476 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2ANWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 17:42:05 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Artem@mgw2.diku.dk,
        "Bityutskiy <dedekind1"@gmail.com, mmarek@suse.cz
Subject: [PATCH v2] scripts/coccinelle: improve the coverage of some semantic patches
Date: Sat, 14 Jan 2012 23:41:54 +0100
Message-Id: <1326580914-20464-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch ensures that all semantic patches in the scripts/coccinelle
directory provide the report option.  Report messages that include line
numbers now have the line number preceded by "line" for easier subsequent
processing.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/api/kstrdup.cocci      |   75 ++++++++++++++++++++++++++++--
 scripts/coccinelle/api/memdup.cocci       |   34 ++++++++++++-
 scripts/coccinelle/api/memdup_user.cocci  |   39 ++++++++++++---
 scripts/coccinelle/free/kfree.cocci       |   14 +++--
 scripts/coccinelle/iterators/fen.cocci    |   73 ++++++++++++++++++++++++++---
 scripts/coccinelle/iterators/itnull.cocci |   54 ++++++++++++++++++---
 scripts/coccinelle/locks/call_kern.cocci  |   67 +++++++++++++++++++-------
 scripts/coccinelle/locks/flags.cocci      |   12 ++--
 scripts/coccinelle/locks/mini_lock.cocci  |   15 +++---
 scripts/coccinelle/misc/doubleinit.cocci  |    8 +--
 scripts/coccinelle/null/eno.cocci         |   36 ++++++++++++--
 11 files changed, 351 insertions(+), 76 deletions(-)

diff --git a/scripts/coccinelle/api/kstrdup.cocci b/scripts/coccinelle/api/kstrdup.cocci
index e0805ad..07a74b2 100644
--- a/scripts/coccinelle/api/kstrdup.cocci
+++ b/scripts/coccinelle/api/kstrdup.cocci
@@ -1,16 +1,19 @@
 /// Use kstrdup rather than duplicating its implementation
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
-@@
+@depends on patch@
 expression from,to;
 expression flag,E1,E2;
 statement S;
@@ -23,7 +26,7 @@ statement S;
    ... when != \(from = E2 \| to = E2 \)
 -  strcpy(to, from);
 
-@@
+@depends on patch@
 expression x,from,to;
 expression flag,E1,E2,E3;
 statement S;
@@ -37,3 +40,65 @@ statement S;
     if (to==NULL || ...) S
     ... when != \(x = E3 \| from = E3 \| to = E3 \)
 -   memcpy(to, from, x);
+
+// ---------------------------------------------------------------------
+
+@r1 depends on !patch exists@
+expression from,to;
+expression flag,E1,E2;
+statement S;
+position p1,p2;
+@@
+
+*  to = kmalloc@p1(strlen(from) + 1,flag);
+   ... when != \(from = E1 \| to = E1 \)
+   if (to==NULL || ...) S
+   ... when != \(from = E2 \| to = E2 \)
+*  strcpy@p2(to, from);
+
+@r2 depends on !patch exists@
+expression x,from,to;
+expression flag,E1,E2,E3;
+statement S;
+position p1,p2;
+@@
+
+*   x = strlen(from) + 1;
+    ... when != \( x = E1 \| from = E1 \)
+*   to = \(kmalloc@p1\|kzalloc@p2\)(x,flag);
+    ... when != \(x = E2 \| from = E2 \| to = E2 \)
+    if (to==NULL || ...) S
+    ... when != \(x = E3 \| from = E3 \| to = E3 \)
+*   memcpy@p2(to, from, x);
+
+@script:python depends on org@
+p1 << r1.p1;
+p2 << r1.p2;
+@@
+
+cocci.print_main("WARNING opportunity for kstrdep",p1)
+cocci.print_secs("strcpy",p2)
+
+@script:python depends on org@
+p1 << r2.p1;
+p2 << r2.p2;
+@@
+
+cocci.print_main("WARNING opportunity for kstrdep",p1)
+cocci.print_secs("memcpy",p2)
+
+@script:python depends on report@
+p1 << r1.p1;
+p2 << r1.p2;
+@@
+
+msg = "WARNING opportunity for kstrdep (strcpy on line %s)" % (p2[0].line)
+coccilib.report.print_report(p1[0], msg)
+
+@script:python depends on report@
+p1 << r2.p1;
+p2 << r2.p2;
+@@
+
+msg = "WARNING opportunity for kstrdep (memcpy on line %s)" % (p2[0].line)
+coccilib.report.print_report(p1[0], msg)
diff --git a/scripts/coccinelle/api/memdup.cocci b/scripts/coccinelle/api/memdup.cocci
index b5d7220..4dceab6 100644
--- a/scripts/coccinelle/api/memdup.cocci
+++ b/scripts/coccinelle/api/memdup.cocci
@@ -1,14 +1,17 @@
 /// Use kmemdup rather than duplicating its implementation
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
 @r1@
 expression from,to;
@@ -28,7 +31,7 @@ position p;
     ... when != \( x = E1 \| from = E1 \)
     to = \(kmalloc@p\|kzalloc@p\)(x,flag);
 
-@@
+@depends on patch@
 expression from,to,size,flag;
 position p != {r1.p,r2.p};
 statement S;
@@ -38,3 +41,26 @@ statement S;
 +  to = kmemdup(from,size,flag);
    if (to==NULL || ...) S
 -  memcpy(to, from, size);
+
+@r depends on !patch@
+expression from,to,size,flag;
+position p != {r1.p,r2.p};
+statement S;
+@@
+
+*  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+   to = kmemdup(from,size,flag);
+   if (to==NULL || ...) S
+*  memcpy(to, from, size);
+
+@script:python depends on org@
+p << r.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING opportunity for kmemdep")
+
+@script:python depends on report@
+p << r.p;
+@@
+
+coccilib.report.print_report(p[0], "WARNING opportunity for kmemdep")
diff --git a/scripts/coccinelle/api/memdup_user.cocci b/scripts/coccinelle/api/memdup_user.cocci
index 72ce012..2efac28 100644
--- a/scripts/coccinelle/api/memdup_user.cocci
+++ b/scripts/coccinelle/api/memdup_user.cocci
@@ -1,23 +1,25 @@
-/// Use kmemdup_user rather than duplicating its implementation
+/// Use memdup_user rather than duplicating its implementation
 /// This is a little bit restricted to reduce false positives
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
-@@
+@depends on patch@
 expression from,to,size,flag;
-position p;
 identifier l1,l2;
 @@
 
--  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+-  to = \(kmalloc\|kzalloc\)(size,flag);
 +  to = memdup_user(from,size);
    if (
 -      to==NULL
@@ -33,3 +35,26 @@ identifier l1,l2;
 -    -EFAULT
 -    ...+>
 -  }
+
+@r depends on !patch@
+expression from,to,size,flag;
+position p;
+statement S1,S2;
+@@
+
+*  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+   if (to==NULL || ...) S1
+   if (copy_from_user(to, from, size) != 0)
+   S2
+
+@script:python depends on org@
+p << r.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING opportunity for memdep_user")
+
+@script:python depends on report@
+p << r.p;
+@@
+
+coccilib.report.print_report(p[0], "WARNING opportunity for memdep_user")
diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
index f9f79d9..d9ae6d8 100644
--- a/scripts/coccinelle/free/kfree.cocci
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -5,9 +5,9 @@
 //# SCTP_DBG_OBJCNT_DEC that do not actually evaluate their argument
 ///
 // Confidence: Moderate
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
@@ -23,7 +23,7 @@ position p1;
 kfree@p1(E)
 
 @print expression@
-constant char *c;
+constant char [] c;
 expression free.E,E2;
 type T;
 position p;
@@ -37,6 +37,10 @@ identifier f;
 |
  E@p != E2
 |
+ E2 == E@p
+|
+ E2 != E@p
+|
  !E@p
 |
  E@p || ...
@@ -113,5 +117,5 @@ p1 << free.p1;
 p2 << r.p2;
 @@
 
-msg = "reference preceded by free on line %s" % (p1[0].line)
+msg = "ERROR: reference preceded by free on line %s" % (p1[0].line)
 coccilib.report.print_report(p2[0],msg)
diff --git a/scripts/coccinelle/iterators/fen.cocci b/scripts/coccinelle/iterators/fen.cocci
index 77bc108..0a40af8 100644
--- a/scripts/coccinelle/iterators/fen.cocci
+++ b/scripts/coccinelle/iterators/fen.cocci
@@ -2,16 +2,19 @@
 /// is no point to call of_node_put on the final value.
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
-@@
+@depends on patch@
 iterator name for_each_node_by_name;
 expression np,E;
 identifier l;
@@ -24,7 +27,7 @@ for_each_node_by_name(np,...) {
 ... when != np = E
 - of_node_put(np);
 
-@@
+@depends on patch@
 iterator name for_each_node_by_type;
 expression np,E;
 identifier l;
@@ -37,7 +40,7 @@ for_each_node_by_type(np,...) {
 ... when != np = E
 - of_node_put(np);
 
-@@
+@depends on patch@
 iterator name for_each_compatible_node;
 expression np,E;
 identifier l;
@@ -50,7 +53,7 @@ for_each_compatible_node(np,...) {
 ... when != np = E
 - of_node_put(np);
 
-@@
+@depends on patch@
 iterator name for_each_matching_node;
 expression np,E;
 identifier l;
@@ -62,3 +65,59 @@ for_each_matching_node(np,...) {
 }
 ... when != np = E
 - of_node_put(np);
+
+// ----------------------------------------------------------------------
+
+@r depends on !patch forall@
+//iterator name for_each_node_by_name;
+//iterator name for_each_node_by_type;
+//iterator name for_each_compatible_node;
+//iterator name for_each_matching_node;
+expression np,E;
+identifier l;
+position p1,p2;
+@@
+
+(
+*for_each_node_by_name@p1(np,...)
+{
+  ... when != break;
+      when != goto l;
+}
+|
+*for_each_node_by_type@p1(np,...)
+{
+  ... when != break;
+      when != goto l;
+}
+|
+*for_each_compatible_node@p1(np,...)
+{
+  ... when != break;
+      when != goto l;
+}
+|
+*for_each_matching_node@p1(np,...)
+{
+  ... when != break;
+      when != goto l;
+}
+)
+... when != np = E
+* of_node_put@p2(np);
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("unneeded of_node_put",p2)
+cocci.print_secs("iterator",p1)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "ERROR: of_node_put not needed after iterator on line %s" % (p1[0].line)
+coccilib.report.print_report(p2[0], msg)
diff --git a/scripts/coccinelle/iterators/itnull.cocci b/scripts/coccinelle/iterators/itnull.cocci
index baa4297..259899f 100644
--- a/scripts/coccinelle/iterators/itnull.cocci
+++ b/scripts/coccinelle/iterators/itnull.cocci
@@ -1,20 +1,24 @@
 /// Many iterators have the property that the first argument is always bound
-/// to a real list element, never NULL.  False positives arise for some
-/// iterators that do not have this property, or in cases when the loop
-/// cursor is reassigned.  The latter should only happen when the matched
-/// code is on the way to a loop exit (break, goto, or return).
+/// to a real list element, never NULL.
+//# False positives arise for some iterators that do not have this property,
+//# or in cases when the loop cursor is reassigned.  The latter should only
+//# happen when the matched code is on the way to a loop exit (break, goto,
+//# or return).
 ///
 // Confidence: Moderate
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
-@@
+@depends on patch@
 iterator I;
 expression x,E,E1,E2;
 statement S,S1,S2;
@@ -55,4 +59,36 @@ I(x,...) { <...
   x != NULL
 + )
 )
-  ...> }
\ No newline at end of file
+  ...> }
+
+@r depends on !patch exists@
+iterator I;
+expression x,E;
+position p1,p2;
+@@
+
+*I@p1(x,...)
+{ ... when != x = E
+(
+*  x@p2 == NULL
+|
+*  x@p2 != NULL
+)
+  ... when any
+}
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("iterator-bound variable",p1)
+cocci.print_secs("useless NULL test",p2)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "ERROR: iterator variable bound on line %s cannot be NULL" % (p1[0].line)
+coccilib.report.print_report(p2[0], msg)
diff --git a/scripts/coccinelle/locks/call_kern.cocci b/scripts/coccinelle/locks/call_kern.cocci
index 00af534..8f10b49 100644
--- a/scripts/coccinelle/locks/call_kern.cocci
+++ b/scripts/coccinelle/locks/call_kern.cocci
@@ -1,17 +1,20 @@
 /// Find functions that refer to GFP_KERNEL but are called with locks held.
-/// The proposed change of converting the GFP_KERNEL is not necessarily the
-/// correct one.  It may be desired to unlock the lock, or to not call the
-/// function under the lock in the first place.
+//# The proposed change of converting the GFP_KERNEL is not necessarily the
+//# correct one.  It may be desired to unlock the lock, or to not call the
+//# function under the lock in the first place.
 ///
 // Confidence: Moderate
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
 @gfp exists@
 identifier fn;
@@ -32,28 +35,29 @@ fn(...) {
  ... when any
 }
 
-@locked@
+@locked exists@
 identifier gfp.fn;
+position p1,p2;
 @@
 
 (
-read_lock_irq
+read_lock_irq@p1
 |
-write_lock_irq
+write_lock_irq@p1
 |
-read_lock_irqsave
+read_lock_irqsave@p1
 |
-write_lock_irqsave
+write_lock_irqsave@p1
 |
-spin_lock
+spin_lock@p1
 |
-spin_trylock
+spin_trylock@p1
 |
-spin_lock_irq
+spin_lock_irq@p1
 |
-spin_lock_irqsave
+spin_lock_irqsave@p1
 |
-local_irq_disable
+local_irq_disable@p1
 )
  (...)
 ...  when != read_unlock_irq(...)
@@ -64,11 +68,38 @@ local_irq_disable
      when != spin_unlock_irq(...)
      when != spin_unlock_irqrestore(...)
      when != local_irq_enable(...)
-fn(...)
+fn@p2(...)
 
-@depends on locked@
+@depends on locked && patch@
 position gfp.p;
 @@
 
 - GFP_KERNEL@p
 + GFP_ATOMIC
+
+@depends on locked && !patch@
+position gfp.p;
+@@
+
+* GFP_KERNEL@p
+
+@script:python depends on !patch && org@
+p << gfp.p;
+fn << gfp.fn;
+p1 << locked.p1;
+p2 << locked.p2;
+@@
+
+cocci.print_main("lock",p1)
+cocci.print_secs("call",p2)
+cocci.print_secs("GFP_KERNEL",p)
+
+@script:python depends on !patch && report@
+p << gfp.p;
+fn << gfp.fn;
+p1 << locked.p1;
+p2 << locked.p2;
+@@
+
+msg = "ERROR: function %s called on line %s inside lock on line %s but uses GFP_KERNEL" % (fn,p2[0].line,p1[0].line)
+coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/locks/flags.cocci b/scripts/coccinelle/locks/flags.cocci
index b4344d8..1c4ffe6 100644
--- a/scripts/coccinelle/locks/flags.cocci
+++ b/scripts/coccinelle/locks/flags.cocci
@@ -1,9 +1,9 @@
 /// Find nested lock+irqsave functions that use the same flags variables
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
@@ -12,7 +12,7 @@ virtual context
 virtual org
 virtual report
 
-@r@
+@r exists@
 expression lock1,lock2,flags;
 position p1,p2;
 @@
@@ -39,7 +39,7 @@ read_lock_irqsave@p2(lock2,flags)
 write_lock_irqsave@p2(lock2,flags)
 )
 
-@d@
+@d exists@
 expression f <= r.flags;
 expression lock1,lock2,flags;
 position r.p1, r.p2;
@@ -76,5 +76,5 @@ p1 << r.p1;
 p2 << r.p2;
 @@
 
-msg="ERROR: nested lock+irqsave that reuses flags from %s." % (p1[0].line)
+msg="ERROR: nested lock+irqsave that reuses flags from line %s." % (p1[0].line)
 coccilib.report.print_report(p2[0], msg)
diff --git a/scripts/coccinelle/locks/mini_lock.cocci b/scripts/coccinelle/locks/mini_lock.cocci
index 7641a29..3267d74 100644
--- a/scripts/coccinelle/locks/mini_lock.cocci
+++ b/scripts/coccinelle/locks/mini_lock.cocci
@@ -6,13 +6,14 @@
 /// function call that releases the lock.
 ///
 // Confidence: Moderate
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
+virtual context
 virtual org
 virtual report
 
@@ -57,7 +58,7 @@ position r;
 
 for(...;...;...) { <+... return@r ...; ...+> }
 
-@err@
+@err exists@
 expression E1;
 position prelocked.p;
 position up != prelocked.p1;
@@ -65,14 +66,14 @@ position r!=looped.r;
 identifier lock,unlock;
 @@
 
-lock(E1@p,...);
+*lock(E1@p,...);
 <+... when != E1
 if (...) {
   ... when != E1
-  return@r ...;
+*  return@r ...;
 }
 ...+>
-unlock@up(E1,...);
+*unlock@up(E1,...);
 
 @script:python depends on org@
 p << prelocked.p1;
diff --git a/scripts/coccinelle/misc/doubleinit.cocci b/scripts/coccinelle/misc/doubleinit.cocci
index 156b20a..cf74a00 100644
--- a/scripts/coccinelle/misc/doubleinit.cocci
+++ b/scripts/coccinelle/misc/doubleinit.cocci
@@ -3,9 +3,9 @@
 /// initialization.
 ///
 // Confidence: Low
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments: requires at least Coccinelle 0.2.4, lex or parse error otherwise
 // Options: -no_includes -include_headers
@@ -49,5 +49,5 @@ pr << r.p;
 @@
 
 if int(ps[0].line) < int(pr[0].line) or (int(ps[0].line) == int(pr[0].line) and int(ps[0].column) < int(pr[0].column)):
-  msg = "%s: first occurrence %s, second occurrence %s" % (fld,ps[0].line,pr[0].line)
+  msg = "%s: first occurrence line %s, second occurrence line %s" % (fld,ps[0].line,pr[0].line)
   coccilib.report.print_report(p0[0],msg)
diff --git a/scripts/coccinelle/null/eno.cocci b/scripts/coccinelle/null/eno.cocci
index 4c9c52b..ed961a1 100644
--- a/scripts/coccinelle/null/eno.cocci
+++ b/scripts/coccinelle/null/eno.cocci
@@ -1,16 +1,19 @@
 /// The various basic memory allocation functions don't return ERR_PTR
 ///
 // Confidence: High
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// Copyright: (C) 2010-2012 Nicolas Palix.  GPLv2.
+// Copyright: (C) 2010-2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
 // Options: -no_includes -include_headers
 
 virtual patch
+virtual context
+virtual org
+virtual report
 
-@@
+@depends on patch@
 expression x,E;
 @@
 
@@ -18,3 +21,28 @@ x = \(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache
 ... when != x = E
 - IS_ERR(x)
 + !x
+
+@r depends on !patch exists@
+expression x,E;
+position p1,p2;
+@@
+
+*x = \(kmalloc@p1\|kzalloc@p1\|kcalloc@p1\|kmem_cache_alloc@p1\|kmem_cache_zalloc@p1\|kmem_cache_alloc_node@p1\|kmalloc_node@p1\|kzalloc_node@p1\)(...)
+... when != x = E
+* IS_ERR@p2(x)
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("alloc call",p1)
+cocci.print_secs("IS_ERR that should be NULL tests",p2)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "ERROR: allocation function on line %s returns NULL not ERR_PTR on failure" % (p1[0].line)
+coccilib.report.print_report(p2[0], msg)

