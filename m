Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab1EOQPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:15:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1610 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066Ab1EOQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:15:14 -0400
Date: Sun, 15 May 2011 18:13:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] PCI: Don't use dmi_name_in_vendors in quirk
Message-ID: <20110515181346.23a9273c@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use the costly dmi_name_in_vendors() when we know the string we
are looking for can only be in the DMI board name field. This is more
robust and, more importantly, much faster.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/quirks.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.39-rc7.orig/drivers/pci/quirks.c	2011-05-14 13:07:14.000000000 +0200
+++ linux-2.6.39-rc7/drivers/pci/quirks.c	2011-05-15 14:42:02.000000000 +0200
@@ -2349,8 +2349,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
  */
 static void __devinit nvenet_msi_disable(struct pci_dev *dev)
 {
-	if (dmi_name_in_vendors("P5N32-SLI PREMIUM") ||
-	    dmi_name_in_vendors("P5N32-E SLI")) {
+	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
+
+	if (board_name &&
+	    (strstr(board_name, "P5N32-SLI PREMIUM") ||
+	     strstr(board_name, "P5N32-E SLI"))) {
 		dev_info(&dev->dev,
 			 "Disabling msi for MCP55 NIC on P5N32-SLI\n");
 		dev->no_msi = 1;


-- 
Jean Delvare
