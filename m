Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0HXPkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47903 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab0HXPkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:40:03 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 16/18] Coccinelle: Move alloc directory into api directory
Date: Tue, 24 Aug 2010 17:39:10 +0200
Message-Id: <1282664352-15882-17-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc contains various semantic patches related
to the allocation APIs

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci   |   67 ---------------
 scripts/coccinelle/alloc/kzalloc-simple.cocci      |   86 --------------------
 .../coccinelle/api/alloc/drop_kmalloc_cast.cocci   |   67 +++++++++++++++
 scripts/coccinelle/api/alloc/kzalloc-simple.cocci  |   86 ++++++++++++++++++++
 4 files changed, 153 insertions(+), 153 deletions(-)
 delete mode 100644 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
 delete mode 100644 scripts/coccinelle/alloc/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
 create mode 100644 scripts/coccinelle/api/alloc/kzalloc-simple.cocci

diff --git a/scripts/coccinelle/alloc/drop_kmalloc_cast.cocci b/scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
deleted file mode 100644
index 7d4771d..0000000
--- a/scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
+++ /dev/null
@@ -1,67 +0,0 @@
-///
-/// Casting (void *) value returned by kmalloc is useless
-/// as mentioned in Documentation/CodingStyle, Chap 14.
-///
-// Confidence: High
-// Copyright: 2009,2010 Nicolas Palix, DIKU.  GPLv2.
-// URL: http://coccinelle.lip6.fr/
-// Options: -no_includes -include_headers
-//
-// Keywords: kmalloc, kzalloc, kcalloc
-// Version min: < 2.6.12 kmalloc
-// Version min: < 2.6.12 kcalloc
-// Version min:   2.6.14 kzalloc
-//
-
-virtual context
-virtual patch
-virtual org
-virtual report
-
-//----------------------------------------------------------
-//  For context mode
-//----------------------------------------------------------
-
-@depends on context@
-type T;
-@@
-
-* (T *)
-  \(kmalloc\|kzalloc\|kcalloc\)(...)
-
-//----------------------------------------------------------
-//  For patch mode
-//----------------------------------------------------------
-
-@depends on patch@
-type T;
-@@
-
-- (T *)
-  \(kmalloc\|kzalloc\|kcalloc\)(...)
-
-//----------------------------------------------------------
-//  For org and report mode
-//----------------------------------------------------------
-
-@r depends on org || report@
-type T;
-position p;
-@@
-
- (T@p *)\(kmalloc\|kzalloc\|kcalloc\)(...)
-
-@script:python depends on org@
-p << r.p;
-t << r.T;
-@@
-
-coccilib.org.print_safe_todo(p[0], t)
-
-@script:python depends on report@
-p << r.p;
-t << r.T;
-@@
-
-msg="WARNING: casting value returned by k[cmz]alloc to (%s *) is useless." % (t)
-coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/alloc/kzalloc-simple.cocci b/scripts/coccinelle/alloc/kzalloc-simple.cocci
deleted file mode 100644
index 046b9b1..0000000
--- a/scripts/coccinelle/alloc/kzalloc-simple.cocci
+++ /dev/null
@@ -1,86 +0,0 @@
-///
-/// Use kzalloc rather than kmalloc followed by memset with 0
-///
-/// This considers some simple cases that are common and easy to validate
-/// Note in particular that there are no ...s in the rule, so all of the
-/// matched code has to be contiguous
-///
-// Confidence: High
-// Copyright: (C) 2009-2010 Julia Lawall, Nicolas Palix, DIKU.  GPLv2.
-// Copyright: (C) 2009-2010 Gilles Muller, INRIA/LiP6.  GPLv2.
-// URL: http://coccinelle.lip6.fr/rules/kzalloc.html
-// Options: -no_includes -include_headers
-//
-// Keywords: kmalloc, kzalloc
-// Version min: < 2.6.12 kmalloc
-// Version min:   2.6.14 kzalloc
-//
-
-virtual context
-virtual patch
-virtual org
-virtual report
-
-//----------------------------------------------------------
-//  For context mode
-//----------------------------------------------------------
-
-@depends on context@
-type T, T2;
-expression x;
-expression E1,E2;
-statement S;
-@@
-
-* x = (T)kmalloc(E1,E2);
-  if ((x==NULL) || ...) S
-* memset((T2)x,0,E1);
-
-//----------------------------------------------------------
-//  For patch mode
-//----------------------------------------------------------
-
-@depends on patch@
-type T, T2;
-expression x;
-expression E1,E2;
-statement S;
-@@
-
-- x = (T)kmalloc(E1,E2);
-+ x = kzalloc(E1,E2);
-  if ((x==NULL) || ...) S
-- memset((T2)x,0,E1);
-
-//----------------------------------------------------------
-//  For org mode
-//----------------------------------------------------------
-
-@r depends on org || report@
-type T, T2;
-expression x;
-expression E1,E2;
-statement S;
-position p;
-@@
-
- x = (T)kmalloc@p(E1,E2);
- if ((x==NULL) || ...) S
- memset((T2)x,0,E1);
-
-@script:python depends on org@
-p << r.p;
-x << r.x;
-@@
-
-msg="%s" % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-coccilib.org.print_todo(p[0], msg_safe)
-
-@script:python depends on report@
-p << r.p;
-x << r.x;
-@@
-
-msg="WARNING: kzalloc should be used for %s, instead of kmalloc/memset" % (x)
-coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci b/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
new file mode 100644
index 0000000..7d4771d
--- /dev/null
+++ b/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
@@ -0,0 +1,67 @@
+///
+/// Casting (void *) value returned by kmalloc is useless
+/// as mentioned in Documentation/CodingStyle, Chap 14.
+///
+// Confidence: High
+// Copyright: 2009,2010 Nicolas Palix, DIKU.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options: -no_includes -include_headers
+//
+// Keywords: kmalloc, kzalloc, kcalloc
+// Version min: < 2.6.12 kmalloc
+// Version min: < 2.6.12 kcalloc
+// Version min:   2.6.14 kzalloc
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context@
+type T;
+@@
+
+* (T *)
+  \(kmalloc\|kzalloc\|kcalloc\)(...)
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+type T;
+@@
+
+- (T *)
+  \(kmalloc\|kzalloc\|kcalloc\)(...)
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+type T;
+position p;
+@@
+
+ (T@p *)\(kmalloc\|kzalloc\|kcalloc\)(...)
+
+@script:python depends on org@
+p << r.p;
+t << r.T;
+@@
+
+coccilib.org.print_safe_todo(p[0], t)
+
+@script:python depends on report@
+p << r.p;
+t << r.T;
+@@
+
+msg="WARNING: casting value returned by k[cmz]alloc to (%s *) is useless." % (t)
+coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/api/alloc/kzalloc-simple.cocci b/scripts/coccinelle/api/alloc/kzalloc-simple.cocci
new file mode 100644
index 0000000..046b9b1
--- /dev/null
+++ b/scripts/coccinelle/api/alloc/kzalloc-simple.cocci
@@ -0,0 +1,86 @@
+///
+/// Use kzalloc rather than kmalloc followed by memset with 0
+///
+/// This considers some simple cases that are common and easy to validate
+/// Note in particular that there are no ...s in the rule, so all of the
+/// matched code has to be contiguous
+///
+// Confidence: High
+// Copyright: (C) 2009-2010 Julia Lawall, Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2009-2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/rules/kzalloc.html
+// Options: -no_includes -include_headers
+//
+// Keywords: kmalloc, kzalloc
+// Version min: < 2.6.12 kmalloc
+// Version min:   2.6.14 kzalloc
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context@
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+@@
+
+* x = (T)kmalloc(E1,E2);
+  if ((x==NULL) || ...) S
+* memset((T2)x,0,E1);
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+@@
+
+- x = (T)kmalloc(E1,E2);
++ x = kzalloc(E1,E2);
+  if ((x==NULL) || ...) S
+- memset((T2)x,0,E1);
+
+//----------------------------------------------------------
+//  For org mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+position p;
+@@
+
+ x = (T)kmalloc@p(E1,E2);
+ if ((x==NULL) || ...) S
+ memset((T2)x,0,E1);
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="%s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: kzalloc should be used for %s, instead of kmalloc/memset" % (x)
+coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

