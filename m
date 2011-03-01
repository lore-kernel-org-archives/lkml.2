Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1B1X4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:56:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54045 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1B1X4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:56:53 -0500
From: Armando Uribe <x0095078@ti.com>
To: Armando Uribe <x0095078@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Hari Kanigeri <h-kanigeri2@ti.com>, Armando Uribe <x0095078@ti.com>
Subject: [PATCH] omap:mailbox: resolve hang issue
Date: Mon, 28 Feb 2011 18:14:23 -0600
Message-Id: <1298938463-15653-1-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hari Kanigeri <h-kanigeri2@ti.com>

omap4 interrupt disable bits is different. On rx kfifo full, the mbox rx
interrupts wasn't getting disabled, and this is causing the rcm stress tests
to hang.

Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 arch/arm/mach-omap2/mailbox.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 3d05ac8..2bfe8c6 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -207,7 +207,10 @@ static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 	l = mbox_read_reg(p->irqdisable);
-	l &= ~bit;
+	if (cpu_is_omap44xx())
+		l |= bit;
+	else
+		l &= ~bit;
 	mbox_write_reg(l, p->irqdisable);
 }
 
-- 
1.7.0.4

