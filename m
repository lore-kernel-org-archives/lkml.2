Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0HXPkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47816 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0HXPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:54 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 08/18] Coccinelle: Add iterators/itnull.cocci
Date: Tue, 24 Aug 2010 17:39:02 +0200
Message-Id: <1282664352-15882-9-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many iterators have the property that the first argument is always bound
to a real list element, never NULL.  False positives arise for some
iterators that do not have this property, or in cases when the loop
cursor is reassigned.  The latter should only happen when the matched
code is on the way to a loop exit (break, goto, or return).

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/iterators/itnull.cocci |   58 +++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/iterators/itnull.cocci

diff --git a/scripts/coccinelle/iterators/itnull.cocci b/scripts/coccinelle/iterators/itnull.cocci
new file mode 100644
index 0000000..baa4297
--- /dev/null
+++ b/scripts/coccinelle/iterators/itnull.cocci
@@ -0,0 +1,58 @@
+/// Many iterators have the property that the first argument is always bound
+/// to a real list element, never NULL.  False positives arise for some
+/// iterators that do not have this property, or in cases when the loop
+/// cursor is reassigned.  The latter should only happen when the matched
+/// code is on the way to a loop exit (break, goto, or return).
+///
+// Confidence: Moderate
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
+iterator I;
+expression x,E,E1,E2;
+statement S,S1,S2;
+@@
+
+I(x,...) { <...
+(
+- if (x == NULL && ...) S
+|
+- if (x != NULL || ...)
+  S
+|
+- (x == NULL) ||
+  E
+|
+- (x != NULL) &&
+  E
+|
+- (x == NULL && ...) ? E1 :
+  E2
+|
+- (x != NULL || ...) ?
+  E1
+- : E2
+|
+- if (x == NULL && ...) S1 else
+  S2
+|
+- if (x != NULL || ...)
+  S1
+- else S2
+|
++ BAD(
+  x == NULL
++ )
+|
++ BAD(
+  x != NULL
++ )
+)
+  ...> }
\ No newline at end of file
-- 
1.7.0.4

