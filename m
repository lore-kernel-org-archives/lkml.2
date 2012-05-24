Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278Ab2EXVYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:24:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927Ab2EXVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:24:18 -0400
Date: Thu, 24 May 2012 14:23:23 -0700
From: tip-bot for Jiang Liu <liuj97@gmail.com>
Message-ID: <tip-f841d792e38f75f5e25b0b66f7b5d235d180a735@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, cpw@sgi.com, nagananda.chumbalkar@hp.com,
        chenkeping@huawei.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        liuj97@gmail.com, jiang.liu@huawei.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, nagananda.chumbalkar@hp.com, cpw@sgi.com,
        chenkeping@huawei.com, suresh.b.siddha@intel.com, jiang.liu@huawei.com,
        liuj97@gmail.com, tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1333120296-13563-4-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-4-git-send-email-jiang.liu@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86:
  Return IRQ_SET_MASK_OK_NOCOPY from irq affinity functions
Git-Commit-ID: f841d792e38f75f5e25b0b66f7b5d235d180a735
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 14:23:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f841d792e38f75f5e25b0b66f7b5d235d180a735
Gitweb:     http://git.kernel.org/tip/f841d792e38f75f5e25b0b66f7b5d235d180a735
Author:     Jiang Liu <liuj97@gmail.com>
AuthorDate: Fri, 30 Mar 2012 23:11:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 May 2012 23:16:33 +0200

x86: Return IRQ_SET_MASK_OK_NOCOPY from irq affinity functions

The interrupt chip irq_set_affinity() functions copy the affinity mask
to irq_data->affinity but return 0, i.e. IRQ_SET_MASK_OK.
IRQ_SET_MASK_OK causes the core code to do another redundant copy.

Return IRQ_SET_MASK_OK_NOCOPY to avoid this.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Keping Chen <chenkeping@huawei.com>
Link: http://lkml.kernel.org/r/1333120296-13563-4-git-send-email-jiang.liu@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    9 +++++----
 arch/x86/platform/uv/uv_irq.c  |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ac96561..bce2001 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2270,6 +2270,7 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, data->chip_data);
+		ret = IRQ_SET_MASK_OK_NOCOPY;
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return ret;
@@ -3092,7 +3093,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	__write_msi_msg(data->msi_desc, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 #endif /* CONFIG_SMP */
 
@@ -3214,7 +3215,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	dmar_msi_write(irq, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif /* CONFIG_SMP */
@@ -3267,7 +3268,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	hpet_msi_write(data->handler_data, &msg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif /* CONFIG_SMP */
@@ -3340,7 +3341,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 		return -1;
 
 	target_ht_irq(data->irq, dest, cfg->vector);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #endif
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index f25c276..a22c416 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -222,7 +222,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 /*
