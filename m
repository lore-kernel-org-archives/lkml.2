Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0HXPkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47655 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0HXPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:44 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 03/18] Coccinelle: Move deref_null.cocci to a more appropriate directory
Date: Tue, 24 Aug 2010 17:38:57 +0200
Message-Id: <1282664352-15882-4-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

deref_null.cocci is moved to the 'null' directory
which contains other null related rules.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/deref_null.cocci      |  293 ------------------------------
 scripts/coccinelle/null/deref_null.cocci |  293 ++++++++++++++++++++++++++++++
 2 files changed, 293 insertions(+), 293 deletions(-)
 delete mode 100644 scripts/coccinelle/deref_null.cocci
 create mode 100644 scripts/coccinelle/null/deref_null.cocci

diff --git a/scripts/coccinelle/deref_null.cocci b/scripts/coccinelle/deref_null.cocci
deleted file mode 100644
index 9969d76..0000000
--- a/scripts/coccinelle/deref_null.cocci
+++ /dev/null
@@ -1,293 +0,0 @@
-///
-/// A variable is dereference under a NULL test.
-/// Even though it is know to be NULL.
-///
-// Confidence: Moderate
-// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
-// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
-// URL: http://coccinelle.lip6.fr/
-// Comments: -I ... -all_includes can give more complete results
-// Options:
-
-virtual context
-virtual patch
-virtual org
-virtual report
-
-@initialize:python depends on !context && patch && !org && !report@
-
-import sys
-print >> sys.stderr, "This semantic patch does not support the 'patch' mode."
-
-@depends on patch@
-@@
-
-this_rule_should_never_matches();
-
-@ifm depends on !patch@
-expression *E;
-statement S1,S2;
-position p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...) S1 else S2
-
-// The following two rules are separate, because both can match a single
-// expression in different ways
-@pr1 depends on !patch expression@
-expression *ifm.E;
-identifier f;
-position p1;
-@@
-
- (E != NULL && ...) ? <+...E->f@p1...+> : ...
-
-@pr2 depends on !patch expression@
-expression *ifm.E;
-identifier f;
-position p2;
-@@
-
-(
-  (E != NULL) && ... && <+...E->f@p2...+>
-|
-  (E == NULL) || ... || <+...E->f@p2...+>
-|
- sizeof(<+...E->f@p2...+>)
-)
-
-// For org and report modes
-
-@r depends on !context && !patch && (org || report) exists@
-expression subE <= ifm.E;
-expression *ifm.E;
-expression E1,E2;
-identifier f;
-statement S1,S2,S3,S4;
-iterator iter;
-position p!={pr1.p1,pr2.p2};
-position ifm.p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...)
-{
-  ... when != if (...) S1 else S2
-(
- iter(subE,...) S4 // no use
-|
- list_remove_head(E2,subE,...)
-|
- subE = E1
-|
- for(subE = E1;...;...) S4
-|
- subE++
-|
- ++subE
-|
- --subE
-|
- subE--
-|
- &subE
-|
- E->f@p // bad use
-)
-  ... when any
-  return ...;
-}
-else S3
-
-@script:python depends on !context && !patch && !org && report@
-p << r.p;
-p1 << ifm.p1;
-x << ifm.E;
-@@
-
-msg="ERROR: %s is NULL but dereferenced." % (x)
-coccilib.report.print_report(p[0], msg)
-cocci.include_match(False)
-
-@script:python depends on !context && !patch && org && !report@
-p << r.p;
-p1 << ifm.p1;
-x << ifm.E;
-@@
-
-msg="ERROR: %s is NULL but dereferenced." % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-cocci.print_main(msg_safe,p)
-cocci.include_match(False)
-
-@s depends on !context && !patch && (org || report) exists@
-expression subE <= ifm.E;
-expression *ifm.E;
-expression E1,E2;
-identifier f;
-statement S1,S2,S3,S4;
-iterator iter;
-position p!={pr1.p1,pr2.p2};
-position ifm.p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...)
-{
-  ... when != if (...) S1 else S2
-(
- iter(subE,...) S4 // no use
-|
- list_remove_head(E2,subE,...)
-|
- subE = E1
-|
- for(subE = E1;...;...) S4
-|
- subE++
-|
- ++subE
-|
- --subE
-|
- subE--
-|
- &subE
-|
- E->f@p // bad use
-)
-  ... when any
-}
-else S3
-
-@script:python depends on !context && !patch && !org && report@
-p << s.p;
-p1 << ifm.p1;
-x << ifm.E;
-@@
-
-msg="ERROR: %s is NULL but dereferenced." % (x)
-coccilib.report.print_report(p[0], msg)
-
-@script:python depends on !context && !patch && org && !report@
-p << s.p;
-p1 << ifm.p1;
-x << ifm.E;
-@@
-
-msg="ERROR: %s is NULL but dereferenced." % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-cocci.print_main(msg_safe,p)
-
-// For context mode
-
-@depends on context && !patch && !org && !report exists@
-expression subE <= ifm.E;
-expression *ifm.E;
-expression E1,E2;
-identifier f;
-statement S1,S2,S3,S4;
-iterator iter;
-position p!={pr1.p1,pr2.p2};
-position ifm.p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...)
-{
-  ... when != if (...) S1 else S2
-(
- iter(subE,...) S4 // no use
-|
- list_remove_head(E2,subE,...)
-|
- subE = E1
-|
- for(subE = E1;...;...) S4
-|
- subE++
-|
- ++subE
-|
- --subE
-|
- subE--
-|
- &subE
-|
-* E->f@p // bad use
-)
-  ... when any
-  return ...;
-}
-else S3
-
-// The following three rules are duplicates of ifm, pr1 and pr2 respectively.
-// It is need because the previous rule as already made a "change".
-
-@ifm1 depends on !patch@
-expression *E;
-statement S1,S2;
-position p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...) S1 else S2
-
-@pr11 depends on !patch expression@
-expression *ifm1.E;
-identifier f;
-position p1;
-@@
-
- (E != NULL && ...) ? <+...E->f@p1...+> : ...
-
-@pr12 depends on !patch expression@
-expression *ifm1.E;
-identifier f;
-position p2;
-@@
-
-(
-  (E != NULL) && ... && <+...E->f@p2...+>
-|
-  (E == NULL) || ... || <+...E->f@p2...+>
-|
- sizeof(<+...E->f@p2...+>)
-)
-
-@depends on context && !patch && !org && !report exists@
-expression subE <= ifm1.E;
-expression *ifm1.E;
-expression E1,E2;
-identifier f;
-statement S1,S2,S3,S4;
-iterator iter;
-position p!={pr11.p1,pr12.p2};
-position ifm1.p1;
-@@
-
-if@p1 ((E == NULL && ...) || ...)
-{
-  ... when != if (...) S1 else S2
-(
- iter(subE,...) S4 // no use
-|
- list_remove_head(E2,subE,...)
-|
- subE = E1
-|
- for(subE = E1;...;...) S4
-|
- subE++
-|
- ++subE
-|
- --subE
-|
- subE--
-|
- &subE
-|
-* E->f@p // bad use
-)
-  ... when any
-}
-else S3
diff --git a/scripts/coccinelle/null/deref_null.cocci b/scripts/coccinelle/null/deref_null.cocci
new file mode 100644
index 0000000..9969d76
--- /dev/null
+++ b/scripts/coccinelle/null/deref_null.cocci
@@ -0,0 +1,293 @@
+///
+/// A variable is dereference under a NULL test.
+/// Even though it is know to be NULL.
+///
+// Confidence: Moderate
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments: -I ... -all_includes can give more complete results
+// Options:
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+@initialize:python depends on !context && patch && !org && !report@
+
+import sys
+print >> sys.stderr, "This semantic patch does not support the 'patch' mode."
+
+@depends on patch@
+@@
+
+this_rule_should_never_matches();
+
+@ifm depends on !patch@
+expression *E;
+statement S1,S2;
+position p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...) S1 else S2
+
+// The following two rules are separate, because both can match a single
+// expression in different ways
+@pr1 depends on !patch expression@
+expression *ifm.E;
+identifier f;
+position p1;
+@@
+
+ (E != NULL && ...) ? <+...E->f@p1...+> : ...
+
+@pr2 depends on !patch expression@
+expression *ifm.E;
+identifier f;
+position p2;
+@@
+
+(
+  (E != NULL) && ... && <+...E->f@p2...+>
+|
+  (E == NULL) || ... || <+...E->f@p2...+>
+|
+ sizeof(<+...E->f@p2...+>)
+)
+
+// For org and report modes
+
+@r depends on !context && !patch && (org || report) exists@
+expression subE <= ifm.E;
+expression *ifm.E;
+expression E1,E2;
+identifier f;
+statement S1,S2,S3,S4;
+iterator iter;
+position p!={pr1.p1,pr2.p2};
+position ifm.p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...)
+{
+  ... when != if (...) S1 else S2
+(
+ iter(subE,...) S4 // no use
+|
+ list_remove_head(E2,subE,...)
+|
+ subE = E1
+|
+ for(subE = E1;...;...) S4
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
+ E->f@p // bad use
+)
+  ... when any
+  return ...;
+}
+else S3
+
+@script:python depends on !context && !patch && !org && report@
+p << r.p;
+p1 << ifm.p1;
+x << ifm.E;
+@@
+
+msg="ERROR: %s is NULL but dereferenced." % (x)
+coccilib.report.print_report(p[0], msg)
+cocci.include_match(False)
+
+@script:python depends on !context && !patch && org && !report@
+p << r.p;
+p1 << ifm.p1;
+x << ifm.E;
+@@
+
+msg="ERROR: %s is NULL but dereferenced." % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+cocci.print_main(msg_safe,p)
+cocci.include_match(False)
+
+@s depends on !context && !patch && (org || report) exists@
+expression subE <= ifm.E;
+expression *ifm.E;
+expression E1,E2;
+identifier f;
+statement S1,S2,S3,S4;
+iterator iter;
+position p!={pr1.p1,pr2.p2};
+position ifm.p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...)
+{
+  ... when != if (...) S1 else S2
+(
+ iter(subE,...) S4 // no use
+|
+ list_remove_head(E2,subE,...)
+|
+ subE = E1
+|
+ for(subE = E1;...;...) S4
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
+ E->f@p // bad use
+)
+  ... when any
+}
+else S3
+
+@script:python depends on !context && !patch && !org && report@
+p << s.p;
+p1 << ifm.p1;
+x << ifm.E;
+@@
+
+msg="ERROR: %s is NULL but dereferenced." % (x)
+coccilib.report.print_report(p[0], msg)
+
+@script:python depends on !context && !patch && org && !report@
+p << s.p;
+p1 << ifm.p1;
+x << ifm.E;
+@@
+
+msg="ERROR: %s is NULL but dereferenced." % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+cocci.print_main(msg_safe,p)
+
+// For context mode
+
+@depends on context && !patch && !org && !report exists@
+expression subE <= ifm.E;
+expression *ifm.E;
+expression E1,E2;
+identifier f;
+statement S1,S2,S3,S4;
+iterator iter;
+position p!={pr1.p1,pr2.p2};
+position ifm.p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...)
+{
+  ... when != if (...) S1 else S2
+(
+ iter(subE,...) S4 // no use
+|
+ list_remove_head(E2,subE,...)
+|
+ subE = E1
+|
+ for(subE = E1;...;...) S4
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
+* E->f@p // bad use
+)
+  ... when any
+  return ...;
+}
+else S3
+
+// The following three rules are duplicates of ifm, pr1 and pr2 respectively.
+// It is need because the previous rule as already made a "change".
+
+@ifm1 depends on !patch@
+expression *E;
+statement S1,S2;
+position p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...) S1 else S2
+
+@pr11 depends on !patch expression@
+expression *ifm1.E;
+identifier f;
+position p1;
+@@
+
+ (E != NULL && ...) ? <+...E->f@p1...+> : ...
+
+@pr12 depends on !patch expression@
+expression *ifm1.E;
+identifier f;
+position p2;
+@@
+
+(
+  (E != NULL) && ... && <+...E->f@p2...+>
+|
+  (E == NULL) || ... || <+...E->f@p2...+>
+|
+ sizeof(<+...E->f@p2...+>)
+)
+
+@depends on context && !patch && !org && !report exists@
+expression subE <= ifm1.E;
+expression *ifm1.E;
+expression E1,E2;
+identifier f;
+statement S1,S2,S3,S4;
+iterator iter;
+position p!={pr11.p1,pr12.p2};
+position ifm1.p1;
+@@
+
+if@p1 ((E == NULL && ...) || ...)
+{
+  ... when != if (...) S1 else S2
+(
+ iter(subE,...) S4 // no use
+|
+ list_remove_head(E2,subE,...)
+|
+ subE = E1
+|
+ for(subE = E1;...;...) S4
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
+* E->f@p // bad use
+)
+  ... when any
+}
+else S3
-- 
1.7.0.4

