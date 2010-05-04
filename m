Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0EDQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:02:56 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:47099 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0EDQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C9TOX4VE1nMn+J0DoY+F+38UVZuCq6PX9vQbl51iqW+HjKq0QvCd2J8jBaeVJMTKhL
         Ctr1EbyBs3gUd+/30qd4UVwRVd/nEipHJ6skQ1hKGWxuy5Tqmtx8zohoyRco+FuM5jUr
         yvFQQc3Kf5Wby2zQn/cDQQoai7AJZdwzsK4VM=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] lockdep: allow user to disable CONFIG_TRACE_IRQFLAGS
Date: Wed,  5 May 2010 00:02:24 +0800
Message-Id: <1272988944-2448-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

There is still the lost irq-on tracing issue on ARM,
(see http://marc.info/?l=linux-arm-kernel&m=126047420005553&w=2)
which may disable lockdep after kernel boot, seems no
good solution for the issue up to now.

The patch exports the config option of CONFIG_TRACE_IRQFLAGS
and allows user to disable it for support of checking circular
dead lock only if irq flags tracing can't work correctly always.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 lib/Kconfig.debug      |    3 +++
 lib/locking-selftest.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..448f18f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -550,11 +550,14 @@ config DEBUG_LOCKDEP
 	  of more runtime overhead.
 
 config TRACE_IRQFLAGS
+	bool "Lock prove: IRQ flags tracing"
 	depends on DEBUG_KERNEL
 	bool
 	default y
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on PROVE_LOCKING
+	help
+	  If you say Y here, IRQ flags will be traced to prove locking. 
 
 config DEBUG_SPINLOCK_SLEEP
 	bool "Spinlock debugging: sleep-inside-spinlock checking"
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 619313e..d9e5bfe 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1176,6 +1176,7 @@ void locking_selftest(void)
 
 	printk("  --------------------------------------------------------------------------\n");
 
+#ifdef CONFIG_TRACE_IRQFLAGS
 	/*
 	 * irq-context testcases:
 	 */
@@ -1188,6 +1189,7 @@ void locking_selftest(void)
 
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
+#endif
 
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
-- 
1.6.2.5

