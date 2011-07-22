Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1GVJlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:41:35 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48870 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1GVJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:41:31 -0400
Date: Fri, 22 Jul 2011 11:41:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Garzik <jgarzik@pobox.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH #upstream] ahci: start engine only during soft/hard resets
Message-ID: <20110722094126.GI2622@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
 <20110713131407.GN2872@htj.dyndns.org>
 <CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
 <20110721084917.GE3455@htj.dyndns.org>
 <CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
 <20110722090317.GH2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722090317.GH2622@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another attempt at fixing the same problem that 270dac35c2
(libata: ahci_start_engine compliant to AHCI spec) tried to solve.
Unfortunately, 270dac35c2 created regressions for a lot more common
controllers and got reverted.

This specific AHCI IP block becomes a brick if the DMA engine is
started while DRQ is set.  It is not possible to avoid the condition
completely but the most common occurrence is caused by spurious use of
ahci_start_engine() from ahci_start_port() during init sequence.

DMA engine is started after both soft and hard resets and
ahci_start_port() is always followed by resets, so there is no reason
to start DMA engine from ahci_start_port().

This patch removes ahci_start_engine() invocation from
ahci_start_port().  This change makes failure path of
ahci_port_suspend() leave engine stopped without following resets.
This is resolved by replacing ahci_start_port() call with
ata_port_freeze() which forces resets afterwards, which is the better
behavior anyway.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Brian Norris <computersforpeace@gmail.com>
Reported-by: Jian Peng <jipeng2005@gmail.com>
---
Jeff, this needs to be tested for a while in linux-next before sending
it mainline.  Please apply it for 3.1 merge window and let's see
whether anything explodes.

Thanks.

 drivers/ata/libahci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 41223c7..d57f4cf 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -745,9 +745,6 @@ static void ahci_start_port(struct ata_port *ap)
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
-	/* enable DMA */
-	ahci_start_engine(ap);
-
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {
@@ -1976,7 +1973,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ahci_power_down(ap);
 	else {
 		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
-		ahci_start_port(ap);
+		ata_port_freeze(ap);
 	}
 
 	return rc;
