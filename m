Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab2JLIta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:49:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56136 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab2JLIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:49:27 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Subject: [PATCH] Coccicheck: Improvement for online checking with 'make C=[12]'
Date: Fri, 12 Oct 2012 10:48:50 +0200
Message-Id: <1350031730-20822-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces an old workaround by a new spatch option,
and adds support for online checking of external modules.

The ignore_unknown_options is present in coccinelle
since the version 0.2.3 of spatch. Most of the distribution
(if not all) already provide a RC of the 1.0.0 version.

This new option allows to preserve all gcc options, e.g. -I,
while checking code. Other gcc-specific options are
discarded by spatch.

The support for external modules is also added.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 scripts/coccicheck |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 823e972..b06b3cd 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -5,14 +5,14 @@ SPATCH="`which ${SPATCH:=spatch}`"
 if [ "$C" = "1" -o "$C" = "2" ]; then
     ONLINE=1
 
-# This requires Coccinelle >= 0.2.3
-#    FLAGS="-ignore_unknown_options -very_quiet"
-#    OPTIONS=$*
-
-# Workaround for Coccinelle < 0.2.3
-	FLAGS="-I $srctree/include -very_quiet"
-	shift $(( $# - 1 ))
-	OPTIONS=$1
+    # The ignore_unknown_options flag requires Coccinelle >= 0.2.3
+    FLAGS="-ignore_unknown_options -very_quiet"
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        OPTIONS="-dir $srctree $*"
+    else
+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include $*"
+    fi
+
 else
     ONLINE=0
     FLAGS="-very_quiet"
-- 
1.7.9.5

