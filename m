Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2AKJHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:07:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:17896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab2AKJHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:07:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94650991"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH] gpio: gpio-langwell: fix IRQ wake functionality
Date: Wed, 11 Jan 2012 11:08:08 +0200
Message-Id: <1326272888-15123-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips are able to use gpio as a wake up source - e.g., you may want your
gpio button to wake up your device.

Currently 'irq_set_irq_wake()' is broken for gpio-langwell because the driver
does not provide the '->irq_set_wake()' method, which makes 'set_irq_wake_real()'
return -ENXIO, so that the 'IRQD_WAKEUP_STATE' bit is not changed. This also
causes the "Unbalanced IRQ X wake disable" warnings at some point.

This patch fixes the issue with the 'IRQCHIP_SKIP_SET_WAKE' flag. This flag
basically tells the the IRQ core subsystem that we support IRQ wakes but do
not need any driver-specific code.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 00692e8..4bb748e 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -227,6 +227,7 @@ static struct irq_chip lnw_irqchip = {
 	.irq_mask	= lnw_irq_mask,
 	.irq_unmask	= lnw_irq_unmask,
 	.irq_set_type	= lnw_irq_type,
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
-- 
1.7.4.1

