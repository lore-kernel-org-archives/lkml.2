Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1L0Qlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:41:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40603 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab1L0Qlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:41:39 -0500
From: Julia Lawall <julia.lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Subject: [PATCH 1/2] scripts/coccinelle: semantic patches related to devm_ functions
Date: Tue, 27 Dec 2011 17:41:31 +0100
Message-Id: <1325004092-28162-1-git-send-email-julia.lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_ functions allocate memory that is to remain allocated until the
device is detached.  This patch checks for opportunities for using the
function devm_request_and_ioremap.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
resend to fix email address

diff --git a/scripts/coccinelle/api/devm_request_and_ioremap.cocci b/scripts/coccinelle/api/devm_request_and_ioremap.cocci
new file mode 100644
index 0000000..46beb81
--- /dev/null
+++ b/scripts/coccinelle/api/devm_request_and_ioremap.cocci
@@ -0,0 +1,105 @@
+/// Reimplement a call to devm_request_mem_region followed by a call to ioremap
+/// or ioremap_nocache by a call to devm_request_and_ioremap.
+/// Devm_request_and_ioremap was introduced in
+/// 72f8c0bfa0de64c68ee59f40eb9b2683bffffbb0.  It makes the code much more
+/// concise.
+///
+///
+// Confidence: High
+// Copyright: (C) 2011 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2011 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+virtual org
+virtual report
+virtual context
+
+@nm@
+expression myname;
+identifier i;
+@@
+
+struct platform_driver i = { .driver = { .name = myname } };
+
+@depends on patch@
+expression dev,res,size;
+@@
+
+-if (!devm_request_mem_region(dev, res->start, size,
+-                              \(res->name\|dev_name(dev)\))) {
+-   ...
+-   return ...;
+-}
+... when != res->start
+(
+-devm_ioremap(dev,res->start,size)
++devm_request_and_ioremap(dev,res)
+|
+-devm_ioremap_nocache(dev,res->start,size)
++devm_request_and_ioremap(dev,res)
+)
+... when any
+    when != res->start
+
+// this rule is separate from the previous one, because a single file can
+// have multiple values of myname
+@depends on patch@
+expression dev,res,size;
+expression nm.myname;
+@@
+
+-if (!devm_request_mem_region(dev, res->start, size,myname)) {
+-   ...
+-   return ...;
+-}
+... when != res->start
+(
+-devm_ioremap(dev,res->start,size)
++devm_request_and_ioremap(dev,res)
+|
+-devm_ioremap_nocache(dev,res->start,size)
++devm_request_and_ioremap(dev,res)
+)
+... when any
+    when != res->start
+
+
+@pb depends on org || report || context@
+expression dev,res,size;
+expression nm.myname;
+position p1,p2;
+@@
+
+*if
+  (!devm_request_mem_region@p1(dev, res->start, size,
+                              \(res->name\|dev_name(dev)\|myname\))) {
+   ...
+   return ...;
+}
+... when != res->start
+(
+*devm_ioremap@p2(dev,res->start,size)
+|
+*devm_ioremap_nocache@p2(dev,res->start,size)
+)
+... when any
+    when != res->start
+
+@script:python depends on org@
+p1 << pb.p1;
+p2 << pb.p2;
+@@
+
+cocci.print_main("INFO: replace by devm_request_and_ioremap",p1)
+cocci.print_secs("",p2)
+
+@script:python depends on report@
+p1 << pb.p1;
+p2 << pb.p2;
+@@
+
+msg = "INFO: devm_request_mem_region followed by ioremap on line %s can be replaced by devm_request_and_ioremap" % (p2[0].line)
+coccilib.report.print_report(p1[0],msg)
