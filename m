Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1ABHZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:37020 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1ABHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Weidong Han <weidong.han@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 231/260] x86, intr-remap: Set redirection hint in the IRTE
Date: Sun,  2 Jan 2011 02:18:47 -0500
Message-Id: <1293952756-15010-232-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:22.0870 (UTC) FILETIME=[13ED9760:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 75e3cfbed6f71a8f151dc6e413b6ce3c390030cb upstream.

Currently the redirection hint in the interrupt-remapping table entry
is set to 0, which means the remapped interrupt is directed to the
processors listed in the destination. So in logical flat mode
in the presence of intr-remapping, this results in a single
interrupt multi-casted to multiple cpu's as specified by the destination
bit mask. But what we really want is to send that interrupt to one of the cpus
based on the lowest priority delivery mode.

Set the redirection hint in the IRTE to '1' to indicate that we want
the remapped interrupt to be directed to only one of the processors
listed in the destination.

This fixes the issue of same interrupt getting delivered to multiple cpu's
in the logical flat mode in the presence of interrupt-remapping. While
there is no functional issue observed with this behavior, this will
impact performance of such configurations (<=8 cpu's using logical flat
mode in the presence of interrupt-remapping)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
Cc: Weidong Han <weidong.han@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 469d45a..38128cc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1401,6 +1401,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3364,6 +3365,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		if (pdev)
-- 
1.7.3.3

