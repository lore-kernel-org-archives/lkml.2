Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0C3Xdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:33:36 -0400
Received: from kroah.org ([198.145.64.141]:46528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab0C3XVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:21 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:34 2010
Message-Id: <20100330224833.819159047@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [112/156] icside: bring back ->maskproc method
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[ Upstream commit f75d4a238770d83d3a0475ce7f34e3fa37de161e ]

Bring back ->maskproc method since it is still needed for proper operation,
as noticed by Russell King:

> This change is bogus.
>
>         writeb(0, base + ICS_ARCIN_V6_INTROFFSET_1);
>         readb(base + ICS_ARCIN_V6_INTROFFSET_2);
>
>         writeb(0, base + ICS_ARCIN_V6_INTROFFSET_2);
>         readb(base + ICS_ARCIN_V6_INTROFFSET_1);
>
> This sequence of code does:
>
> 1. enable interrupt 1
> 2. disable interrupt 2
> 3. enable interrupt 2
> 4. disable interrupt 1
>
> which results in the interrupt for the second channel being enabled -
> leaving channel 1 blocked.
>
> Firstly, icside shares its two IDE channels with one DMA engine - so it's
> a simplex interface.  IDE supports those (or did when the code was written)
> serializing requests between the two interfaces.  libata does not.
>
> Secondly, the interrupt lines on icside float when there's no drive connected
> or when the drive has its NIEN bit set, which means that you get spurious
> screaming interrupts which can kill off all expansion card interrupts on
> the machine unless you disable the channel interrupt on the card.
>
> Since libata can not serialize the operation of the two channels like IDE
> can, the libata version of the icside driver does not contain the interrupt
> stearing logic.  Instead, it looks at the status after reset, and if
> nothing was found on that channel, it masks the interrupt from that
> channel.

This patch reverts changes done in commit dff8817 (I became confused due to
non-standard & undocumented ->maskproc method, anyway sorry about that).

Noticed-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/icside.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 4 deletions(-)

--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -65,6 +65,8 @@ static struct cardinfo icside_cardinfo_v
 };
 
 struct icside_state {
+	unsigned int channel;
+	unsigned int enabled;
 	void __iomem *irq_port;
 	void __iomem *ioc_base;
 	unsigned int sel;
@@ -114,11 +116,18 @@ static void icside_irqenable_arcin_v6 (s
 	struct icside_state *state = ec->irq_data;
 	void __iomem *base = state->irq_port;
 
-	writeb(0, base + ICS_ARCIN_V6_INTROFFSET_1);
-	readb(base + ICS_ARCIN_V6_INTROFFSET_2);
+	state->enabled = 1;
 
-	writeb(0, base + ICS_ARCIN_V6_INTROFFSET_2);
-	readb(base + ICS_ARCIN_V6_INTROFFSET_1);
+	switch (state->channel) {
+	case 0:
+		writeb(0, base + ICS_ARCIN_V6_INTROFFSET_1);
+		readb(base + ICS_ARCIN_V6_INTROFFSET_2);
+		break;
+	case 1:
+		writeb(0, base + ICS_ARCIN_V6_INTROFFSET_2);
+		readb(base + ICS_ARCIN_V6_INTROFFSET_1);
+		break;
+	}
 }
 
 /* Prototype: icside_irqdisable_arcin_v6 (struct expansion_card *ec, int irqnr)
@@ -128,6 +137,8 @@ static void icside_irqdisable_arcin_v6 (
 {
 	struct icside_state *state = ec->irq_data;
 
+	state->enabled = 0;
+
 	readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
 	readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
 }
@@ -149,6 +160,44 @@ static const expansioncard_ops_t icside_
 	.irqpending	= icside_irqpending_arcin_v6,
 };
 
+/*
+ * Handle routing of interrupts.  This is called before
+ * we write the command to the drive.
+ */
+static void icside_maskproc(ide_drive_t *drive, int mask)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	state->channel = hwif->channel;
+
+	if (state->enabled && !mask) {
+		switch (hwif->channel) {
+		case 0:
+			writeb(0, state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
+			readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
+			break;
+		case 1:
+			writeb(0, state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
+			readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
+			break;
+		}
+	} else {
+		readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_2);
+		readb(state->irq_port + ICS_ARCIN_V6_INTROFFSET_1);
+	}
+
+	local_irq_restore(flags);
+}
+
+static const struct ide_port_ops icside_v6_no_dma_port_ops = {
+	.maskproc		= icside_maskproc,
+};
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 /*
  * SG-DMA support.
@@ -228,6 +277,7 @@ static void icside_set_dma_mode(ide_driv
 
 static const struct ide_port_ops icside_v6_port_ops = {
 	.set_dma_mode		= icside_set_dma_mode,
+	.maskproc		= icside_maskproc,
 };
 
 static void icside_dma_host_set(ide_drive_t *drive, int on)
@@ -272,6 +322,11 @@ static int icside_dma_setup(ide_drive_t
 	BUG_ON(dma_channel_active(ec->dma));
 
 	/*
+	 * Ensure that we have the right interrupt routed.
+	 */
+	icside_maskproc(drive, 0);
+
+	/*
 	 * Route the DMA signals to the correct interface.
 	 */
 	writeb(state->sel | hwif->channel, state->ioc_base);
@@ -399,6 +454,7 @@ err_free:
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
+	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,


