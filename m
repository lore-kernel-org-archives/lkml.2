Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2G3MBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:01:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38974 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3MBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:01:41 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 01/11] kernel/debug: Make use of KGDB_REASON_NMI
Date: Mon, 30 Jul 2012 04:58:10 -0700
Message-Id: <1343649500-18491-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120730115719.GA5742@lizard>
References: <20120730115719.GA5742@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernel never set KGDB_REASON_NMI. We do now, when we enter
KGDB/KDB from an NMI.

This is not to be confused with kgdb_nmicallback(), NMI callback is
an entry for the slave CPUs during CPUs roundup, but REASON_NMI is the
entry for the master CPU.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/debug/kdb/kdb_debugger.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index 8b68ce7..be7b33b 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -12,6 +12,7 @@
 #include <linux/kdb.h>
 #include <linux/kdebug.h>
 #include <linux/export.h>
+#include <linux/hardirq.h>
 #include "kdb_private.h"
 #include "../debug_core.h"
 
@@ -52,6 +53,9 @@ int kdb_stub(struct kgdb_state *ks)
 	if (atomic_read(&kgdb_setting_breakpoint))
 		reason = KDB_REASON_KEYBOARD;
 
+	if (in_nmi())
+		reason = KDB_REASON_NMI;
+
 	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
 		if ((bp->bp_enabled) && (bp->bp_addr == addr)) {
 			reason = KDB_REASON_BREAK;
-- 
1.7.10.4

