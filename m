Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab0FFPPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:15:49 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38538 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab0FFPPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:15:31 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Cc: Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 4/7] Add scripts/coccinelle/alloc/kzalloc-simple.cocci
Date: Sun,  6 Jun 2010 17:15:04 +0200
Message-Id: <1275837307-4283-5-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275837307-4283-1-git-send-email-npalix@diku.dk>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch replaces a pair of calls to kmalloc and memset
by a single call to kzalloc.

It only looks for simple cases to avoid false positives.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/alloc/kzalloc-simple.cocci |   82 +++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/alloc/kzalloc-simple.cocci

diff --git a/scripts/coccinelle/alloc/kzalloc-simple.cocci b/scripts/coccinelle/alloc/kzalloc-simple.cocci
new file mode 100644
index 0000000..2eae828
--- /dev/null
+++ b/scripts/coccinelle/alloc/kzalloc-simple.cocci
@@ -0,0 +1,82 @@
+///
+/// kzalloc should be used rather than kmalloc followed by memset 0
+///
+// Confidence: High
+// Copyright: (C) 2009-2010 Julia Lawall, Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2009-2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/rules/kzalloc.html
+// Options: -no_includes -include_headers
+//
+// Keywords: kmalloc, kzalloc
+// Version min: < 2.6.12 kmalloc
+// Version min:   2.6.14 kzalloc
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
+coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

