Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1ANIWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:22:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:18773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1ANIWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:22:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="592927205"
Date: Fri, 14 Jan 2011 15:55:19 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, apbt: Set affinity properly for apb timers in all
	cases
Message-ID: <20110114075519.GA20428@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e4d2ebca only sets timer affinity when system boots. We also
need to set affinity properly in other cases like when onlining CPU
because apb timer acts as per-cpu tick device. Otherwise, we are
observing system hang on onling CPU which is offlined previously.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 arch/x86/kernel/apb_timer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7c9ab59..449b111 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -313,9 +313,10 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 	if (adev->irq == 0)
 		return;
 
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+
 	if (system_state == SYSTEM_BOOTING) {
 		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 		/* APB timer irqs are set up as mp_irqs, timer is edge type */
 		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
-- 
1.5.5.1

