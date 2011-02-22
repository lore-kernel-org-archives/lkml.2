Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1BVNMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:12:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1BVNMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:12:52 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Zhu2ZE-XKKUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=H1l2k1CEr8tsP529ZqkA:9 a=yFb-N5SNXuWir0OrBmSHiQXHKvUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] rt2x00: Use ops name instead of device name
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Cc: Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>, abogani@texware.it
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 08:12:48 -0500
Message-ID: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, someone complained that they see the PCI address of a device
in the interrupts file instead of the device name.

19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0

>From lspci:

05:01.0 Network controller: RaLink RT2561/RT61 rev B 802.11g
  Subsystem: D-Link System Inc AirPlus G DWL-G510 Wireless Network Adapter (Rev.C)
  Flags: bus master, slow devsel, latency 32,
  IRQ 19  Memory at f9100000 (32-bit, non-prefetchable) [size=32K]
  Capabilities: <access denied>
  Kernel driver in use: rt61pci
  Kernel modules: rt61pci

Investigating this, it seems to be the result of the pci_name() used in
rt2x00pci_probe().

Since the struct rt2x00_ops records the module name for the device as
well as the ops, it would make more sense to show that in the interrupt
output instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index ace0b66..06575dc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -284,7 +284,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 	rt2x00dev->irq = pci_dev->irq;
-	rt2x00dev->name = pci_name(pci_dev);
+	rt2x00dev->name = ops->name;
 
 	if (pci_is_pcie(pci_dev))
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);


