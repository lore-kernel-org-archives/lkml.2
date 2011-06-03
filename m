Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1FCM6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:58:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:60554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1FCM6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:58:53 -0400
Date: Fri, 3 Jun 2011 12:58:42 GMT
From: tip-bot for Linus Walleij <linus.walleij@stericsson.com>
Message-ID: <tip-e7fbad300a7a6432238f086e3c9a61538a905858@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linus.walleij@stericsson.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, tglx@linutronix.de
In-Reply-To: <1306858479-16622-1-git-send-email-linus.walleij@stericsson.com>
References: <1306858479-16622-1-git-send-email-linus.walleij@stericsson.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix descriptor init on non-sparse IRQs
Git-Commit-ID: e7fbad300a7a6432238f086e3c9a61538a905858
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 12:58:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7fbad300a7a6432238f086e3c9a61538a905858
Gitweb:     http://git.kernel.org/tip/e7fbad300a7a6432238f086e3c9a61538a905858
Author:     Linus Walleij <linus.walleij@stericsson.com>
AuthorDate: Tue, 31 May 2011 18:14:39 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 3 Jun 2011 14:53:16 +0200

genirq: Fix descriptor init on non-sparse IRQs

The genirq changes are initializing descriptors for sparse IRQs quite
differently from how non-sparse (stacked?) IRQs are initialized, with
the effect that on my platform all IRQs are default-disabled on sparse
IRQs and default-enabled if non-sparse IRQs are used, crashing some
GPIO driver.

Fix this by refactoring the non-sparse IRQs to use the same descriptor
init function as the sparse IRQs.

Signed-off: Linus Walleij <linus.walleij@linaro.org>
Link: http://lkml.kernel.org/r/1306858479-16622-1-git-send-email-linus.walleij@stericsson.com
Cc: stable@kernel.org # 2.6.39
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 886e803..c7ddc87 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -257,13 +257,11 @@ int __init early_irq_init(void)
 	count = ARRAY_SIZE(irq_desc);
 
 	for (i = 0; i < count; i++) {
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = &no_irq_chip;
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
-		irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
-		alloc_masks(desc + i, GFP_KERNEL, node);
-		desc_smp_init(desc + i, node);
+		alloc_masks(&desc[i], GFP_KERNEL, node);
+		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		desc_set_defaults(i, &desc[i], node);
 	}
 	return arch_early_irq_init();
 }
