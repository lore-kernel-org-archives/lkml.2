Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0HXPki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47844 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0HXPj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:59 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 13/18] Coccinelle: Add api/memdup_user
Date: Tue, 24 Aug 2010 17:39:07 +0200
Message-Id: <1282664352-15882-14-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup_user rather than duplicating its implementation
This is a little bit restricted to reduce false positives

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/api/memdup_user.cocci |   35 ++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/api/memdup_user.cocci

diff --git a/scripts/coccinelle/api/memdup_user.cocci b/scripts/coccinelle/api/memdup_user.cocci
new file mode 100644
index 0000000..72ce012
--- /dev/null
+++ b/scripts/coccinelle/api/memdup_user.cocci
@@ -0,0 +1,35 @@
+/// Use kmemdup_user rather than duplicating its implementation
+/// This is a little bit restricted to reduce false positives
+///
+// Confidence: High
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+
+@@
+expression from,to,size,flag;
+position p;
+identifier l1,l2;
+@@
+
+-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
++  to = memdup_user(from,size);
+   if (
+-      to==NULL
++      IS_ERR(to)
+                 || ...) {
+   <+... when != goto l1;
+-  -ENOMEM
++  PTR_ERR(to)
+   ...+>
+   }
+-  if (copy_from_user(to, from, size) != 0) {
+-    <+... when != goto l2;
+-    -EFAULT
+-    ...+>
+-  }
-- 
1.7.0.4

