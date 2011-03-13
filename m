Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1CMPb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:31:59 -0400
Received: from compulab.co.il ([67.18.134.219]:37869 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1CMPb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:31:56 -0400
Message-ID: <4D7CE2BB.5010802@compulab.co.il>
Date: Sun, 13 Mar 2011 17:28:59 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 2/3] lpc_sch: expand for Tunnel Creek
References: <4D7CE230.1070004@compulab.co.il>
In-Reply-To: <4D7CE230.1070004@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Poulsbo SCH and Tunnel Creek provide almost the
same LPC interface. Use the same driver for both devices while
storing PCI ID to distinguish between platforms to apply plarform
related quirks.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/mfd/lpc_sch.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 51b2f60..ea3f52c 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -61,6 +61,7 @@ static struct mfd_cell lpc_sch_cells[] = {

 static struct pci_device_id lpc_sch_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
@@ -70,6 +71,7 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 {
 	unsigned int base_addr_cfg;
 	unsigned short base_addr;
+	int i;

 	pci_read_config_dword(dev, SMBASE, &base_addr_cfg);
 	if (!(base_addr_cfg & (1 << 31))) {
@@ -99,7 +101,10 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 	gpio_sch_resource.start = base_addr;
 	gpio_sch_resource.end = base_addr + GPIO_IO_SIZE - 1;

-	return mfd_add_devices(&dev->dev, -1,
+	for (i=0; i < ARRAY_SIZE(lpc_sch_cells); i++)
+		lpc_sch_cells[i].id = id->device;
+
+	return mfd_add_devices(&dev->dev, 0,
 			lpc_sch_cells, ARRAY_SIZE(lpc_sch_cells), NULL, 0);
 }

-- 
1.7.0.4
