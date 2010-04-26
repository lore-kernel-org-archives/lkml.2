Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0DZVMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:12:07 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51333 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab0DZVMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:12:01 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix <npalix@diku.dk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk
Subject: [PATCH 2/4] Add scripts/smpl/drop_kmalloc_cast.cocci
Date: Mon, 26 Apr 2010 23:11:17 +0200
Message-Id: <1272316279-12042-3-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272316279-12042-1-git-send-email-npalix@diku.dk>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this semantic patch is to remove
useless casts, as mentioned in the Linux documentation.
See Chapter 14 in Documentation/CodingStyle for more information.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 scripts/smpl/drop_kmalloc_cast.cocci |   74 ++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 scripts/smpl/drop_kmalloc_cast.cocci

diff --git a/scripts/smpl/drop_kmalloc_cast.cocci b/scripts/smpl/drop_kmalloc_cast.cocci
new file mode 100644
index 0000000..fbd3950
--- /dev/null
+++ b/scripts/smpl/drop_kmalloc_cast.cocci
@@ -0,0 +1,74 @@
+///
+/// Casting (void *) value returned by kmalloc is useless
+/// as mentioned in Documentation/CodingStyle, Chap 14.
+///
+/// The semantic patch that makes this change is available
+/// in THISFILE.
+///
+/// More information about semantic patching is available at
+/// http://coccinelle.lip6.fr/
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
1.6.3.3

