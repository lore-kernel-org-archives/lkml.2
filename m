Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1D2S6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:31 -0400
Received: from kroah.org ([198.145.64.141]:50288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1D2S60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185654.993077106@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxime Bizon <mbizon@freebox.fr>, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [25/55] ahci: dont enable port irq before handler is registered
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit 7b3a24c57d2eeda8dba9c205342b12689c4679f9 upstream.

The ahci_pmp_attach() & ahci_pmp_detach() unmask port irqs, but they
are also called during port initialization, before ahci host irq
handler is registered. On ce4100 platform, this sometimes triggers
"irq 4: nobody cared" message when loading driver.

Fixed this by not touching the register if the port is in frozen
state, and mark all uninitialized port as frozen.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libahci.c     |   17 +++++++++++++++--
 drivers/ata/libata-core.c |    4 ++--
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1897,7 +1897,17 @@ static void ahci_pmp_attach(struct ata_p
 	ahci_enable_fbs(ap);
 
 	pp->intr_mask |= PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+	 * We must not change the port interrupt mask register if the
+	 * port is marked frozen, the value in pp->intr_mask will be
+	 * restored later when the port is thawed.
+	 *
+	 * Note that during initialization, the port is marked as
+	 * frozen since the irq handler is not yet registered.
+	 */
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_pmp_detach(struct ata_port *ap)
@@ -1913,7 +1923,10 @@ static void ahci_pmp_detach(struct ata_p
 	writel(cmd, port_mmio + PORT_CMD);
 
 	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/* see comment above in ahci_pmp_attach() */
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 int ahci_port_resume(struct ata_port *ap)
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5479,8 +5479,8 @@ struct ata_port *ata_port_alloc(struct a
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	if (!ap)
 		return NULL;
-	
-	ap->pflags |= ATA_PFLAG_INITIALIZING;
+
+	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
 	ap->host = host;


