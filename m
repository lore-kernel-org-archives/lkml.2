Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543Ab2EQKLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:11:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761498Ab2EQKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:00 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 2/8] MIPS: BMIPS: delay irq enable to ->smp_finish()
Date: Thu, 17 May 2012 18:10:04 +0800
Message-Id: <1337249410-7162-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/smp-bmips.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index 3046e29..298b437 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -197,13 +197,6 @@ static void bmips_init_secondary(void)
 
 	write_c0_brcm_action(ACTION_CLR_IPI(smp_processor_id(), 0));
 #endif
-
-	/* make sure there won't be a timer interrupt for a little while */
-	write_c0_compare(read_c0_count() + mips_hpt_frequency / HZ);
-
-	irq_enable_hazard();
-	set_c0_status(IE_SW0 | IE_SW1 | IE_IRQ1 | IE_IRQ5 | ST0_IE);
-	irq_enable_hazard();
 }
 
 /*
@@ -212,6 +205,13 @@ static void bmips_init_secondary(void)
 static void bmips_smp_finish(void)
 {
 	pr_info("SMP: CPU%d is running\n", smp_processor_id());
+
+	/* make sure there won't be a timer interrupt for a little while */
+	write_c0_compare(read_c0_count() + mips_hpt_frequency / HZ);
+
+	irq_enable_hazard();
+	set_c0_status(IE_SW0 | IE_SW1 | IE_IRQ1 | IE_IRQ5 | ST0_IE);
+	irq_enable_hazard();
 }
 
 /*
-- 
1.7.1

