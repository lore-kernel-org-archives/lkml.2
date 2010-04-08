Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab0DHUyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:54:12 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:20203 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0DHUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:54:09 -0400
Message-ID: <4BBE4209.3080900@oracle.com>
Date: Thu, 08 Apr 2010 13:52:25 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>	<1270753107-15881-5-git-send-email-yinghai@kernel.org> <adawrwhwyiq.fsf@roland-alpha.cisco.com>
In-Reply-To: <adawrwhwyiq.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBE425A.00A1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

Subject: [PATCH] pci/dmar/sriov: use physfn to search drhd for VF

When virtfn is used, we should use physfn to find correct drhd

-v2: add pci_physfn() Suggested by Roland Dreier <rdreier@cisco.com>
     do can remove ifdef in dmar.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/dmar.c  |    2 ++
 include/linux/pci.h |   10 ++++++++++
 2 files changed, 12 insertions(+)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -534,6 +534,8 @@ dmar_find_matched_drhd_unit(struct pci_d
 	struct dmar_drhd_unit *dmaru = NULL;
 	struct acpi_dmar_hardware_unit *drhd;
 
+	dev = pci_physfn(dev);
+
 	list_for_each_entry(dmaru, &dmar_drhd_units, list) {
 		drhd = container_of(dmaru->hdr,
 				    struct acpi_dmar_hardware_unit,
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -334,6 +334,16 @@ struct pci_dev {
 #endif
 };
 
+static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
+{
+#ifdef CONFIG_PCI_IOV
+	if (dev->is_virtfn)
+		dev = dev->physfn;
+#endif
+
+	return dev;
+}
+
 extern struct pci_dev *alloc_pci_dev(void);
 
 #define pci_dev_b(n) list_entry(n, struct pci_dev, bus_list)
