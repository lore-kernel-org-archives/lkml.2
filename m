Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab2EYWFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:05:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934063Ab2EYWFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:05:02 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 11/20] tile: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:27 +0200
Message-Id: <1337983476-22081-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/tile/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index f572c19..911cb99 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/tracehook.h>
 #include <linux/signal.h>
+#include <linux/irqflags.h>
 #include <asm/stack.h>
 #include <asm/switch_to.h>
 #include <asm/homecache.h>
@@ -548,6 +549,8 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
  */
 int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 {
+	local_irq_enable();
+
 	/* If we enter in kernel mode, do nothing and exit the caller loop. */
 	if (!user_mode(regs))
 		return 0;
-- 
1.7.7.3

