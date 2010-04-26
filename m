Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0DZVMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:12:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50076 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0DZVMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:12:02 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix <npalix@diku.dk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk
Subject: [PATCH 3/4] Add scripts/smpl/kzalloc-simple.cocci
Date: Mon, 26 Apr 2010 23:11:18 +0200
Message-Id: <1272316279-12042-4-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272316279-12042-1-git-send-email-npalix@diku.dk>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch replaces a pair of calls to kmalloc and memset
by a single call to kzalloc.

It only looks for simple cases to improve the confidence.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 scripts/smpl/kzalloc-simple.cocci |   88 +++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 scripts/smpl/kzalloc-simple.cocci

diff --git a/scripts/smpl/kzalloc-simple.cocci b/scripts/smpl/kzalloc-simple.cocci
new file mode 100644
index 0000000..d4e1b25
--- /dev/null
+++ b/scripts/smpl/kzalloc-simple.cocci
@@ -0,0 +1,88 @@
+///
+/// kzalloc should be used rather than kmalloc followed by memset 0
+///
+/// The semantic patch that makes this change is available
+/// in THISFILE.
+///
+/// More information about semantic patching is available at
+/// http://coccinelle.lip6.fr/
+///
+// Confidence: High
+// Copyright: (C) 2009-2010 Gilles Muller, Julia Lawall, Nicolas Palix, EMN, DIKU.  GPLv2.
+// URL: http://coccinelle.lip6.fr/rules/kzalloc.html
+// Options: -no_includes -include_headers
+//
+// Keywords: kmalloc, kzalloc
+// Version min: < 12 kmalloc
+// Version min:   14 kzalloc
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
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+@@
+
+* x = (T)kmalloc(E1,E2);
+  if ((x==NULL) || ...) S
+* memset((T2)x,0,E1);
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+@@
+
+- x = (T)kmalloc(E1,E2);
++ x = kzalloc(E1,E2);
+  if ((x==NULL) || ...) S
+- memset((T2)x,0,E1);
+
+//----------------------------------------------------------
+//  For org mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+type T, T2;
+expression x;
+expression E1,E2;
+statement S;
+position p;
+@@
+
+ x = (T)kmalloc@p(E1,E2);
+ if ((x==NULL) || ...) S
+ memset((T2)x,0,E1);
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="%s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: kzalloc should be used for %s, instead of kmalloc/memset" % (x)
+coccilib.report.print_report(p[0], msg_safe)
-- 
1.6.3.3

