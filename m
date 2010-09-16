Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0IPAwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 20:52:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:58873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0IPAwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:52:36 -0400
Date: Thu, 16 Sep 2010 00:52:11 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
References: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x2apic] x86, intr-remap: Set redirection hint in the IRTE
Message-ID: <tip-75e3cfbed6f71a8f151dc6e413b6ce3c390030cb@git.kernel.org>
Git-Commit-ID: 75e3cfbed6f71a8f151dc6e413b6ce3c390030cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 00:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75e3cfbed6f71a8f151dc6e413b6ce3c390030cb
Gitweb:     http://git.kernel.org/tip/75e3cfbed6f71a8f151dc6e413b6ce3c390030cb
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 27 Aug 2010 11:09:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Sep 2010 17:36:37 -0700

x86, intr-remap: Set redirection hint in the IRTE

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
Cc: <stable@kernel.org> # [v2.6.32+]
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f1efeba..90f8a75 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1392,6 +1392,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3343,6 +3344,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		if (pdev)
