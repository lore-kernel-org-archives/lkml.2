Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0FGJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:22:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:44631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab0FGJW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:22:58 -0400
Message-ID: <4C0CBA5D.5000900@kernel.org>
Date: Mon, 07 Jun 2010 11:22:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Subject: Re: Hang during boot, bisected to commit 96d60303fd
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>	<20100603020006.GB19123@srcf.ucam.org>	<AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>	<4C08760B.8050002@gmail.com>	<AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com>	<AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com>	<AANLkTinZ7d3WWyO3m9A7GVnaTuSbn1G33ADFW6ixywcT@mail.gmail.com> <AANLkTinIM8swHZTide7MAQsaYbWcFD90FrKUXE9NFG-5@mail.gmail.com>
In-Reply-To: <AANLkTinIM8swHZTide7MAQsaYbWcFD90FrKUXE9NFG-5@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Jun 2010 09:22:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/07/2010 06:34 AM, Robert Hancock wrote:
> I'm thinking that the hardreset and device classification makes more
> sense as a place to do this anyways, since that's the point where we
> really know if there's a device connected or not.. Tejun, any
> thoughts?

Heh, of course it doesn't work.  Device presence can't be reliably
determined by sampling status once like that.  We don't have all the
crap in libata-eh for nothing.  :-)

Marc, can you please try the following patch?

Thanks.

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 1984a6e..261f86d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -541,29 +541,11 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return -EINVAL;
 }

-static int ahci_is_device_present(void __iomem *port_mmio)
-{
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xff;
-
-	/* Make sure PxTFD.STS.BSY and PxTFD.STS.DRQ are 0 */
-	if (status & (ATA_BUSY | ATA_DRQ))
-		return 0;
-
-	/* Make sure PxSSTS.DET is 3h */
-	status = readl(port_mmio + PORT_SCR_STAT) & 0xf;
-	if (status != 3)
-		return 0;
-	return 1;
-}
-
 void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;

-	if (!ahci_is_device_present(port_mmio))
-		return;
-
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
 	tmp |= PORT_CMD_START;
@@ -1892,6 +1874,9 @@ static void ahci_error_handler(struct ata_port *ap)
 	}

 	sata_pmp_error_handler(ap);
+
+	if (!ata_dev_enabled(ap->link.device))
+		ahci_stop_engine(ap);
 }

 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)

-- 
tejun
