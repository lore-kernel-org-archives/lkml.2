Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab2EWRRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:17:18 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:45515 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab2EWRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:17:17 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Russ.Dill@ti.com, mporter@ti.com,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] [ARM] Unconditional call to smp_cross_call on UP crashes
Date: Thu, 24 May 2012 17:09:59 +0000
Message-Id: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap2plus_defconfig builds with SMP & SMP_ON_UP set.
On beagle (which is UP) is_smp() returns false and we don't call
smp_init_cpus which in turn does not initialize smp_cross_call which
remains NULL.

When issuing a reboot we OOPS with a NULL dereference on stop smp_call.

Fixed by checking is_smp in smp_send_stop()
---
 arch/arm/kernel/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8f46446..2a61335 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -588,6 +588,10 @@ void smp_send_stop(void)
 	unsigned long timeout;
 	struct cpumask mask;
 
+	/* make sure we don't bother if not SMP */
+	if (!is_smp())
+		return;
+
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 	smp_cross_call(&mask, IPI_CPU_STOP);
-- 
1.7.1

