Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab1JFKj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:39:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:51085 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab1JFKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:39:56 -0400
X-IronPort-AV: E=Sophos;i="4.68,495,1312156800"; 
   d="scan'208";a="8246546"
Date: Thu, 6 Oct 2011 11:39:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
In-Reply-To: <4E8C40A8.6080205@oracle.com>
Message-ID: <alpine.DEB.2.00.1110061137120.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Ajaykumar Hotchandani wrote:
> During test of one IB card with guest VM, found that, msi is not initialized properly.
> 
> It turns out __write_msi_msg will do nothing if device current_state is not PCI_D0.
> And, that pci device does not have pm_cap in guest VM.
> 
> There is an error in setting of power state to PCI_D0 in pci_enable_device(), but error is not returned for this.
> Following is code flow:
> pci_enable_device() -->  __pci_enable_device_flags() -->  do_pci_enable_device() -->  pci_set_power_state() -->  __pci_start_power_transition()
> We have following condition inside __pci_start_power_transition():
>          if (platform_pci_power_manageable(dev)) {
>                  error = platform_pci_set_power_state(dev, state);
>                  if (!error)
>                          pci_update_current_state(dev, state);
>          } else {
>                  error = -ENODEV;
>                  /* Fall back to PCI_D0 if native PM is not supported */
>                  if (!dev->pm_cap)
>                          dev->current_state = PCI_D0;
>          }
> 
> Here, from platform_pci_set_power_state(), acpi_pci_set_power_state() is getting called and that is failing with ENODEV because of following condition:
>          if (!handle || ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0",&tmp)))
>                  return -ENODEV;
> 
> Because of that, pci_update_current_state() is not getting called.
> 
> With this patch, if device power state can not be set via platform_pci_set_power_state and that device does not have native pm support, then PCI device power state will be set to PCI_D0.
> 
> Signed-off-by: Ajaykumar Hotchandani<ajaykumar.hotchandani@oracle.com>
> Signed-off-by: Yinghai Lu<yinghai.lu@oracle.com>

I had the same issue and sent a patch a while ago to fix it, adding

current_state = PCI_D0 in acpiphp_glue.c:register_slot

it is strange that this does not work for you:

http://marc.info/?l=linux-kernel&m=129891002722845&w=2
