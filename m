Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936652Ab2C3W4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:56:33 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934930Ab2C3VFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:53 -0400
Message-Id: <201203302105.q2UL55GH006291@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:40:50 -0400
Subject: [PATCH] arch/tile: don't enable irqs unconditionally in page fault handler
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:05.0757 (UTC) FILETIME=[C81A98D0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we took a page fault while we had interrupts disabled, we
shouldn't enable them in the page fault handler.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/fault.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index bcba159..5d10a74 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -343,9 +343,12 @@ static int handle_page_fault(struct pt_regs *regs,
 	/*
 	 * If we're trying to touch user-space addresses, we must
 	 * be either at PL0, or else with interrupts enabled in the
-	 * kernel, so either way we can re-enable interrupts here.
+	 * kernel, so either way we can re-enable interrupts here
+	 * unless we are doing atomic access to user space with
+	 * interrupts disabled.
 	 */
-	local_irq_enable();
+	if (!(regs->flags & PT_FLAGS_DISABLE_IRQ))
+		local_irq_enable();
 
 	mm = tsk->mm;
 
-- 
1.6.5.2

