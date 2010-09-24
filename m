Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab0IXQgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:36:55 -0400
Received: from kroah.org ([198.145.64.141]:37466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab0IXQgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:36:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.611341022@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [63/68] pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit a75032e8772d13dab5e3501413d7e14a148281b4 upstream.

On Monday 04 January 2010 02:30:24 pm Russell King wrote:

> Found the problem - getting rid of the read of the alt status register
> after the command has been written fixes the UDMA CRC errors on write:
>
> @@ -676,7 +676,8 @@ void ata_sff_exec_command(struct ata_port *ap, const struct
> ata_taskfile *tf)
>         DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
>
>         iowrite8(tf->command, ap->ioaddr.command_addr);
> -       ata_sff_pause(ap);
> +       ndelay(400);
> +//     ata_sff_pause(ap);
>  }
>  EXPORT_SYMBOL_GPL(ata_sff_exec_command);
>
>
> This rather makes sense.  The PDC20247 handles the UDMA part of the
> protocol.  It has no way to tell the PDC20246 to wait while it suspends
> UDMA, so that a normal register access can take place - the 246 ploughs
> on with the register access without any regard to the state of the 247.
>
> If the drive immediately starts the UDMA protocol after a write to the
> command register (as it probably will for the DMA WRITE command), then
> we'll be accessing the taskfile in the middle of the UDMA setup, which
> can't be good.  It's certainly a violation of the ATA specs.

Fix it by adding custom ->sff_exec_command method for UDMA33 chipsets.

Debugged-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_pdc202xx_old.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,7 +2,7 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2007,2009,2010 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
@@ -35,6 +35,15 @@ static int pdc2026x_cable_detect(struct
 	return ATA_CBL_PATA80;
 }
 
+static void pdc20246_exec_command(struct ata_port *ap,
+				  const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	ndelay(400);
+}
+
 /**
  *	pdc202xx_configure_piomode	-	set chip PIO timing
  *	@ap: ATA interface
@@ -271,6 +280,8 @@ static struct ata_port_operations pdc202
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
+
+	.sff_exec_command	= pdc20246_exec_command,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {


