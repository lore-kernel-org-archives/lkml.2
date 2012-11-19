Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2KSUER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:04:17 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59249 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113Ab2KSUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:04:16 -0500
Message-ID: <1353355451.19434.14.camel@x61.thuisdomein>
Subject: [PATCH] mfd: lpc_ich: one uninitialized cell is no error
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 21:04:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2012 20:04:11.0901 (UTC) FILETIME=[0AE5EAD0:01CDC691]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At every boot of an (outdated) laptop lpc_ich prints an error:
    lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized

But if one looks at lpc_ich's probe function one notices that the code
only cares if both lpc_ich_init_wdt() and lpc_ich_init_gpio() fail to
add any cells. So stop treating the failure to add a single cell as an
error. Those messages can be printed at notice level. And then only warn
if no cells were added.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This patch was written on top of v3.7-rc4 and tested on v3.6.7.

1) Please note that this patch prints a warning when no MFD cells are
added at all. I didn't make that an error because I'm not sure there's
anything one can do if this happens. Is there?

 drivers/mfd/lpc_ich.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index a22544f..a102f7a 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -734,7 +734,7 @@ static int __devinit lpc_ich_init_gpio(struct pci_dev *dev,
 	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
-		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
+		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
 		lpc_ich_cells[LPC_GPIO].num_resources--;
 		goto gpe0_done;
 	}
@@ -760,7 +760,7 @@ gpe0_done:
 	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
-		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
+		dev_notice(&dev->dev, "I/O space for GPIO uninitialized\n");
 		ret = -ENODEV;
 		goto gpio_done;
 	}
@@ -810,7 +810,7 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
-		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
+		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
 		ret = -ENODEV;
 		goto wdt_done;
 	}
@@ -834,8 +834,8 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 		pci_read_config_dword(dev, RCBABASE, &base_addr_cfg);
 		base_addr = base_addr_cfg & 0xffffc000;
 		if (!(base_addr_cfg & 1)) {
-			pr_err("RCBA is disabled by hardware/BIOS, "
-					"device disabled\n");
+			dev_notice(&dev->dev, "RCBA is disabled by "
+					"hardware/BIOS, device disabled\n");
 			ret = -ENODEV;
 			goto wdt_done;
 		}
@@ -871,6 +871,7 @@ static int __devinit lpc_ich_probe(struct pci_dev *dev,
 	 * successfully.
 	 */
 	if (!cell_added) {
+		dev_warn(&dev->dev, "No MFD cells added\n");
 		lpc_ich_restore_config_space(dev);
 		return -ENODEV;
 	}
-- 
1.7.7.6

