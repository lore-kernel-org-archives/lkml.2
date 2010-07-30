Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0G3SxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:53:13 -0400
Received: from kroah.org ([198.145.64.141]:35600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759226Ab0G3ReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:05 2010
Message-Id: <20100730173105.464991954@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [030/140] cmd640: fix kernel oops in test_irq() method
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit a9ddabc52ce3757a4331d6c1e8bf4065333cc51b upstream.

When implementing the test_iqr() method, I forgot that this driver is not an
ordinary PCI driver and also needs to support VLB variant of the chip. Moreover,
'hwif->dev' should be NULL, potentially causing oops in pci_read_config_byte().

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/cmd640.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -632,12 +632,10 @@ static void cmd640_init_dev(ide_drive_t
 
 static int cmd640_test_irq(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
-	u8  irq_stat, irq_mask	= hwif->channel ? ARTTIM23_IDE23INTR :
+	u8  irq_mask		= hwif->channel ? ARTTIM23_IDE23INTR :
 						  CFR_IDE01INTR;
-
-	pci_read_config_byte(dev, irq_reg, &irq_stat);
+	u8  irq_stat		= get_cmd640_reg(irq_reg);
 
 	return (irq_stat & irq_mask) ? 1 : 0;
 }


