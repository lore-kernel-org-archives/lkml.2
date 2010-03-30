Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0C3XdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:33:23 -0400
Received: from kroah.org ([198.145.64.141]:46538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab0C3XVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:23 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:35 2010
Message-Id: <20100330224834.451448924@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [113/156] Revert "ide: skip probe if there are no devices on the port (v2)"
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 9ce41aed0d392246eb788786253f242e829fd5e1 ]

This reverts commit a20b2a44eca52818ef52a94959480b7e6ea2f528.

As requested by David Fries.  This makes CDROMs which are slave drives
on a ribbon without a master disappear and causes other similar kinds
of badness.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-probe.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -695,14 +695,8 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	rc = ide_port_wait_ready(hwif);
-	if (rc == -ENODEV) {
-		printk(KERN_INFO "%s: no devices on the port\n", hwif->name);
-		goto out;
-	} else if (rc == -EBUSY)
-		printk(KERN_ERR "%s: not ready before the probe\n", hwif->name);
-	else
-		rc = -ENODEV;
+	if (ide_port_wait_ready(hwif) == -EBUSY)
+		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
 	/*
 	 * Second drive should only exist if first drive was found,
@@ -713,7 +707,7 @@ static int ide_probe_port(ide_hwif_t *hw
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
 	}
-out:
+
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above


