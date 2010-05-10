Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0EJQYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:24:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43856 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0EJQYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:24:50 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Nicolas Palix <npalix@diku.dk>, Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/4] Add scripts/coccinelle/drop_kmalloc_cast.cocci
Date: Mon, 10 May 2010 18:24:25 +0200
Message-Id: <1273508667-5152-3-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273508667-5152-1-git-send-email-npalix@diku.dk>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this semantic patch is to remove
useless casts, as mentioned in the Linux documentation.
See Chapter 14 in Documentation/CodingStyle for more information.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/drop_kmalloc_cast.cocci |   68 ++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/drop_kmalloc_cast.cocci

diff --git a/scripts/coccinelle/drop_kmalloc_cast.cocci b/scripts/coccinelle/drop_kmalloc_cast.cocci
new file mode 100644
index 0000000..cb54a4b
--- /dev/null
+++ b/scripts/coccinelle/drop_kmalloc_cast.cocci
@@ -0,0 +1,68 @@
+///
+/// Casting (void *) value returned by kmalloc is useless
+/// as mentioned in Documentation/CodingStyle, Chap 14.
+///
+// Confidence: High
+// Copyright: 2009,2010 Nicolas Palix, DIKU.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options: -no_includes -include_headers
+//
+// Keywords: kmalloc, kzalloc, kcalloc
+// Version min: < 2.6.12 kmalloc
+// Version min: < 2.6.12 kcalloc
+// Version min:   2.6.14 kzalloc
+// Version max: *
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
+@depends on context@
+type T;
+@@
+
+* (T *)
+  \(kmalloc\|kzalloc\|kcalloc\)(...)
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+type T;
+@@
+
+- (T *)
+  \(kmalloc\|kzalloc\|kcalloc\)(...)
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+type T;
+position p;
+@@
+
+ (T@p *)\(kmalloc\|kzalloc\|kcalloc\)(...)
+
+@script:python depends on org@
+p << r.p;
+t << r.T;
+@@
+
+coccilib.org.print_safe_todo(p[0], t)
+
+@script:python depends on report@
+p << r.p;
+t << r.T;
+@@
+
+msg="WARNING: casting value returned by k[cmz]alloc to (%s *) is useless." % (t)
+coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

