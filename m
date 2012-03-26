Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2CZHLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:11:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:54869 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab2CZHLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:11:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123213977"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle when
 disabling CPU
Thread-Topic: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle
 when disabling CPU
Thread-Index: Ac0LH7GtoP8IYi8+RyWFvKr2En3Dwg==
Date: Mon, 26 Mar 2012 07:11:50 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle when disabling CPU

When preparing to unmask the irq in fixup_irqs(), using irqd_irq_masked()
as the condition to determine if do real unmasking action or not.

Because in some chips, the .irq_disable is NULL, so calling disable_irq()
does not mean the irq is masked immediately, and before enable_irq() if
the irq is coming, it can be pending state. Using irqd_irq_disabled() will
lose this chance.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..b9dd37f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -277,7 +277,7 @@ void fixup_irqs(void)
                        set_affinity = 0;
 
                if (!irqd_can_move_in_process_context(data) &&
-                   !irqd_irq_disabled(data) && chip->irq_unmask)
+                   !irqd_irq_masked(data) && chip->irq_unmask)
                        chip->irq_unmask(data);
 
                raw_spin_unlock(&desc->lock);
-- 
1.7.0.4
