Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2ACWgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2ACWgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223032.404102859@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Buesch <m@bues.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [13/67] ssb: fix init regression with SoCs
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hauke Mehrtens <hauke@hauke-m.de>

commit 329456d1ffb416c220813725b7363cda9975c9aa upstream.

This fixes a Data bus error on some SoCs. The first fix for this
problem did not solve it on all devices.
    commit 6ae8ec27868bfdbb815287bee8146acbefaee867
    Author: Rafał Miłecki <zajec5@gmail.com>
    Date:   Tue Jul 5 17:25:32 2011 +0200
        ssb: fix init regression of hostmode PCI core

In ssb_pcicore_fix_sprom_core_index() the sprom on the PCI core is
accessed, but the sprom only exists when the ssb bus is connected over
a PCI bus to the rest of the system and not when the SSB Bus is the
main system bus. SoCs sometimes have a PCI host controller and there
this code will not be executed, but there are some old SoCs with an PCI
controller in client mode around and ssb_pcicore_fix_sprom_core_index()
should not be called on these devices too. The PCI controller on these
devices are unused, but without this fix it results in an Data bus
error when it gets initialized.

Cc: Michael Buesch <m@bues.ch>
Cc: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/driver_pcicore.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -516,10 +516,14 @@ static void ssb_pcicore_pcie_setup_worka
 
 static void ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
 {
-	ssb_pcicore_fix_sprom_core_index(pc);
+	struct ssb_device *pdev = pc->dev;
+	struct ssb_bus *bus = pdev->bus;
+
+	if (bus->bustype == SSB_BUSTYPE_PCI)
+		ssb_pcicore_fix_sprom_core_index(pc);
 
 	/* Disable PCI interrupts. */
-	ssb_write32(pc->dev, SSB_INTVEC, 0);
+	ssb_write32(pdev, SSB_INTVEC, 0);
 
 	/* Additional PCIe always once-executed workarounds */
 	if (pc->dev->id.coreid == SSB_DEV_PCIE) {


