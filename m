Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2HYUmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 16:42:51 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60289 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab2HYUmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 16:42:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170806531"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts/coccinelle/tests/odd_ptr_err.cocci: semantic patch for IS_ERR/PTR_ERR inconsistency
Date: Sat, 25 Aug 2012 22:42:45 +0200
Message-Id: <1345927365-26814-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/tests/odd_ptr_err.cocci |   65 +++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/scripts/coccinelle/tests/odd_ptr_err.cocci b/scripts/coccinelle/tests/odd_ptr_err.cocci
new file mode 100644
index 0000000..d114662
--- /dev/null
+++ b/scripts/coccinelle/tests/odd_ptr_err.cocci
@@ -0,0 +1,65 @@
+/// PTR_ERR should access the value just tested by IS_ERR
+//# There can be false positives in the patch case, where it is the call
+//# IS_ERR that is wrong.
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@depends on patch@
+expression e,e1;
+@@
+
+(
+if (IS_ERR(e)) { ... PTR_ERR(e) ... }
+|
+if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
+|
+if (IS_ERR(e))
+ { ...
+  PTR_ERR(
+-   e1
++   e
+  )
+   ... }
+)
+
+@r depends on !patch@
+expression e,e1;
+position p1,p2;
+@@
+
+(
+if (IS_ERR(e)) { ... PTR_ERR(e) ... }
+|
+if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
+|
+*if (IS_ERR@p1(e))
+ { ...
+*  PTR_ERR@p2(e1)
+   ... }
+)
+
+@script:python depends on org@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+cocci.print_main("inconsistent IS_ERR and PTR_ERR",p1)
+cocci.print_secs("PTR_ERR",p2)
+
+@script:python depends on report@
+p1 << r.p1;
+p2 << r.p2;
+@@
+
+msg = "inconsistent IS_ERR and PTR_ERR, PTR_ERR on line %s" % (p2[0].line)
+coccilib.report.print_report(p1[0],msg)

