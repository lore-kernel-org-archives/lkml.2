Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2FFPEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:04:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2FFPES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:04:18 -0400
Date: Wed, 6 Jun 2012 08:03:58 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/irq:
  Update irq_cfg domain unless the new affinity is a subset of the current domain
Git-Commit-ID: 332afa656e76458ee9cf0f0d123016a0658539e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:04:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  332afa656e76458ee9cf0f0d123016a0658539e4
Gitweb:     http://git.kernel.org/tip/332afa656e76458ee9cf0f0d123016a0658539e4
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 21 May 2012 16:58:01 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 09:51:22 +0200

x86/irq: Update irq_cfg domain unless the new affinity is a subset of the current domain

Until now, irq_cfg domain is mostly static. Either all CPU's
(used by flat mode) or one CPU (first CPU in the irq afffinity
mask) to which irq is being migrated (this is used by the rest
of apic modes).

Upcoming x2apic cluster mode optimization patch allows the irq
to be sent to any CPU in the x2apic cluster (if supported by the
HW). So irq_cfg domain changes on the fly (depending on which
CPU in the x2apic cluster is online).

Instead of checking for any intersection between the new irq
affinity mask and the current irq_cfg domain, check if the new
irq affinity mask is a subset of the current irq_cfg domain.
Otherwise proceed with updating the irq_cfg domain aswell as
assigning vector's on all the CPUs specified in the new mask.

This also cleans up a workaround in updating irq_cfg domain for
legacy irq's that are handled by the IO-APIC.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org
Cc: gorcunov@openvz.org
Cc: agordeev@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ac96561..910a311 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1126,8 +1126,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
-		if (!cpumask_empty(tmp_mask)) {
+		if (cpumask_subset(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
 			return 0;
 		}
@@ -1141,6 +1140,11 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 		apic->vector_allocation_domain(cpu, tmp_mask);
 
+		if (cpumask_subset(tmp_mask, cfg->domain)) {
+			free_cpumask_var(tmp_mask);
+			return 0;
+		}
+
 		vector = current_vector;
 		offset = current_offset;
 next:
@@ -1346,13 +1350,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 
 	if (!IO_APIC_IRQ(irq))
 		return;
-	/*
-	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
-	 * controllers like 8259. Now that IO-APIC can handle this irq, update
-	 * the cfg->domain.
-	 */
-	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
-		apic->vector_allocation_domain(0, cfg->domain);
 
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
