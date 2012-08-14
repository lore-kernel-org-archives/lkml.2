Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2HNRCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:02:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2HNRCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:02:32 -0400
Date: Tue, 14 Aug 2012 10:02:01 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-f1c6300183dbf5b9da25988e13f6f25a9e27151b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        bp@amd64.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        bp@amd64.org
In-Reply-To: <1344453412.29170.5.camel@sbsiddha-desk.sc.intel.com>
References: <1344453412.29170.5.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic:
  fix broken legacy interrupts in the logical apic mode
Git-Commit-ID: f1c6300183dbf5b9da25988e13f6f25a9e27151b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 14 Aug 2012 10:02:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1c6300183dbf5b9da25988e13f6f25a9e27151b
Gitweb:     http://git.kernel.org/tip/f1c6300183dbf5b9da25988e13f6f25a9e27151b
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 8 Aug 2012 12:16:52 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Aug 2012 09:52:20 -0700

x86, apic: fix broken legacy interrupts in the logical apic mode

Recent commit 332afa656e76458ee9cf0f0d123016a0658539e4 cleaned up
a workaround that updates irq_cfg domain for legacy irq's that
are handled by the IO-APIC. This was assuming that the recent
changes in assign_irq_vector() were sufficient to remove the workaround.

But this broke couple of AMD platforms. One of them seems to be
sending interrupts to the offline cpu's, resulting in spurious
"No irq handler for vector xx (irq -1)" messages when those cpu's come online.
And the other platform seems to always send the interrupt to the last logical
CPU (cpu-7). Recent changes had an unintended side effect of using only logical
cpu-0 in the IO-APIC RTE (during boot for the legacy interrupts) and this
broke the legacy interrupts not getting routed to the cpu-7 on the AMD
platform, resulting in a boot hang.

For now, reintroduce the removed workaround, (essentially not allowing the
vector to change for legacy irq's when io-apic starts to handle the irq. Which
also addressed the uninteded sife effect of just specifying cpu-0 in the
IO-APIC RTE for those irq's during boot).

Reported-and-tested-by: Robert Richter <robert.richter@amd.com>
Reported-and-tested-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1344453412.29170.5.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a6c64aa..c265593 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1356,6 +1356,16 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	/*
+	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
+	 * can handle this irq and the apic driver is finialized at this point,
+	 * update the cfg->domain.
+	 */
+	if (irq < legacy_pic->nr_legacy_irqs &&
+	    cpumask_equal(cfg->domain, cpumask_of(0)))
+		apic->vector_allocation_domain(0, cfg->domain,
+					       apic->target_cpus());
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
