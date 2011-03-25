Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1CYTjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:39:10 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19562 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1CYTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:39:04 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: tglx@linutronix.de, linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH v3 1/4] genirq: Reserve the irq when calling irq_set_chip()
Date: Fri, 25 Mar 2011 12:38:48 -0700
Message-Id: <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301081931-11240-1-git-send-email-ddaney@caviumnetworks.com>
References: <1301081931-11240-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 25 Mar 2011 19:39:04.0204 (UTC) FILETIME=[4C52DCC0:01CBEB24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper macros and functions like for_each_active_irq() don't work
unless the irq is in the allocated_irqs set.

In the case of !CONFIG_SPARSE_IRQ, instead of forcing all users of the
irq infrastructure to explicitly call irq_reserve_irq(), do it for
them.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 kernel/irq/chip.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c9c0601..54d9aab 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -37,6 +37,12 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	irq_chip_set_defaults(chip);
 	desc->irq_data.chip = chip;
 	irq_put_desc_unlock(desc, flags);
+	/*
+	 * For !CONFIG_SPARSE_IRQ make the irq show up in
+	 * allocated_irqs.  For the CONFIG_SPARSE_IRQ case, it may
+	 * already be there, and this call is harmless.
+	 */
+	irq_reserve_irq(irq);
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
-- 
1.7.2.3

