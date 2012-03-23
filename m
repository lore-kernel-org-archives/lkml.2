Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2CWRU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:20:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54701 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2CWRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:20:55 -0400
Date: Fri, 23 Mar 2012 17:20:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Holland <bandidoirlandes@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop
 3.3.0-030300-generic
Message-ID: <20120323172053.GA24571@srcf.ucam.org>
References: <CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
 <CADLC3L29fiago4Nkxbb3Ey8iS3GGp_G_NP77esdAqQVYHFLBLw@mail.gmail.com>
 <CAMfrEMYUWG39Z-y8sU+7eDdePQWg9U5kow_ipZANwD-s=BOh_A@mail.gmail.com>
 <CAMfrEMZ27UWKTASUFaEG1KLysRgAukVruOx2Q-s-FXzOQJe_zA@mail.gmail.com>
 <CAMfrEMa65+X1zA5fQ7R+Zt8tGjf9XtcHnPodiJgy+9bwO-nFkg@mail.gmail.com>
 <CADLC3L2XSJoPtt3g+GAc=JvMz3OjFewnt-BPBPyrVG+ZcxvW4w@mail.gmail.com>
 <20120323162930.GB23376@srcf.ucam.org>
 <CAMfrEMb9R8V=VagAzi1DJWXrSOJ-dSptdt9aQX=_igjBXF1USw@mail.gmail.com>
 <20120323165118.GA24014@srcf.ucam.org>
 <CAMfrEMa6EAsLMMvG-Yq03E0Qhc7jdk2WH5fvQUB16W-5=Qgfbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMfrEMa6EAsLMMvG-Yq03E0Qhc7jdk2WH5fvQUB16W-5=Qgfbw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this is very odd - ASPM is disabled in both cases. The only thing I 
can think of here is that the hardware dislikes us writing to the 
registers? Can you test this patch on top of the broken kernel?

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 24f049e..04eb680 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -185,6 +185,7 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 	int ppos, cpos, same_clock = 1;
 	u16 reg16, parent_reg, child_reg[8];
 	unsigned long start_jiffies;
+	bool retrain = false;
 	struct pci_dev *child, *parent = link->pdev;
 	struct pci_bus *linkbus = parent->subordinate;
 	/*
@@ -215,7 +216,10 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 			reg16 |= PCI_EXP_LNKCTL_CCC;
 		else
 			reg16 &= ~PCI_EXP_LNKCTL_CCC;
-		pci_write_config_word(child, cpos + PCI_EXP_LNKCTL, reg16);
+		if (reg16 != child_reg[PCI_FUNC(child->devfn)]) {
+			retrain = true;
+			pci_write_config_word(child, cpos + PCI_EXP_LNKCTL, reg16);
+		}
 	}
 
 	/* Configure upstream component */
@@ -225,9 +229,15 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 		reg16 |= PCI_EXP_LNKCTL_CCC;
 	else
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
-	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+	if (reg16 != parent_reg) {
+		retrain = true;
+		pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+	}
 
 	/* Retrain link */
+	if (!retrain)
+		return;
+
 	reg16 |= PCI_EXP_LNKCTL_RL;
 	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
 
@@ -436,13 +446,16 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 
 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)
 {
-	u16 reg16;
+	u16 reg16, orig_reg16;
 	int pos = pci_pcie_cap(pdev);
 
 	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	orig_reg16 = reg16;
 	reg16 &= ~0x3;
 	reg16 |= val;
-	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+
+	if (reg16 != orig_reg16)
+		pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 }
 
 static void pcie_config_aspm_link(struct pcie_link_state *link, u32 state)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
