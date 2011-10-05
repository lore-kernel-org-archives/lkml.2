Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab1JELeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 07:34:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:60084 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397Ab1JELeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 07:34:11 -0400
Message-ID: <4E8C40A8.6080205@oracle.com>
Date: Wed, 05 Oct 2011 17:04:00 +0530
From: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E8C40B2.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During test of one IB card with guest VM, found that, msi is not initialized properly.

It turns out __write_msi_msg will do nothing if device current_state is not PCI_D0.
And, that pci device does not have pm_cap in guest VM.

There is an error in setting of power state to PCI_D0 in pci_enable_device(), but error is not returned for this.
Following is code flow:
pci_enable_device() -->  __pci_enable_device_flags() -->  do_pci_enable_device() -->  pci_set_power_state() -->  __pci_start_power_transition()
We have following condition inside __pci_start_power_transition():
         if (platform_pci_power_manageable(dev)) {
                 error = platform_pci_set_power_state(dev, state);
                 if (!error)
                         pci_update_current_state(dev, state);
         } else {
                 error = -ENODEV;
                 /* Fall back to PCI_D0 if native PM is not supported */
                 if (!dev->pm_cap)
                         dev->current_state = PCI_D0;
         }

Here, from platform_pci_set_power_state(), acpi_pci_set_power_state() is getting called and that is failing with ENODEV because of following condition:
         if (!handle || ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0",&tmp)))
                 return -ENODEV;

Because of that, pci_update_current_state() is not getting called.

With this patch, if device power state can not be set via platform_pci_set_power_state and that device does not have native pm support, then PCI device power state will be set to PCI_D0.

Signed-off-by: Ajaykumar Hotchandani<ajaykumar.hotchandani@oracle.com>
Signed-off-by: Yinghai Lu<yinghai.lu@oracle.com>
---
  drivers/pci/pci.c |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e9651f0..ca8c82d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -664,6 +664,9 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
                 error = platform_pci_set_power_state(dev, state);
                 if (!error)
                         pci_update_current_state(dev, state);
+               /* Fall back to PCI_D0 if native PM is not supported */
+               else if (!dev->pm_cap)
+                       dev->current_state = PCI_D0;
         } else {
                 error = -ENODEV;
                 /* Fall back to PCI_D0 if native PM is not supported */
-- 
1.7.5.1

