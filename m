Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0ELJ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:27:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:43783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0ELJ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:27:55 -0400
Date: Wed, 12 May 2010 09:27:38 GMT
From: tip-bot for Peter P Waskiewicz Jr 
	<peter.p.waskiewicz.jr@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peter.p.waskiewicz.jr@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peter.p.waskiewicz.jr@intel.com, tglx@linutronix.de
In-Reply-To: <20100505205638.5426.87189.stgit@ppwaskie-hc2.jf.intel.com>
References: <20100505205638.5426.87189.stgit@ppwaskie-hc2.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Clear CPU mask in affinity_hint when none is provided
Message-ID: <tip-4308ad801193f14ff42cb746da37cf07e35f0d08@git.kernel.org>
Git-Commit-ID: 4308ad801193f14ff42cb746da37cf07e35f0d08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 09:27:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4308ad801193f14ff42cb746da37cf07e35f0d08
Gitweb:     http://git.kernel.org/tip/4308ad801193f14ff42cb746da37cf07e35f0d08
Author:     Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
AuthorDate: Wed, 5 May 2010 13:56:42 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 May 2010 11:23:34 +0200

genirq: Clear CPU mask in affinity_hint when none is provided

When an interrupt is disabled and torn down, the CPU mask returned
through affinity_hint right now is all CPUs. Also, for drivers that
don't provide an affinity_hint mask, this can be misleading. There
should be no hint at all, meaning an empty CPU mask.

[ tglx: use zalloc_cpumask_var instead of clearing it under the lock ]

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: davem@davemloft.net
Cc: arjan@linux.jf.intel.com
Cc: bhutchings@solarflare.com
LKML-Reference: <20100505205638.5426.87189.stgit@ppwaskie-hc2.jf.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/proc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4f9427a..09a2ee5 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -38,14 +38,12 @@ static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
 	unsigned long flags;
 	cpumask_var_t mask;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (desc->affinity_hint)
 		cpumask_copy(mask, desc->affinity_hint);
-	else
-		cpumask_setall(mask);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	seq_cpumask(m, mask);
