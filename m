Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2F1Xno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:43:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25276 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2F1Xnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:43:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6756"; a="205785542"
From: Vikram Mulukutla <markivx@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] panic: Fix a possible deadlock in panic()
Date: Thu, 28 Jun 2012 16:43:05 -0700
Message-Id: <1340926985-8270-1-git-send-email-markivx@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

panic_lock is meant to ensure that panic processing takes
place only on one cpu; if any of the other cpus encounter
a panic, they will spin waiting to be shut down.

However, this causes a regression in this scenario:

1. Cpu 0 encounters a panic and acquires the panic_lock
   and proceeds with the panic processing.
2. There is an interrupt on cpu 0 that also encounters
   an error condition and invokes panic.
3. This second invocation fails to acquire the panic_lock
   and enters the infinite while loop in panic_smp_self_stop.

Thus all panic processing is stopped, and the cpu is stuck
for eternity in the while(1) inside panic_smp_self_stop.

To address this, disable local interrupts with
local_irq_disable before acquiring the panic_lock. This will
prevent interrupt handlers from executing during the panic
processing, thus avoiding this particular problem.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/panic.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d2a5f4e..e1b2822 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -75,6 +75,14 @@ void panic(const char *fmt, ...)
 	int state = 0;
 
 	/*
+	 * Disable local interrupts. This will prevent panic_smp_self_stop
+	 * from deadlocking the first cpu that invokes the panic, since
+	 * there is nothing to prevent an interrupt handler (that runs
+	 * after the panic_lock is acquired) from invoking panic again.
+	 */
+	local_irq_disable();
+
+	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
-- 
1.7.8.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

