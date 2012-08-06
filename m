Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2HFEtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:49:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40666 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2HFEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:49:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <501F4BCE.4060702@jp.fujitsu.com>
Date: Mon, 06 Aug 2012 13:45:02 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: ddutile@redhat.com
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, vgoyal@redhat.com,
        hbabu@us.ibm.com, ishii.hironobu@jp.fujitsu.com,
        martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <501BB4EF.7080909@jp.fujitsu.com> <501F4387.3010404@redhat.com>
In-Reply-To: <501F4387.3010404@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

(2012/08/06 13:09), Don Dutile wrote:
> On 08/03/2012 07:24 AM, Takao Indoh wrote:
>> Hi all,
>>
>> This patch adds kernel parameter "reset_pcie_devices" which resets PCIe
>> devices at boot time to address DMA problem on kdump with iommu. When
>> this parameter is specified, a hot reset is triggered on each PCIe root
>> port and downstream port to reset its downstream endpoint.
>>
>> Background:
>> A kdump problem about DMA has been discussed for a long time. That is,
>> when a kernel is switched to the kdump kernel DMA derived from first
>> kernel affects second kernel. Recently this problem surfaces when iommu
>> is used for PCI passthrough on KVM guest. In the case of the machine I
>> use, when intel_iommu=on is specified, DMAR error is detected in kdump
>> kernel and PCI SERR is also detected. Finally kdump fails because some
>> devices does not work correctly.
>>
>> The root cause is that ongoing DMA from first kernel causes DMAR fault
>> because page table of DMAR is initialized while kdump kernel is booting
>> up. Therefore to address this problem DMA needs to be stopped before DMAR
>> is initialized at kdump kernel boot time. By this patch, PCIe devices
>> are reset by hot reset and its DMA is stopped when reset_pcie_devices is
>> specified. One problem of this solution is that VGA is reset and the
>> monitor blacks out when the link between the port and VGA controller was
>> reset. So this patch does not reset the port whose child endpoint is VGA
>> device.
>>
>> Any comments would be appreciated.
>>
>> Signed-off-by: Takao Indoh<indou.takao@jp.fujitsu.com>
>> ---
> Have you considered something less disruptive such as clearing the
> Master Enable in each endpoint's PCI Command Register ?
> That should prevent DMA transactions from endpoints during the kdump and
> kexec, and when the driver for the device gets reconfigured,
> Master Enable will be set back on, but after the driver has had the
> opportunity to do a device-specific reset.

Yes, that is what I tried first. First of all I found this thread.

[PATCH] Disable Bus Master on PCI device shutdown
https://lkml.org/lkml/2012/6/6/278
original patch: http://marc.info/?l=kexec&m=133546519231295&w=2

And I thought ongoing DMA could be stopped by disabling it on kdump
kernel boot, but DMAR error is still found after adding quirk below.

In this thread, AER link reset was also suggested, so I got the
idea to reset root port and downstream port.

Thanks,
Takao Indoh

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5155317..0e8b41a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -31,6 +31,22 @@
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
+static void test_pci_device_reset(struct pci_dev *dev)
+{
+	u16 pci_command;
+
+	if (!reset_devices)
+		return;
+
+	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
+	if (pci_command & PCI_COMMAND_MASTER) {
+		dev_info(&dev->dev, "DEBUG: Disable Bus Master bit\n");
+		pci_command &= ~PCI_COMMAND_MASTER;
+		pci_write_config_word(dev, PCI_COMMAND, pci_command);
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, test_pci_device_reset);
+
 /*
  * Decoding should be disabled for a PCI device during BAR sizing to avoid
  * conflict. But doing so may cause problems on host bridge and perhaps other

