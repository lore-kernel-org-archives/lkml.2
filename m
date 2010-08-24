Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0HXPkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47820 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab0HXPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:54 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 09/18] Coccinelle: Add iterators/list_entry_update.cocci
Date: Tue, 24 Aug 2010 17:39:03 +0200
Message-Id: <1282664352-15882-10-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_entry uses its first argument to get from one element of
the list to the next, so it is usually not a good idea to reassign it.
The first rule finds such a reassignment and the second rule checks
that there is a path from the reassignment back to the top of the loop.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 .../coccinelle/iterators/list_entry_update.cocci   |   62 ++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/iterators/list_entry_update.cocci

diff --git a/scripts/coccinelle/iterators/list_entry_update.cocci b/scripts/coccinelle/iterators/list_entry_update.cocci
new file mode 100644
index 0000000..b296747
--- /dev/null
+++ b/scripts/coccinelle/iterators/list_entry_update.cocci
@@ -0,0 +1,62 @@
+/// list_for_each_entry uses its first argument to get from one element of
+/// the list to the next, so it is usually not a good idea to reassign it.
+/// The first rule finds such a reassignment and the second rule checks
+/// that there is a path from the reassignment back to the top of the loop.
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
+@r@
+iterator name list_for_each_entry;
+expression x,E;
+position p1,p2;
+@@
+
+list_for_each_entry@p1(x,...) { <... x =@p2 E ...> }
+
+@depends on context && !org && !report@
+expression x,E;
+position r.p1,r.p2;
+statement S;
+@@
+
+*x =@p2 E
+...
+list_for_each_entry@p1(x,...) S
+
+// ------------------------------------------------------------------------
+
+@back depends on (org || report) && !context exists@
+expression x,E;
+position r.p1,r.p2;
+statement S;
+@@
+
+x =@p2 E
+...
+list_for_each_entry@p1(x,...) S
+
+@script:python depends on back && org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("iterator",p1)
+cocci.print_secs("update",p2)
+
+@script:python depends on back && report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "iterator with update on line %s" % (p2[0].line)
+coccilib.report.print_report(p1[0],msg)
-- 
1.7.0.4

