Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1ANXtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:49:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:34910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab1ANXtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:49:09 -0500
Date: Fri, 14 Jan 2011 23:48:51 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1294963604-18111-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1294963604-18111-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mrst: Set correct APB timer IRQ affinity for secondary cpu
Message-ID: <tip-6550904ddbc3c286798a87edf95eeebcc62bc58a@git.kernel.org>
Git-Commit-ID: 6550904ddbc3c286798a87edf95eeebcc62bc58a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 Jan 2011 23:48:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6550904ddbc3c286798a87edf95eeebcc62bc58a
Gitweb:     http://git.kernel.org/tip/6550904ddbc3c286798a87edf95eeebcc62bc58a
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Thu, 13 Jan 2011 16:06:44 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jan 2011 11:53:44 -0800

x86, mrst: Set correct APB timer IRQ affinity for secondary cpu

Offlining the secondary CPU causes the timer irq affinity to be set to
CPU 0. When the secondary CPU is back online again, the wrong irq
affinity will be used.

This patch ensures secondary per CPU timer always has the correct
IRQ affinity when enabled.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1294963604-18111-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org> 2.6.37
---
 arch/x86/kernel/apb_timer.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7c9ab59..51ef31a 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -313,14 +313,16 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 	if (adev->irq == 0)
 		return;
 
+	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+	/* APB timer irqs are set up as mp_irqs, timer is edge type */
+	__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
+
 	if (system_state == SYSTEM_BOOTING) {
-		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-		/* APB timer irqs are set up as mp_irqs, timer is edge type */
-		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
-				IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
-				adev->name, adev)) {
+					IRQF_TIMER | IRQF_DISABLED |
+					IRQF_NOBALANCING,
+					adev->name, adev)) {
 			printk(KERN_ERR "Failed request IRQ for APBT%d\n",
 			       adev->num);
 		}
