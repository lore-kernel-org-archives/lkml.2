Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1ABHYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:36615 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1ABHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 180/260] x86, irq: Plug memory leak in sparse irq
Date: Sun,  2 Jan 2011 02:17:56 -0500
Message-Id: <1293952756-15010-181-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:27.0885 (UTC) FILETIME=[F3278BD0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 1cf180c94e9166cda083ff65333883ab3648e852 upstream.

free_irq_cfg() is not freeing the cpumask_vars in irq_cfg. Fixing this
triggers a use after free caused by the fact that copying struct
irq_cfg is done with memcpy, which copies the pointer not the cpumask.

Fix both places.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index abb136a..469d45a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -303,14 +303,19 @@ void arch_init_copy_chip_data(struct irq_desc *old_desc,
 
 	old_cfg = old_desc->chip_data;
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	cfg->vector = old_cfg->vector;
+	cfg->move_in_progress = old_cfg->move_in_progress;
+	cpumask_copy(cfg->domain, old_cfg->domain);
+	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
 
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
-static void free_irq_cfg(struct irq_cfg *old_cfg)
+static void free_irq_cfg(struct irq_cfg *cfg)
 {
-	kfree(old_cfg);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
 }
 
 void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
-- 
1.7.3.3

