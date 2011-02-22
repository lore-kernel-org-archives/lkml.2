Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1BVWat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:30:49 -0500
Received: from kroah.org ([198.145.64.141]:46748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1BVWVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.523863067@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [35/70] x86, mrst: Set correct APB timer IRQ affinity for secondary cpu
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

This is a backport for 2.6.37 stable. The original commit ID is
6550904ddbc3c286798a87edf95eeebcc62bc58a

Offlining the secondary CPU causes the timer irq affinity to be set to
CPU 0. When the secondary CPU is back online again, the wrong irq
affinity will be used.

This patch ensures secondary per CPU timer always has the correct
IRQ affinity when enabled.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1294963604-18111-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apb_timer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -313,10 +313,12 @@ static void apbt_setup_irq(struct apbt_d
 	if (adev->irq == 0)
 		return;
 
+	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+	/* APB timer irqs are set up as mp_irqs, timer is edge type */
+	__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
+
 	if (system_state == SYSTEM_BOOTING) {
-		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-		/* APB timer irqs are set up as mp_irqs, timer is edge type */
-		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
 				IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
 				adev->name, adev)) {


