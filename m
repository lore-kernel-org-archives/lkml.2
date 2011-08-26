Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1HZPQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:16:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:41772 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1HZPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:16:51 -0400
From: Liming Wang <liming.wang@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mips/rt: convert cascade interrupt non threaded
Date: Fri, 26 Aug 2011 23:00:04 +0800
Message-ID: <1314370804-21266-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preempt_rt kernel forces all irq interrupts to be threaded,
but special interrupts can be excluded from this conversion.
The cascade interrupt should be part of these exceptions.

In this case, irq2 is initialized before "kthreadd" task, which
converts irq interrupt to threaded.

If this irq is threaded, the kernel calls "try_to_wake_up" function
to wake up "kthreadd" task, but at that moment, "kthreadd" task
has not been initialized and try_to_wake_up wakes up a NULL task.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Bruce Ashfield <bruce.ashfield@windriver.com>
---
 arch/mips/kernel/i8259.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 5c74eb7..fb338db 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -295,6 +295,7 @@ static void init_8259A(int auto_eoi)
 static struct irqaction irq2 = {
 	.handler = no_action,
 	.name = "cascade",
+	.flags = IRQF_NO_THREAD,
 };
 
 static struct resource pic1_io_resource = {
-- 
1.7.0.4

