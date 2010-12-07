Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0LGH5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:57:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:38932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0LGH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:57:09 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        Aries Lee <arieslee@jmicron.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3/3] memstick: Add support for JMicron JMB 385 and 390 controllers
Date: Tue,  7 Dec 2010 08:56:39 +0100
Message-Id: <1291708599-28026-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291708599-28026-1-git-send-email-tiwai@suse.de>
References: <1291708599-28026-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/memstick/host/jmb38x_ms.c |   17 +++++++++++++++--
 include/linux/pci_ids.h           |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 4ce8773..d89d925 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -765,6 +765,8 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 #define  PMOS0_SW_LED_POLARITY_ENABLE	0x80
 #define  PMOS0_ACTIVE_BITS (PMOS0_ENABLE | PMOS0_EN_OVERCURRENT_DEBOUNCE | \
 			    PMOS0_OVERCURRENT_LEVEL_2_4V)
+#define PCI_PMOS1_CONTROL		0xbd
+#define  PMOS1_ACTIVE_BITS		0x4a
 #define PCI_CLOCK_CTL			0xb9
 
 static int jmb38x_ms_pmos(struct pci_dev *pdev, int flag)
@@ -779,6 +781,16 @@ static int jmb38x_ms_pmos(struct pci_dev *pdev, int flag)
 	pci_write_config_byte(pdev, PCI_PMOS0_CONTROL, val);
 	dev_dbg(&pdev->dev, "JMB38x: set PMOS0 val 0x%x\n", val);
 
+	if (pci_resource_flags(pdev, 1)) {
+		pci_read_config_byte(pdev, PCI_PMOS1_CONTROL, &val);
+		if (flag)
+			val |= PMOS1_ACTIVE_BITS;
+		else
+			val &= ~PMOS1_ACTIVE_BITS;
+		pci_write_config_byte(pdev, PCI_PMOS1_CONTROL, val);
+		dev_dbg(&pdev->dev, "JMB38x: set PMOS1 val 0x%x\n", val);
+	}
+
 	pci_read_config_byte(pdev, PCI_CLOCK_CTL, &val);
 	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val & ~0x0f);
 	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val | 0x01);
@@ -1018,8 +1030,9 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 }
 
 static struct pci_device_id jmb38x_ms_id_tbl [] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB385_MS) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB390_MS) },
 	{ }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d369b53..d7df8e0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2362,6 +2362,8 @@
 #define PCI_DEVICE_ID_JMICRON_JMB38X_SD	0x2381
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MMC 0x2382
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MS	0x2383
+#define PCI_DEVICE_ID_JMICRON_JMB385_MS	0x2388
+#define PCI_DEVICE_ID_JMICRON_JMB390_MS	0x2393
 
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
-- 
1.7.3.1

