Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0LGH5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:57:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab0LGH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:57:06 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        Aries Lee <arieslee@jmicron.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 2/3] memstick: Set PMOS values propery for JMicron 38x controllers
Date: Tue,  7 Dec 2010 08:56:38 +0100
Message-Id: <1291708599-28026-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291708599-28026-1-git-send-email-tiwai@suse.de>
References: <1291708599-28026-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function jmb38x_ms_pmos() to enable / disable PMOS setups for
JMicron 38x controllers.

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/memstick/host/jmb38x_ms.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index c90ba50..4ce8773 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -758,6 +758,35 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 	return 0;
 }
 
+#define PCI_PMOS0_CONTROL		0xae
+#define  PMOS0_ENABLE			0x01
+#define  PMOS0_OVERCURRENT_LEVEL_2_4V	0x06
+#define  PMOS0_EN_OVERCURRENT_DEBOUNCE	0x40
+#define  PMOS0_SW_LED_POLARITY_ENABLE	0x80
+#define  PMOS0_ACTIVE_BITS (PMOS0_ENABLE | PMOS0_EN_OVERCURRENT_DEBOUNCE | \
+			    PMOS0_OVERCURRENT_LEVEL_2_4V)
+#define PCI_CLOCK_CTL			0xb9
+
+static int jmb38x_ms_pmos(struct pci_dev *pdev, int flag)
+{
+	unsigned char val;
+
+	pci_read_config_byte(pdev, PCI_PMOS0_CONTROL, &val);
+	if (flag)
+		val |= PMOS0_ACTIVE_BITS;
+	else
+		val &= ~PMOS0_ACTIVE_BITS;
+	pci_write_config_byte(pdev, PCI_PMOS0_CONTROL, val);
+	dev_dbg(&pdev->dev, "JMB38x: set PMOS0 val 0x%x\n", val);
+
+	pci_read_config_byte(pdev, PCI_CLOCK_CTL, &val);
+	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val & ~0x0f);
+	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val | 0x01);
+	dev_dbg(&pdev->dev, "Clock Control by PCI config is disabled!\n");
+
+        return 0;
+}
+
 #ifdef CONFIG_PM
 
 static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
@@ -790,8 +819,7 @@ static int jmb38x_ms_resume(struct pci_dev *dev)
 		return rc;
 	pci_set_master(dev);
 
-	pci_read_config_dword(dev, 0xac, &rc);
-	pci_write_config_dword(dev, 0xac, rc | 0x00470000);
+	jmb38x_ms_pmos(dev, 1);
 
 	for (rc = 0; rc < jm->host_cnt; ++rc) {
 		if (!jm->hosts[rc])
@@ -900,8 +928,7 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 		goto err_out;
 	}
 
-	pci_read_config_dword(pdev, 0xac, &rc);
-	pci_write_config_dword(pdev, 0xac, rc | 0x00470000);
+	jmb38x_ms_pmos(pdev, 1);
 
 	cnt = jmb38x_ms_count_slots(pdev);
 	if (!cnt) {
@@ -982,6 +1009,8 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 		jmb38x_ms_free_host(jm->hosts[cnt]);
 	}
 
+	jmb38x_ms_pmos(dev, 0);
+
 	pci_set_drvdata(dev, NULL);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-- 
1.7.3.1

