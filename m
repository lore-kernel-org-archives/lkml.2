Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2KKUzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 15:55:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41929 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2KKUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 15:55:03 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        cocci@systeme.lip6.fr, mmarek@suse.cz
Subject: [PATCH 1/3] Coccinelle: Add api/d_find_alias.cocci.
Date: Sun, 11 Nov 2012 21:49:29 +0100
Message-Id: <1352666971-13551-2-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that calls to d_find_alias() have a corresponding dput().

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 scripts/coccinelle/api/d_find_alias.cocci |   80 +++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 scripts/coccinelle/api/d_find_alias.cocci

diff --git a/scripts/coccinelle/api/d_find_alias.cocci b/scripts/coccinelle/api/d_find_alias.cocci
new file mode 100644
index 0000000..639eec7
--- /dev/null
+++ b/scripts/coccinelle/api/d_find_alias.cocci
@@ -0,0 +1,80 @@
+/// Make sure calls to d_find_alias() have a corresponding call to dput().
+//
+// Keywords: d_find_alias, dput
+//
+// Confidence: Moderate
+// URL: http://coccinelle.lip6.fr/
+// Options: -include_headers
+
+virtual context
+virtual org
+virtual patch
+virtual report
+
+@r exists@
+local idexpression struct dentry *dent;
+expression E, E1;
+statement S1, S2;
+position p1, p2;
+@@
+(
+	if (!(dent@p1 = d_find_alias(...))) S1
+|
+	dent@p1 = d_find_alias(...)
+)
+
+<...when != dput(dent)
+    when != if (...) { <+... dput(dent) ...+> }
+    when != true !dent || ...
+    when != dent = E
+    when != E = dent
+if (!dent || ...) S2
+...>
+(
+	return <+...dent...+>;
+|
+	return @p2 ...;
+|
+	dent@p2 = E1;
+|
+	E1 = dent;
+)
+
+@depends on context@
+local idexpression struct dentry *r.dent;
+position r.p1,r.p2;
+@@
+* dent@p1 = ...
+  ...
+(
+* return@p2 ...;
+|
+* dent@p2
+)
+
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+cocci.print_main("Missing call to dput()",p1)
+cocci.print_secs("",p2)
+
+@depends on patch@
+local idexpression struct dentry *r.dent;
+position r.p2;
+@@
+(
++ dput(dent);
+  return @p2 ...;
+|
++ dput(dent);
+  dent@p2 = ...;
+)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+msg = "Missing call to dput() at line %s."
+coccilib.report.print_report(p1[0], msg % (p2[0].line))
-- 
1.7.10.4

