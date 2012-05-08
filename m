Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2EHKCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:02:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2EHKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:02:47 -0400
Date: Tue, 8 May 2012 03:02:32 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-82b481e80d8a17720b5805393684a95184cfb6bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com>
References: <1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] irq_remap: Fix UP build failure
Git-Commit-ID: 82b481e80d8a17720b5805393684a95184cfb6bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 03:02:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82b481e80d8a17720b5805393684a95184cfb6bb
Gitweb:     http://git.kernel.org/tip/82b481e80d8a17720b5805393684a95184cfb6bb
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 8 May 2012 00:08:53 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 11:17:30 +0200

irq_remap: Fix UP build failure

Fix the below UP build failure with CONFIG_IRQ_REMAP enabled.

 drivers/iommu/intel_irq_remapping.c:955:19: error: ‘struct irq_data’ has no member named ‘affinity’

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c |    4 ++++
 drivers/iommu/irq_remapping.c       |    2 ++
 drivers/iommu/irq_remapping.h       |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index b4d3950..1c0255e 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -902,6 +902,7 @@ static int intel_setup_ioapic_entry(int irq,
 	return 0;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Migrate the IO-APIC irq in the presence of intr-remapping.
  *
@@ -955,6 +956,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	cpumask_copy(data->affinity, mask);
 	return 0;
 }
+#endif
 
 static void intel_compose_msi_msg(struct pci_dev *pdev,
 				  unsigned int irq, unsigned int dest,
@@ -1056,7 +1058,9 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
+#ifdef CONFIG_SMP
 	.set_affinity		= intel_ioapic_set_affinity,
+#endif
 	.free_irq		= free_irte,
 	.compose_msi_msg	= intel_compose_msi_msg,
 	.msi_alloc_irq		= intel_msi_alloc_irq,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 1cf350e..40cda8e 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -111,6 +111,7 @@ int setup_ioapic_remapped_entry(int irq,
 					     vector, attr);
 }
 
+#ifdef CONFIG_SMP
 int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 			      bool force)
 {
@@ -119,6 +120,7 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	return remap_ops->set_affinity(data, mask, force);
 }
+#endif
 
 void free_remapped_irq(int irq)
 {
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index b12974c..be9d729 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -59,9 +59,11 @@ struct irq_remap_ops {
 				  unsigned int, int,
 				  struct io_apic_irq_attr *);
 
+#ifdef CONFIG_SMP
 	/* Set the CPU affinity of a remapped interrupt */
 	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
+#endif
 
 	/* Free an IRQ */
 	int (*free_irq)(int);
