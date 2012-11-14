Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423562Ab2KNWiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:38:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423427Ab2KNWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:38:18 -0500
Date: Wed, 14 Nov 2012 13:33:14 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-41bfa818b30d595b1d9feee8eb8baee9befff44b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-13-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-13-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug:
  Handle retrigger irq by the first available CPU
Git-Commit-ID: 41bfa818b30d595b1d9feee8eb8baee9befff44b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:38:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41bfa818b30d595b1d9feee8eb8baee9befff44b
Gitweb:     http://git.kernel.org/tip/41bfa818b30d595b1d9feee8eb8baee9befff44b
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:55 -0800

x86, hotplug: Handle retrigger irq by the first available CPU

The first cpu in irq cfg->domain is likely to be CPU 0 and may not be available
when CPU 0 is offline. Instead of using CPU 0 to handle retriggered irq, we use
first available CPU which is online and in this irq's domain.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-13-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..f78fc2b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2199,9 +2199,11 @@ static int ioapic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
+	int cpu;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
+	cpu = cpumask_first_and(cfg->domain, cpu_online_mask);
+	apic->send_IPI_mask(cpumask_of(cpu), cfg->vector);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
