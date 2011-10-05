Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995Ab1JETjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:39:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab1JETjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:39:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without native PM support
Date: Wed, 5 Oct 2011 21:41:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4E8C40A8.6080205@oracle.com>
In-Reply-To: <4E8C40A8.6080205@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110052141.37618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, October 05, 2011, Ajaykumar Hotchandani wrote:
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
> ---
>   drivers/pci/pci.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index e9651f0..ca8c82d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -664,6 +664,9 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
>                  error = platform_pci_set_power_state(dev, state);
>                  if (!error)
>                          pci_update_current_state(dev, state);
> +               /* Fall back to PCI_D0 if native PM is not supported */
> +               else if (!dev->pm_cap)
> +                       dev->current_state = PCI_D0;
>          } else {
>                  error = -ENODEV;
>                  /* Fall back to PCI_D0 if native PM is not supported */
> 

I have some vague memories that we tried that and it broke something.

How thoroughly has it been tested?

Rafael
