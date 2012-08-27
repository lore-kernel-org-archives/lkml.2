Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2H0IYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:24:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51612 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2H0IYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:24:52 -0400
From: Gong Tao <gongtao0607@gmail.com>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Gong Tao <gongtao0607@gmail.com>
Subject: [PATCH] OpenRISC: Fix level-triggered irq handler
Date: Mon, 27 Aug 2012 16:24:38 +0800
Message-Id: <1346055878-13037-1-git-send-email-gongtao0607@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or1k_pic_mask_ack() did not mask the irq.

Signed-off-by: Gong Tao <gongtao0607@gmail.com>
---
 arch/openrisc/kernel/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index a65aede..f09b5cf 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -7,6 +7,7 @@
  *
  * Modifications for the OpenRISC architecture:
  * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *               2012 Gong Tao <gongtao0607@gmail.com>
  *
  *      This program is free software; you can redistribute it and/or
  *      modify it under the terms of the GNU General Public License
@@ -91,9 +92,12 @@ static void or1k_pic_mask_ack(struct irq_data *data)
 	/* Comments for pic_ack apply here, too */
 
 #ifdef CONFIG_OR1K_1200
+	/* MUST mask first */
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
 	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
 #else
 	WARN(1, "Interrupt handling possibily broken\n");
+	mtspr(SPR_PICMR, (1UL << data->hwirq));
 	mtspr(SPR_PICSR, (1UL << data->hwirq));
 #endif
 }
-- 
1.7.12

