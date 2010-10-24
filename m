Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab0JXViN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:38:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53329 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab0JXViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m721wMEb2Vkk2LIDMgIl4mPF2jxi4N0QSon7U8DI46BDIINJ/zd8w6mUqrseQ0/Jqx
         +vgpZpybHjYPWcbGP8JTiFJ+FSoi+HFUZMKhh7thF2eSZD/UfHRvhan6WYUA49lQnnG8
         HGIZLR/u9giXTZt14O+ZYhHfoSYlLoIDOVh8Q=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Cc: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/4] Coccinelle: Find doubled arguments to boolean or bit operators.
Date: Sun, 24 Oct 2010 23:37:32 +0200
Message-Id: <1287956254-15563-2-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
---
 scripts/coccinelle/tests/doublebitand.cocci |   54 +++++++++++++++++++++++++++
 scripts/coccinelle/tests/doubletest.cocci   |   40 ++++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/tests/doublebitand.cocci
 create mode 100644 scripts/coccinelle/tests/doubletest.cocci

diff --git a/scripts/coccinelle/tests/doublebitand.cocci b/scripts/coccinelle/tests/doublebitand.cocci
new file mode 100644
index 0000000..9ba73d0
--- /dev/null
+++ b/scripts/coccinelle/tests/doublebitand.cocci
@@ -0,0 +1,54 @@
+/// Find bit operations that include the same argument more than once
+//# One source of false positives is when the argument performs a side
+//# effect.  Another source of false positives is when a neutral value
+//# such as 0 for | is used to indicate no information, to maintain the
+//# same structure as other similar expressions
+///
+// Confidence: Moderate
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual context
+virtual org
+virtual report
+
+@r expression@
+expression E;
+position p;
+@@
+
+(
+*        E@p
+         & ... & E
+|
+*        E@p
+         | ... | E
+|
+*        E@p
+         & ... & !E
+|
+*        E@p
+         | ... | !E
+|
+*        !E@p
+         & ... & E
+|
+*        !E@p
+         | ... | E
+)
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("duplicated argument to & or |",p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+coccilib.report.print_report(p[0],"duplicated argument to & or |")
diff --git a/scripts/coccinelle/tests/doubletest.cocci b/scripts/coccinelle/tests/doubletest.cocci
new file mode 100644
index 0000000..13a2c0e
--- /dev/null
+++ b/scripts/coccinelle/tests/doubletest.cocci
@@ -0,0 +1,40 @@
+/// Find &&/|| operations that include the same argument more than once
+//# A common source of false positives is when the argument performs a side
+//# effect.
+///
+// Confidence: Moderate
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual context
+virtual org
+virtual report
+
+@r expression@
+expression E;
+position p;
+@@
+
+(
+* E@p
+  || ... || E
+|
+* E@p
+  && ... && E
+)
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("duplicated argument to && or ||",p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+coccilib.report.print_report(p[0],"duplicated argument to && or ||")
-- 
1.7.0.4

