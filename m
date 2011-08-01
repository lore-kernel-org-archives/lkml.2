Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1HAXh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:37:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1HAXY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.708681245@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [21/70] firewire: ohci: do not bind to Pinnacle cards, avert panic
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 7f7e37115a8b6724f26d0637a04e1d35e3c59717 upstream.

When firewire-ohci is bound to a Pinnacle MovieBoard, eventually a
"Register access failure" is logged and an interrupt storm or a kernel
panic happens.  https://bugzilla.kernel.org/show_bug.cgi?id=36622

Until this is sorted out (if that is going to succeed at all), let's
just prevent firewire-ohci from touching these devices.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -264,6 +264,7 @@ static char ohci_driver_name[] = KBUILD_
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 
 #define QUIRK_CYCLE_TIMER		1
 #define QUIRK_RESET_PACKET		2
@@ -3170,6 +3171,11 @@ static int __devinit pci_probe(struct pc
 	int i, err;
 	size_t size;
 
+	if (dev->vendor == PCI_VENDOR_ID_PINNACLE_SYSTEMS) {
+		dev_err(&dev->dev, "Pinnacle MovieBoard is not yet supported\n");
+		return -ENOSYS;
+	}
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		err = -ENOMEM;


