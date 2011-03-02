Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab1CBV4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:56:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53214 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab1CBV4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:56:52 -0500
From: Armando Uribe <x0095078@ti.com>
To: <hiroshi.doyu@nokia.com>
Cc: <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Armando Uribe <x0095078@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2] omap:mailbox: resolve hang issue
Date: Wed,  2 Mar 2011 16:14:18 -0600
Message-Id: <1299104058-28565-1-git-send-email-x0095078@ti.com>
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
Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 arch/arm/mach-omap2/mailbox.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 394413d..011ca50 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -193,10 +193,12 @@ static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
 		omap_mbox_type_t irq)
 {
 	struct omap_mbox2_priv *p = mbox->priv;
-	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
-	l = mbox_read_reg(p->irqdisable);
-	l &= ~bit;
-	mbox_write_reg(l, p->irqdisable);
+	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+
+	if (!cpu_is_omap44xx())
+		bit = mbox_read_reg(p->irqdisable) & ~bit;
+
+	mbox_write_reg(bit, p->irqdisable);
 }
 
 static void omap2_mbox_ack_irq(struct omap_mbox *mbox,
-- 
1.7.0.4

