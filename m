Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0JHT3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:29:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567Ab0JHT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MUcg988Jj/7btbggYL+yVfqW05QlJoxeBDqhEe9sHhbm2IIJ2+QoOwXp34Ah9qC3oJ
         fx8rYL35K6fMrslz5AlHEBNCqTxKph+Yrn1KcyB5ra2O7wnEsSwqXVRMNFiS1K8syZ1s
         30DIdSajrwSBFeCwYn7iuJ45si2UnQQIFcyWA=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 5/6] Coccinelle: Add a new mode named 'chain'
Date: Fri,  8 Oct 2010 21:27:40 +0200
Message-Id: <1286566061-17122-6-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spatch now returns -1 when a virtual rule (given with
-D on the command line) is not defined in the semantic patch.

Using this spatch feature, coccicheck is now
tries several modes by default, in the order:
	patch, report, context, org

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index ef78c87..c7beb63 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -16,6 +16,7 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 else
     ONLINE=0
     FLAGS="-very_quiet"
+    OPTIONS="-dir $srctree"
 fi
 
 if [ ! -x "$SPATCH" ]; then
@@ -25,11 +26,11 @@ fi
 
 if [ "$MODE" = "" ] ; then
     if [ "$ONLINE" = "0" ] ; then
-	echo 'You have not explicitly specified the mode to use. Fallback to "report".'
+	echo 'You have not explicitly specified the mode to use. Using default "chain" mode.'
+	echo 'All available modes will be tried (in that order): patch, report, context, org'
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
-	echo 'Available modes are: report, patch, context, org'
     fi
-    MODE="report"
+    MODE="chain"
 fi
 
 if [ "$ONLINE" = "0" ] ; then
@@ -71,10 +72,15 @@ coccinelle () {
 	    sed -ne 's|^//#||p' $COCCI
 	    echo ''
 	fi
+    fi
 
-	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
+    if [ "$MODE" = "chain" ] ; then
+	$SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     else
-	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
 
 }
-- 
1.7.0.4

