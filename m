Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2JKIFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:05:25 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:47779 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab2JKIFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:05:15 -0400
From: Qing Zhu <qzhu@marvell.com>
To: akpm@linux-foundation.org, mingo@kernel.org, ben@decadent.org.uk,
        markivx@codeaurora.org, ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, cxie4@marvell.com, binw@marvell.com,
        wwang27@marvell.com, njun@marvell.com, Qing Zhu <qzhu@marvell.com>
Subject: [PATCH] panic: fix incomplete panic log in panic()
Date: Thu, 11 Oct 2012 16:03:07 +0800
Message-Id: <1349942587-16134-1-git-send-email-qzhu@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 11 Oct 2012 08:03:22.0715 (UTC) FILETIME=[E2439AB0:01CDA786]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panic log should be printed on the console, but if someone lock the
console when panic, console won't print out panic log.

The incomplete panic log issue will happen in below scenarios:
1. One task call console_lock(), then panic happend before it call
console_unlock(). No panic log can be printed.
2. Cpu 0 call panic()->Cpu 1 call console_lock()->Cpu 0 call
smp_send_stop()
Cpu 1 will be stopped and can't unlock console,only top part of panic log
will be printed.

So unlock console anyway in panic() to keep panic log printed.

Signed-off-by: Qing Zhu <qzhu@marvell.com>
---
 kernel/panic.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..3924d25 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/console.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -127,6 +128,13 @@ void panic(const char *fmt, ...)
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	/*
+	 * Unlock the console anyway here, in case it's occupied by another
+	 * one which has no chance to unlock the console thus prevents the
+	 * panic log prints on the console.
+	 */
+	console_unlock();
+
 	bust_spinlocks(0);
 
 	if (!panic_blink)
-- 
1.7.4.1

