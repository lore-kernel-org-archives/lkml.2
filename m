Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965952Ab2DLUDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:03:49 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39525 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965939Ab2DLUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:03:45 -0400
Message-ID: <4F87351E.9040905@pobox.com>
Date: Thu, 12 Apr 2012 16:03:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised
 drivers by default
References: <1333042130-9634-1-git-send-email-apw@canonical.com>
In-Reply-To: <1333042130-9634-1-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 01:28 PM, Andy Whitcroft wrote:
> When we are hosted on a Hyper-V hypervisor the guest disks are exposed
> both via the Hyper-V paravirtualised drivers and via an emulated SATA disk
> controller.  We want to use the paravirtualised drivers where possible as
> they are much more performant.  The Hyper-V paravirtualised drivers only
> expose the virtual hard disk devices, the CDROM/DVD devices must still
> be enumerated on the virtualised SATA controller.  As we have no control
> over kernel probe order for these two drivers especially when one driver
> is builtin to the kernel and the other a module, we need to prevent the
> ata_piix driver from claiming the disks devices by default when running
> on a Hyper-V hypervisor.
>
> When enumerating the drives look at the aquired device ID and if it
> appears to be a disk device then report it as disconnected.  Limit this
> behaviour to when we have detected a Hyper-V hypervisor.  Finally allow
> this behaviour to be overriden via a new module parameter.
>
> BugLink: http://bugs.launchpad.net/bugs/929545
> BugLink: http://bugs.launchpad.net/bugs/942316
> Signed-off-by: Andy Whitcroft<apw@canonical.com>
> ---
>   drivers/ata/ata_piix.c |   29 +++++++++++++++++++++++++++++
>   1 files changed, 29 insertions(+), 0 deletions(-)
>
>      This was discovered when doing some boot testing on a Hyper-V
>      host.  Performance was found to be bad as out builtin ata_piix
>      driver was grabbing the disks.  I am Cc:ing a couple of the
>      Microsoft people who worked on the HV driver set as well.
>
>      Note that the device id data is converted from device to host
>      order in the caller which makes examining the data problematic.
>      As this code only make sense on X86 and we know we are in
>      matching order we can access the data without first fixing it.
>      Alternativly we could add a new callback from the ata core
>      after the code has been fixed for validation.
>
>      Comments?
>
>      -apw
>
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 68013f9..64895f8 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -94,6 +94,9 @@
>   #include<scsi/scsi_host.h>
>   #include<linux/libata.h>
>   #include<linux/dmi.h>
> +#ifdef CONFIG_X86
> +#include<asm/hypervisor.h>
> +#endif
>
>   #define DRV_NAME	"ata_piix"
>   #define DRV_VERSION	"2.13"
> @@ -188,6 +191,29 @@ static int piix_pci_device_resume(struct pci_dev *pdev);
>
>   static unsigned int in_module_init = 1;
>
> +static int prefer_ms_hyperv = 1;
> +
> +unsigned int ata_piix_read_id(struct ata_device *dev,
> +					struct ata_taskfile *tf, u16 *id)
> +{
> +	int ret = ata_do_dev_read_id(dev, tf, id);
> +
> +#ifdef CONFIG_X86
> +	/* XXX: note that the device id is in little-endian order, the caller
> +	 * will shift it to host order, but we are working with little-endian.
> +	 * As this is _only_ used on x86 we can actually directly access it
> +	 * as host is also little-endian.
> +	 */
> +	if (!ret&&  prefer_ms_hyperv&&  x86_hyper ==&x86_hyper_ms_hyperv&&
> +							ata_id_is_ata(id)) {
> +		ata_dev_printk(dev, KERN_WARNING, "ATA disk ignored deferring to Hyper-V paravirt driver\n");
> +
> +		return AC_ERR_DEV|AC_ERR_NODEV_HINT;
> +	}
> +#endif
> +	return ret;
> +}
> +
>   static const struct pci_device_id piix_pci_tbl[] = {
>   	/* Intel PIIX3 for the 430HX etc */
>   	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
> @@ -359,6 +385,7 @@ static struct ata_port_operations piix_pata_ops = {
>   	.set_piomode		= piix_set_piomode,
>   	.set_dmamode		= piix_set_dmamode,
>   	.prereset		= piix_pata_prereset,
> +	.read_id		= ata_piix_read_id,

Platform quirks should be handled in piix_init_one, not with this 
haphazard read_id callback.  If prefer_ms_hyperv && hypervisor-detected, 
then set ATA_HOST_IGNORE_ATA flag or similar.

	Jeff



