Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2A0Ulg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:41:36 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37696 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab2A0Ulf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:41:35 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Subject: [PATCH] scripts/coccinelle: semantic patch for missing iounmap
Date: Fri, 27 Jan 2012 21:41:27 +0100
Message-Id: <1327696888-8186-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

diff --git a/scripts/coccinelle/free/iounmap.cocci b/scripts/coccinelle/free/iounmap.cocci
new file mode 100644
index 0000000..5384f4b
--- /dev/null
+++ b/scripts/coccinelle/free/iounmap.cocci
@@ -0,0 +1,67 @@
+/// Find missing iounmaps.
+///
+//# This only signals a missing iounmap when there is an iounmap later
+//# in the same function.
+//# False positives can be due to loops.
+//
+// Confidence: Moderate
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options:
+
+virtual context
+virtual org
+virtual report
+
+@iom@
+expression e;
+statement S,S1;
+int ret;
+position p1,p2,p3;
+@@
+
+e = \(ioremap@p1\|ioremap_nocache@p1\)(...)
+... when != iounmap(e)
+if (<+...e...+>) S
+... when any
+    when != iounmap(e)
+    when != if (...) { ... iounmap(e); ... }
+(
+ if (ret == 0) S1
+|
+if (...)
+   { ...
+     return 0; }
+|
+if (...)
+   { ...
+     return <+...e...+>; }
+|
+*if@p2 (...)
+   { ... when != iounmap(e)
+         when forall
+     return@p3 ...; }
+)
+... when any
+iounmap(e);
+
+@script:python depends on org@
+p1 << iom.p1;
+p2 << iom.p2;
+p3 << iom.p3;
+@@
+
+cocci.print_main("ioremap",p1)
+cocci.print_secs("if",p2)
+cocci.print_secs("needed iounmap",p3)
+
+@script:python depends on report@
+p1 << iom.p1;
+p2 << iom.p2;
+p3 << iom.p3;
+@@
+
+msg = "ERROR: missing iounmap; ioremap on line %s and execution via conditional on line %s" % (p1[0].line,p2[0].line)
+coccilib.report.print_report(p3[0],msg)
