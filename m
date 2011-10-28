Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1J1MHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:07:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36597 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1J1MHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:07:15 -0400
Message-ID: <4EAA9AD3.7040902@oracle.com>
Date: Fri, 28 Oct 2011 17:36:43 +0530
From: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop> <4E92DEC1.5050806@oracle.com> <alpine.DEB.2.00.1110131525320.3519@kaball-desktop> <4E9D8495.4010105@oracle.com> <alpine.DEB.2.00.1110271411450.3519@kaball-desktop> <4EA96BEA.7060004@oracle.com> <alpine.DEB.2.00.1110271600000.3519@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1110271600000.3519@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EAA9AEE.0106,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/27/2011 08:31 PM, Stefano Stabellini wrote:
> On Thu, 27 Oct 2011, Ajaykumar Hotchandani wrote:
>>> BTW I am OK with your patch.
>> Should we revert 47e9037ac16637cd7f12b8790ea7ce6680e42168 (your changes
>> in register_slot() )
>> I think, after this change, it's not needed. Or, am I missing some scenario?
>>
> I think you are right, 47e9037ac16637cd7f12b8790ea7ce6680e42168 is not
> needed anymore, so I am OK with reverting it.

Thanks, following is updated patch.

[PATCH -v2] PCI: Set device power state to PCI_D0 for device without 
native PM support

During test of one IB card with guest VM, found that, msi is not 
initialized properly.

It turns out __write_msi_msg will do nothing if device current_state is 
not PCI_D0.
And, that pci device does not have pm_cap in guest VM.

There is an error in setting of power state to PCI_D0 in 
pci_enable_device(), but error is not returned for this.
Following is code flow:
pci_enable_device() -->  __pci_enable_device_flags() -->  
do_pci_enable_device() -->  pci_set_power_state() -->  
__pci_start_power_transition()
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

Here, from platform_pci_set_power_state(), acpi_pci_set_power_state() is 
getting called and that is failing with ENODEV because of following 
condition:
         if (!handle || ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0",&tmp)))
                 return -ENODEV;

Because of that, pci_update_current_state() is not getting called.

With this patch, if device power state can not be set via 
platform_pci_set_power_state and that device does not have native pm 
support, then PCI device power state will be set to PCI_D0.

-v2: This also reverts 47e9037ac16637cd7f12b8790ea7ce6680e42168, as it's 
not needed after this change.

Signed-off-by: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
---
  drivers/pci/hotplug/acpiphp_glue.c |    1 -
  drivers/pci/pci.c                  |    3 +++
  2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c 
b/drivers/pci/hotplug/acpiphp_glue.c
index 2202857..11431c1 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -212,7 +212,6 @@ register_slot(acpi_handle handle, u32 lvl, void 
*context, void **rv)

         pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
         if (pdev) {
-               pdev->current_state = PCI_D0;
                 slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
                 pci_dev_put(pdev);
         }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e9651f0..6866937 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -664,6 +664,9 @@ static int pci_platform_power_transition(struct 
pci_dev *dev, pci_power_t state)
                 error = platform_pci_set_power_state(dev, state);
                 if (!error)
                         pci_update_current_state(dev, state);
+               /* Fall back to PCI_D0 if native PM is not supported */
+               if (!dev->pm_cap)
+                       dev->current_state = PCI_D0;
         } else {
                 error = -ENODEV;
                 /* Fall back to PCI_D0 if native PM is not supported */
-- 
1.7.5.1

