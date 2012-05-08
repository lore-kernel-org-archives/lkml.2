Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2EHJKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:10:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:10084 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2EHJJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:09:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140239559"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Xudong Hao <xudong.hao@linux.intel.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH] PCI: save/restore max Latency Value for device LTR
Thread-Topic: [PATCH] PCI: save/restore max Latency Value for device LTR
Thread-Index: AQHNK5ooOWnCSqF+oUGdV+xQne+W6Za9/2QAgAGc3NA=
Date: Tue, 8 May 2012 09:09:56 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDBDA97@SHSMSX102.ccr.corp.intel.com>
References: <20120506151156.GA13805@hp-xd.sh.intel.com>
 <CAErSpo5-iwY1X6GrKzEAHM=eZS1hs_6wNV1fB0GhLuo3YQcV-A@mail.gmail.com>
In-Reply-To: <CAErSpo5-iwY1X6GrKzEAHM=eZS1hs_6wNV1fB0GhLuo3YQcV-A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> >  }
> >
> 
> This doesn't make any sense to me.  "pos" is the offset of the PCI
> Express Capability (identifier 10h).  LTR is a separate extended
> capability (identifier 18h), so you at least have to look up its
> offset.
> 
Sorry paste a wrong patch...

How about this patch, not a formal patch.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 111569c..eced407 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -910,6 +910,45 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 		pci_write_config_word(dev, pos + PCI_EXP_SLTCTL2, cap[i++]);
 }
 
+static int pci_save_ltr_value(struct pci_dev *dev)
+{
+	int i = 0, pos;
+	struct pci_cap_saved_state *save_state;
+	u16 *cap;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
+	if (!pos)
+		return -ENOTSUPP;
+
+	save_state = pci_find_saved_cap(dev, PCI_EXT_CAP_ID_LTR);
+	if (!save_state) {
+		dev_err(&dev->dev, "buffer not found in %s\n", __func__);
+		return -ENOMEM;
+	}
+	cap = (u16 *)&save_state->cap.ltr_data[0];
+
+	pci_read_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT, &cap[i++]);
+	pci_read_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT, &cap[i++]);
+}
+
+static void pci_restore_ltr_value(struct pci_dev *dev)
+{
+	int i = 0, pos;
+	struct pci_cap_saved_state *save_state;
+	u16 *cap;
+
+	if (!pci_ltr_supported(dev))
+		return;
+
+	save_state = pci_find_saved_cap(dev, PCI_EXT_CAP_ID_LTR);
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
+	if (!save_state || !pos)
+		return;
+	cap = (u16 *)&save_state->cap.ltr_data[0];
+
+	pci_write_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT, cap[i++]);
+	pci_write_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT, cap[i++]);
+}
 
 static int pci_save_pcix_state(struct pci_dev *dev)
 {
@@ -964,6 +1003,10 @@ pci_save_state(struct pci_dev *dev)
 		return i;
 	if ((i = pci_save_pcix_state(dev)) != 0)
 		return i;
+
+	if (pci_ltr_supported(dev))
+		return pci_save_ltr_value(dev);
+
 	return 0;
 }
 
@@ -1032,6 +1075,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
 	pci_restore_iov_state(dev);
+	pci_restore_ltr_value(dev);
 
 	dev->state_saved = false;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e444f5b..6343aeb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -220,6 +220,7 @@ struct pci_cap_saved_data {
 	char cap_nr;
 	unsigned int size;
 	u32 data[0];
+	u32 ltr_data[0];
 };
 
 struct pci_cap_saved_state {
