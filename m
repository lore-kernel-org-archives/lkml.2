Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1LDMsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 07:48:40 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:37990 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1LDMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 07:48:39 -0500
Message-ID: <4EDB6C10.10102@ladisch.de>
Date: Sun, 04 Dec 2011 13:48:16 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>	<20111130154445.GA27198@gere.osrc.amd.com>	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com> <CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
In-Reply-To: <CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> [...]
> But to no avail. Both IRQ19 and IRQ16 keep becoming lost after a while.

You previously said that unloading e1000 made things better.  Did this
affect both IRQs 16 and 19?

Can you check if this problem (on either 16 or 19) happens when you are
not using the e1000 port (i.e., unplugged)?

> I'm adding a full /proc/interrupts and lspci -vv output at the bottom,
> all from the 3.0.0 Ubuntu kernel. Feel free to mention any bad guys
> you recognize in this log.

The /proc/interrupts doesn't show e1000, but lspci does.  ...?

Does the problem occur without fglrx?

To get the AHCI interrupt away from IRQ 19, try the patch below.
(But please don't show that ugly hack to any AMD guy. :)

> Is there any way of obtaining more output such as IO-APIC register
> states to verify that it is indeed a stuck IRQ input line and not an
> unsuccesful EOI ack ?

In theory, lspci's "Status: ... INTx+" shows an active interrupt line.


Regards,
Clemens


--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2906,6 +2906,48 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f8, quirk_intel_mc_errata);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f9, quirk_intel_mc_errata);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65fa, quirk_intel_mc_errata);

+#if defined(CONFIG_PCI_MSI) && \
+	(defined(CONFIG_SATA_AHCI) || defined(CONFIG_SATA_AHCI_MODULE))
+static void __init sb7x0_ahci_msi_enable(struct pci_dev *dev)
+{
+	u8 rev, ptr;
+	int where;
+	u32 misc_control;
+
+	pci_bus_read_config_byte(dev->bus, PCI_DEVFN(0x14, 0),
+				 PCI_REVISION_ID, &rev);
+	if (rev < 0x3c) /* A14 */
+		return;
+
+	pci_read_config_byte(dev, 0x34, &ptr);
+	if (ptr == 0x70) {
+		where = 0x34;
+	} else {
+		pci_read_config_byte(dev, 0x61, &ptr);
+		if (ptr == 0x70)
+			where = 0x61;
+		else
+			return;
+	}
+
+	pci_read_config_byte(dev, 0x51, &ptr);
+	if (ptr != 0x70)
+		return;
+
+	pci_read_config_dword(dev, 0x40, &misc_control);
+	misc_control |= 1;
+	pci_write_config_dword(dev, 0x40, misc_control);
+
+	pci_write_config_byte(dev, where, 0x50);
+
+	misc_control &= ~1;
+	pci_write_config_dword(dev, 0x40, misc_control);
+
+	dev_dbg(&dev->dev, "AHCI: enabled MSI\n");
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x4391, sb7x0_ahci_msi_enable);
+#endif
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
