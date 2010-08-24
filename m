Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0HXPkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47858 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0HXPkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:40:01 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 15/18] Coccinelle: Move resource_size.cocci to the api directory
Date: Tue, 24 Aug 2010 17:39:09 +0200
Message-Id: <1282664352-15882-16-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/api/resource_size.cocci |   93 ++++++++++++++++++++++++++++
 scripts/coccinelle/resource_size.cocci     |   93 ----------------------------
 2 files changed, 93 insertions(+), 93 deletions(-)
 create mode 100644 scripts/coccinelle/api/resource_size.cocci
 delete mode 100644 scripts/coccinelle/resource_size.cocci

diff --git a/scripts/coccinelle/api/resource_size.cocci b/scripts/coccinelle/api/resource_size.cocci
new file mode 100644
index 0000000..1935a58
--- /dev/null
+++ b/scripts/coccinelle/api/resource_size.cocci
@@ -0,0 +1,93 @@
+///
+/// Use resource_size function on resource object
+/// instead of explicit computation.
+///
+//  Confidence: High
+//  Copyright: (C) 2009, 2010 Nicolas Palix, DIKU.  GPLv2.
+//  Copyright: (C) 2009, 2010 Julia Lawall, DIKU.  GPLv2.
+//  Copyright: (C) 2009, 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+//  URL: http://coccinelle.lip6.fr/
+//  Options:
+//
+//  Keywords: resource_size
+//  Version min: 2.6.27 resource_size
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
+@r_context depends on context && !patch && !org@
+struct resource *res;
+@@
+
+* (res->end - res->start) + 1
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@r_patch depends on !context && patch && !org@
+struct resource *res;
+@@
+
+- (res->end - res->start) + 1
++ resource_size(res)
+
+//----------------------------------------------------------
+//  For org mode
+//----------------------------------------------------------
+
+
+@r_org depends on !context && !patch && (org || report)@
+struct resource *res;
+position p;
+@@
+
+ (res->end@p - res->start) + 1
+
+@rbad_org depends on !context && !patch && (org || report)@
+struct resource *res;
+position p != r_org.p;
+@@
+
+ res->end@p - res->start
+
+@script:python depends on org@
+p << r_org.p;
+x << r_org.res;
+@@
+
+msg="ERROR with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r_org.p;
+x << r_org.res;
+@@
+
+msg="ERROR: Missing resource_size with %s" % (x)
+coccilib.report.print_report(p[0], msg)
+
+@script:python depends on org@
+p << rbad_org.p;
+x << rbad_org.res;
+@@
+
+msg="WARNING with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << rbad_org.p;
+x << rbad_org.res;
+@@
+
+msg="WARNING: Suspicious code. resource_size is maybe missing with %s" % (x)
+coccilib.report.print_report(p[0], msg)
diff --git a/scripts/coccinelle/resource_size.cocci b/scripts/coccinelle/resource_size.cocci
deleted file mode 100644
index 1935a58..0000000
--- a/scripts/coccinelle/resource_size.cocci
+++ /dev/null
@@ -1,93 +0,0 @@
-///
-/// Use resource_size function on resource object
-/// instead of explicit computation.
-///
-//  Confidence: High
-//  Copyright: (C) 2009, 2010 Nicolas Palix, DIKU.  GPLv2.
-//  Copyright: (C) 2009, 2010 Julia Lawall, DIKU.  GPLv2.
-//  Copyright: (C) 2009, 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
-//  URL: http://coccinelle.lip6.fr/
-//  Options:
-//
-//  Keywords: resource_size
-//  Version min: 2.6.27 resource_size
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
-@r_context depends on context && !patch && !org@
-struct resource *res;
-@@
-
-* (res->end - res->start) + 1
-
-//----------------------------------------------------------
-//  For patch mode
-//----------------------------------------------------------
-
-@r_patch depends on !context && patch && !org@
-struct resource *res;
-@@
-
-- (res->end - res->start) + 1
-+ resource_size(res)
-
-//----------------------------------------------------------
-//  For org mode
-//----------------------------------------------------------
-
-
-@r_org depends on !context && !patch && (org || report)@
-struct resource *res;
-position p;
-@@
-
- (res->end@p - res->start) + 1
-
-@rbad_org depends on !context && !patch && (org || report)@
-struct resource *res;
-position p != r_org.p;
-@@
-
- res->end@p - res->start
-
-@script:python depends on org@
-p << r_org.p;
-x << r_org.res;
-@@
-
-msg="ERROR with %s" % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-coccilib.org.print_todo(p[0], msg_safe)
-
-@script:python depends on report@
-p << r_org.p;
-x << r_org.res;
-@@
-
-msg="ERROR: Missing resource_size with %s" % (x)
-coccilib.report.print_report(p[0], msg)
-
-@script:python depends on org@
-p << rbad_org.p;
-x << rbad_org.res;
-@@
-
-msg="WARNING with %s" % (x)
-msg_safe=msg.replace("[","@(").replace("]",")")
-coccilib.org.print_todo(p[0], msg_safe)
-
-@script:python depends on report@
-p << rbad_org.p;
-x << rbad_org.res;
-@@
-
-msg="WARNING: Suspicious code. resource_size is maybe missing with %s" % (x)
-coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

