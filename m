Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0HXPkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47650 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab0HXPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:43 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 02/18] Coccinelle: Add null/kmerr.cocci
Date: Tue, 24 Aug 2010 17:38:56 +0200
Message-Id: <1282664352-15882-3-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch looks for kmalloc etc that are not followed by a
NULL check.  It only gives a report in the case where there is some
error handling code later in the function, which may be helpful
in determining what the error handling code for the call to kmalloc etc
should be.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/null/kmerr.cocci |   72 +++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/null/kmerr.cocci

diff --git a/scripts/coccinelle/null/kmerr.cocci b/scripts/coccinelle/null/kmerr.cocci
new file mode 100644
index 0000000..949bf65
--- /dev/null
+++ b/scripts/coccinelle/null/kmerr.cocci
@@ -0,0 +1,72 @@
+/// This semantic patch looks for kmalloc etc that are not followed by a
+/// NULL check.  It only gives a report in the case where there is some
+/// error handling code later in the function, which may be helpful
+/// in determining what the error handling code for the call to kmalloc etc
+/// should be.
+///
+// Confidence: High
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual context
+virtual org
+virtual report
+
+@withtest@
+expression x;
+position p;
+identifier f,fld;
+@@
+
+x@p = f(...);
+... when != x->fld
+\(x == NULL \| x != NULL\)
+
+@fixed depends on context && !org && !report@
+expression x,x1;
+position p1 != withtest.p;
+statement S;
+position any withtest.p;
+identifier f;
+@@
+
+*x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
+...
+*x1@p = f(...);
+if (!x1) S
+
+// ------------------------------------------------------------------------
+
+@rfixed depends on (org || report) && !context exists@
+expression x,x1;
+position p1 != withtest.p;
+position p2;
+statement S;
+position any withtest.p;
+identifier f;
+@@
+
+x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
+...
+x1@p = f@p2(...);
+if (!x1) S
+
+@script:python depends on org@
+p1 << rfixed.p1;
+p2 << rfixed.p2;
+@@
+
+cocci.print_main("alloc call",p1)
+cocci.print_secs("possible model",p2)
+
+@script:python depends on report@
+p1 << rfixed.p1;
+p2 << rfixed.p2;
+@@
+
+msg = "alloc with no test, possible model on line %s" % (p2[0].line)
+coccilib.report.print_report(p1[0],msg)
-- 
1.7.0.4

