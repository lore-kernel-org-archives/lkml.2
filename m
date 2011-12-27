Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1L0Qlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:41:45 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40610 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1L0Qlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:41:39 -0500
From: Julia Lawall <julia.lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Subject: [PATCH 2/2] scripts/coccinelle: semantic patches related to devm_ functions
Date: Tue, 27 Dec 2011 17:41:32 +0100
Message-Id: <1325004092-28162-2-git-send-email-julia.lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_ functions allocate memory that is to remain allocated until the
device is detached.  This patch checks for freeing of such memory using
standard memory freeing functions.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
resend to fix email address

diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
new file mode 100644
index 0000000..c0cd3e2
--- /dev/null
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -0,0 +1,71 @@
+/// Find uses of standard freeing functons on values allocated using devm_
+/// functions.  Values allocated using the devm_functions are freed when
+/// the device is detached, and thus the use of the standard freeing
+/// function would cause a double free.
+/// See Documentation/driver-model/devres.txt for more information.
+///
+/// A difficulty of detecting this problem is that the standard freeing
+/// function might be called from a different function than the one
+/// containing the allocation function.  It is thus necessary to make the
+/// connection between the allocation function and the freeing function.
+/// Here this is done using the specific argument text, which is prone to
+/// false positives.  There is no rule for the request_region and
+/// request_mem_region variants because this heuristic seems to be a bit
+/// less reliable in these cases.
+///
+// Confidence: Moderate
+// Copyright: (C) 2011 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2011 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || org || report@
+expression x;
+@@
+
+(
+ x = devm_kzalloc(...)
+|
+ x = devm_request_irq(...)
+|
+ x = devm_ioremap(...)
+|
+ x = devm_ioremap_nocache(...)
+|
+ x = devm_ioport_map(...)
+)
+
+@pb@
+expression r.x;
+position p;
+@@
+
+(
+* kfree@p(x)
+|
+* free_irq@p(x)
+|
+* iounmap@p(x)
+|
+* ioport_unmap@p(x)
+)
+
+@script:python depends on org@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of devm_ allocated data"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of devm_ allocated data"
+coccilib.report.print_report(p[0], msg)
+

