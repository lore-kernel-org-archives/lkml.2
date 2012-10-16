Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2JPVyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:54:14 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:39996 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2JPVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:12 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:12 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>,
        Steven Hsieh <sshsieh@broadcom.com>
Subject: [PATCH 5/5] IPMI: Detect register spacing on PCI interfaces
Date: Tue, 16 Oct 2012 15:53:40 -0500
Message-id: <1350420820-7156-6-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1350420820-7156-1-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The IPMI spec defines a way to detect register spacing for PCI interfaces,
so implement it.

Signed-off-by: Steven Hsieh <sshsieh@broadcom.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 83f85cf..32a6c7e 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2424,6 +2424,38 @@ static void ipmi_pci_cleanup(struct smi_info *info)
 	pci_disable_device(pdev);
 }
 
+static int __devinit ipmi_pci_probe_regspacing(struct smi_info *info)
+{
+	if (info->si_type == SI_KCS) {
+		unsigned char	status;
+		int		regspacing;
+
+		info->io.regsize = DEFAULT_REGSIZE;
+		info->io.regshift = 0;
+		info->io_size = 2;
+		info->handlers = &kcs_smi_handlers;
+
+		/* detect 1, 4, 16byte spacing */
+		for (regspacing = DEFAULT_REGSPACING; regspacing <= 16;) {
+			info->io.regspacing = regspacing;
+			if (info->io_setup(info)) {
+				dev_err(info->dev,
+					"Could not setup I/O space\n");
+				return DEFAULT_REGSPACING;
+			}
+			/* write invalid cmd */
+			info->io.outputb(&info->io, 1, 0x10);
+			/* read status back */
+			status = info->io.inputb(&info->io, 1);
+			info->io_cleanup(info);
+			if (status)
+				return regspacing;
+			regspacing *= 4;
+		}
+	}
+	return DEFAULT_REGSPACING;
+}
+
 static int __devinit ipmi_pci_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
@@ -2476,8 +2508,8 @@ static int __devinit ipmi_pci_probe(struct pci_dev *pdev,
 	}
 	info->io.addr_data = pci_resource_start(pdev, 0);
 
-	info->io.regspacing = DEFAULT_REGSPACING;
-	info->io.regsize = DEFAULT_REGSPACING;
+	info->io.regspacing = ipmi_pci_probe_regspacing(info);
+	info->io.regsize = DEFAULT_REGSIZE;
 	info->io.regshift = 0;
 
 	info->irq = pdev->irq;
-- 
1.7.4.1

