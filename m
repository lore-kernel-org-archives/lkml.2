Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab0FFPPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:15:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51378 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab0FFPPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:15:33 -0400
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
Subject: [PATCH 6/7] Add scripts/coccinelle/err_cast.cocci
Date: Sun,  6 Jun 2010 17:15:06 +0200
Message-Id: <1275837307-4283-7-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275837307-4283-1-git-send-email-npalix@diku.dk>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Coccinelle file to use the ERR_CAST function

Before the release 2.6.25, one had to use ERR_PTR(PTR_ERR(...))  to
convert the pointer type of an error. Since then, the function
ERR_CAST has been available for that purpose.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/err_cast.cocci |   56 +++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/err_cast.cocci

diff --git a/scripts/coccinelle/err_cast.cocci b/scripts/coccinelle/err_cast.cocci
new file mode 100644
index 0000000..2ce1150
--- /dev/null
+++ b/scripts/coccinelle/err_cast.cocci
@@ -0,0 +1,56 @@
+///
+/// Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
+///
+// Confidence: High
+// Copyright: (C) 2009, 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2009, 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2009, 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options:
+//
+// Keywords: ERR_PTR, PTR_ERR, ERR_CAST
+// Version min: 2.6.25
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+
+@ depends on context && !patch && !org && !report@
+expression x;
+@@
+
+* ERR_PTR(PTR_ERR(x))
+
+@ depends on !context && patch && !org && !report @
+expression x;
+@@
+
+- ERR_PTR(PTR_ERR(x))
++ ERR_CAST(x)
+
+@r depends on !context && !patch && (org || report)@
+expression x;
+position p;
+@@
+
+ ERR_PTR@p(PTR_ERR(x))
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING ERR_CAST can be used with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="WARNING: ERR_CAST can be used with %s" % (x)
+coccilib.report.print_report(p[0], msg)
-- 
1.7.0.4

