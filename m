Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1HAXek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:34:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1HAX0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232055.041433517@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Toth <stoth@kernellabs.com>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Jarod Wilson <jarod@redhat.com>, Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [44/70] [media] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit d7515b8866b60c9526d2d7af37ebcd16c3c5ed97 upstream.

This reverts commit e38030f3ff02684eb9e25e983a03ad318a10a2ea.

MSI flat-out doesn't work right on cx2388x devices yet. There are now
multiple reports of cards that hard-lock systems when MSI is enabled,
including my own HVR-1250 when trying to use its built-in IR receiver.
Disable MSI and it works just fine. Similar for another user's HVR-1270.
Issues have also been reported with the HVR-1850 when MSI is enabled,
and the 1850 behavior sounds similar to an as-yet-undiagnosed issue I've
seen with an 1800.

CC: Steven Toth <stoth@kernellabs.com>
CC: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -2060,12 +2060,8 @@ static int __devinit cx23885_initdev(str
 		goto fail_irq;
 	}
 
-	if (!pci_enable_msi(pci_dev))
-		err = request_irq(pci_dev->irq, cx23885_irq,
-				  IRQF_DISABLED, dev->name, dev);
-	else
-		err = request_irq(pci_dev->irq, cx23885_irq,
-				  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+	err = request_irq(pci_dev->irq, cx23885_irq,
+			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
@@ -2114,7 +2110,6 @@ static void __devexit cx23885_finidev(st
 
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
-	pci_disable_msi(pci_dev);
 
 	cx23885_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);


