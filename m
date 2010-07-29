Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0G2Ldn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:33:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:47803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0G2Ldm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:33:42 -0400
Date: Thu, 29 Jul 2010 11:31:25 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, ian.campbell@citrix.com,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, ian.campbell@citrix.com, tglx@linutronix.de
In-Reply-To: <1280398595-29708-3-git-send-email-ian.campbell@citrix.com>
References: <1280398595-29708-3-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupts
Message-ID: <tip-ba461f094bab2dc09487816b9dfce845796b259d@git.kernel.org>
Git-Commit-ID: ba461f094bab2dc09487816b9dfce845796b259d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 11:31:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba461f094bab2dc09487816b9dfce845796b259d
Gitweb:     http://git.kernel.org/tip/ba461f094bab2dc09487816b9dfce845796b259d
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Thu, 29 Jul 2010 11:16:34 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Jul 2010 13:24:57 +0200

powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupts

kw_i2c_irq and via_pmu_interrupt are not timer interrupts and
therefore should not use IRQF_TIMER. Use the recently introduced
IRQF_NO_SUSPEND instead since that is the actual desired behaviour.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1280398595-29708-3-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/platforms/powermac/low_i2c.c |    5 +++--
 drivers/macintosh/via-pmu.c               |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index 06a137c..480567e 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -542,11 +542,12 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
 	/* Make sure IRQ is disabled */
 	kw_write_reg(reg_ier, 0);
 
-	/* Request chip interrupt. We set IRQF_TIMER because we don't
+	/* Request chip interrupt. We set IRQF_NO_SUSPEND because we don't
 	 * want that interrupt disabled between the 2 passes of driver
 	 * suspend or we'll have issues running the pfuncs
 	 */
-	if (request_irq(host->irq, kw_i2c_irq, IRQF_TIMER, "keywest i2c", host))
+	if (request_irq(host->irq, kw_i2c_irq, IRQF_NO_SUSPEND,
+			"keywest i2c", host))
 		host->irq = NO_IRQ;
 
 	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 3d4fc0f..35bc273 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -400,11 +400,12 @@ static int __init via_pmu_start(void)
 		printk(KERN_ERR "via-pmu: can't map interrupt\n");
 		return -ENODEV;
 	}
-	/* We set IRQF_TIMER because we don't want the interrupt to be disabled
-	 * between the 2 passes of driver suspend, we control our own disabling
-	 * for that one
+	/* We set IRQF_NO_SUSPEND because we don't want the interrupt
+	 * to be disabled between the 2 passes of driver suspend, we
+	 * control our own disabling for that one
 	 */
-	if (request_irq(irq, via_pmu_interrupt, IRQF_TIMER, "VIA-PMU", (void *)0)) {
+	if (request_irq(irq, via_pmu_interrupt, IRQF_NO_SUSPEND,
+			"VIA-PMU", (void *)0)) {
 		printk(KERN_ERR "via-pmu: can't request irq %d\n", irq);
 		return -ENODEV;
 	}
