Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1FBRzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:55:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56977 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752660Ab1FBRzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:55:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Date: Thu,  2 Jun 2011 18:55:13 +0100
Message-Id: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When irq_alloc_descs() is called with no base IRQ specified then it will
search for a range of IRQs starting from a specified base address. In the
case where an IRQ is specified it still does this search in order to ensure
that none of the requested range is already allocated and it still uses the
from parameter to specify the base for the search. This means that in the
case where a base is specified but from is zero (which is reasonable as
any IRQ number is in the range specified by a zero from) the function will
get confused and try to allocate the first suitably sized block of free IRQs
it finds.

Instead use a specified IRQ as the base address for the search, and insist
that any from that is specified can support that IRQ.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdesc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 886e803..bb53d6c 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -346,6 +346,12 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 	if (!cnt)
 		return -EINVAL;
 
+	if (irq >= 0) {
+		if (from > irq)
+			return -EINVAL;
+		from = irq;
+	}
+
 	mutex_lock(&sparse_irq_lock);
 
 	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
-- 
1.7.5.3

