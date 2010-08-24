Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0HXPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47953 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab0HXPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:40:07 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 17/18] Coccinelle: Add misc/doubleinit.cocci
Date: Tue, 24 Aug 2010 17:39:11 +0200
Message-Id: <1282664352-15882-18-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find duplicate field initializations.  This has a high rate of false
positives due to #ifdefs, which Coccinelle is not aware of in a structure
initialization.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/misc/doubleinit.cocci |   53 ++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/misc/doubleinit.cocci

diff --git a/scripts/coccinelle/misc/doubleinit.cocci b/scripts/coccinelle/misc/doubleinit.cocci
new file mode 100644
index 0000000..55d7dc1
--- /dev/null
+++ b/scripts/coccinelle/misc/doubleinit.cocci
@@ -0,0 +1,53 @@
+/// Find duplicate field initializations.  This has a high rate of false
+/// positives due to #ifdefs, which Coccinelle is not aware of in a structure
+/// initialization.
+///
+// Confidence: Low
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
+@r@
+identifier I, s, fld;
+position p0,p;
+expression E;
+@@
+
+struct I s =@p0 { ... .fld@p = E, ...};
+
+@s@
+identifier I, s, r.fld;
+position r.p0,p;
+expression E;
+@@
+
+struct I s =@p0 { ... .fld@p = E, ...};
+
+@script:python depends on org@
+p0 << r.p0;
+fld << r.fld;
+ps << s.p;
+pr << r.p;
+@@
+
+if int(ps[0].line) < int(pr[0].line) or (int(ps[0].line) == int(pr[0].line) and int(ps[0].column) < int(pr[0].column)):
+  cocci.print_main(fld,p0)
+  cocci.print_secs("s",ps)
+  cocci.print_secs("r",pr)
+
+@script:python depends on report@
+p0 << r.p0;
+fld << r.fld;
+ps << s.p;
+pr << r.p;
+@@
+
+if int(ps[0].line) < int(pr[0].line) or (int(ps[0].line) == int(pr[0].line) and int(ps[0].column) < int(pr[0].column)):
+  msg = "%s: first occurrence %s, second occurrence %s" % (fld,ps[0].line,pr[0].line)
+  coccilib.report.print_report(p0[0],msg)
-- 
1.7.0.4

