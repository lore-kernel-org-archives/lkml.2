Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966384Ab2C3VdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:33:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966365Ab2C3VdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:33:06 -0400
Date: Fri, 30 Mar 2012 14:31:34 -0700
From: tip-bot for Jiang Liu <liuj97@gmail.com>
Message-ID: <tip-f5cb92ac82d06cb583c1f66666314c5c0a4d7913@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        chenkeping@huawei.com, jiang.liu@huawei.com, liuj97@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, liuj97@gmail.com, jiang.liu@huawei.com,
        chenkeping@huawei.com
In-Reply-To: <1333120296-13563-2-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-2-git-send-email-jiang.liu@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return value
Git-Commit-ID: f5cb92ac82d06cb583c1f66666314c5c0a4d7913
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 14:31:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5cb92ac82d06cb583c1f66666314c5c0a4d7913
Gitweb:     http://git.kernel.org/tip/f5cb92ac82d06cb583c1f66666314c5c0a4d7913
Author:     Jiang Liu <liuj97@gmail.com>
AuthorDate: Fri, 30 Mar 2012 23:11:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 30 Mar 2012 23:13:46 +0200

genirq: Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return value

irq_move_masked_irq() checks the return code of
chip->irq_set_affinity() only for 0, but IRQ_SET_MASK_OK_NOCOPY is
also a valid return code, which is there to avoid a redundant copy of
the cpumask. But in case of IRQ_SET_MASK_OK_NOCOPY we not only avoid
the redundant copy, we also fail to adjust the thread affinity of an
eventually threaded interrupt handler.

Handle IRQ_SET_MASK_OK (==0) and IRQ_SET_MASK_OK_NOCOPY(==1) return
values correctly by checking the valid return values seperately.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Keping Chen <chenkeping@huawei.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1333120296-13563-2-git-send-email-jiang.liu@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/migration.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 4742090..c3c8975 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,12 +43,16 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids))
-		if (!chip->irq_set_affinity(&desc->irq_data,
-					    desc->pending_mask, false)) {
+		   < nr_cpu_ids)) {
+		int ret = chip->irq_set_affinity(&desc->irq_data,
+						 desc->pending_mask, false);
+		switch (ret) {
+		case IRQ_SET_MASK_OK:
 			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
+		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
 		}
+	}
 
 	cpumask_clear(desc->pending_mask);
 }
