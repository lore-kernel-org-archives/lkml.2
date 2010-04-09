Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab0DIAKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:10:33 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32075 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220Ab0DIAK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:10:29 -0400
Message-ID: <4BBE6FDB.9010805@oracle.com>
Date: Thu, 08 Apr 2010 17:07:55 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Yinghai <yinghai.lu@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org> <1270753107-15881-5-git-send-email-yinghai@kernel.org> <adawrwhwyiq.fsf@roland-alpha.cisco.com> <4BBE4209.3080900@oracle.com> <20100408232437.GG3168@sequoia.sous-sol.org>
In-Reply-To: <20100408232437.GG3168@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBE7045.009E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 04:24 PM, Chris Wright wrote:
> * Yinghai (yinghai.lu@oracle.com) wrote:
>> --- linux-2.6.orig/drivers/pci/dmar.c
>> +++ linux-2.6/drivers/pci/dmar.c
>> @@ -534,6 +534,8 @@ dmar_find_matched_drhd_unit(struct pci_d
>>  	struct dmar_drhd_unit *dmaru = NULL;
>>  	struct acpi_dmar_hardware_unit *drhd;
>>  
>> +	dev = pci_physfn(dev);
>> +
> 
> Yeah, we typically don't have enough VF's to wrap bus numbers, or we're
> under a catchall IOMMU.  In the catchall case both vf->bus and vf->pf->bus
> will have the same domain (segment) regardless of whether we have large
> VF count or big offset/stride.  So, I suppose this could be done inside
> of dmar_pci_device_match().
> 
> Otherwise, I think you'd want to add the same thing to
> dmar_find_matched_atsr_unit() since it's the same device scopes there.

please check

Subject: [PATCH] pci/dmar/sriov: use physfn to search drhd for VF

When virtfn is used, we should use physfn to find correct drhd

-v2: add pci_physfn() Suggested by Roland Dreier <rdreier@cisco.com>
     do can remove ifdef in dmar.c
-v3: Chris pointed out we need that for dma_find_matched_atsr_unit too
     also change dmar_pci_device_match() static

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Roland Dreier <rdreier@cisco.com>

---
 drivers/pci/dmar.c  |    6 +++++-
 include/linux/pci.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -313,6 +313,8 @@ int dmar_find_matched_atsr_unit(struct p
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
+	dev = pci_physfn(dev);
+
 	list_for_each_entry(atsru, &dmar_atsr_units, list) {
 		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
 		if (atsr->segment == pci_domain_nr(dev->bus))
@@ -511,7 +513,7 @@ parse_dmar_table(void)
 	return ret;
 }
 
-int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
+static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
 			  struct pci_dev *dev)
 {
 	int index;
@@ -534,6 +536,8 @@ dmar_find_matched_drhd_unit(struct pci_d
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
