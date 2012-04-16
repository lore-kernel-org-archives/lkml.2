Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2DPLaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:30:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2DPLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:30:06 -0400
Message-ID: <4F8C025A.6020002@mvista.com>
Date: Mon, 16 Apr 2012 15:28:26 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] UBUNTU: SAUCE: ata_piix: defer disks to the Hyper-V
 drivers by default
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk> <1334575229-7493-1-git-send-email-apw@canonical.com> <1334575229-7493-3-git-send-email-apw@canonical.com>
In-Reply-To: <1334575229-7493-3-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-04-2012 15:20, Andy Whitcroft wrote:

> When we are hosted on a Microsoft Hyper-V hypervisor the guest disks
> are exposed both via the Hyper-V paravirtualised drivers and via an
> emulated SATA disk drive.  In this case we want to use the paravirtualised
> drivers if we can as they are much more efficient.  Note that the Hyper-V
> paravirtualised drivers only expose the virtual hard disk devices, the
> CDROM/DVD devices must still be enumerated.

> Mark the host controller ATA_HOST_IGNORE_ATA to prevent enumeration of
> disk devices.

> BugLink: http://bugs.launchpad.net/bugs/929545
> BugLink: http://bugs.launchpad.net/bugs/942316
> Signed-off-by: Andy Whitcroft<apw@canonical.com>
> ---
>   drivers/ata/ata_piix.c |   38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)

> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 68013f9..05e0ffa 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1552,6 +1552,41 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
>   	return false;
>   }
>
> +static int prefer_ms_hyperv = 1;
> +module_param(prefer_ms_hyperv, int, 0);
> +
> +static void piix_ignore_devices_quirk(struct ata_host *host)
> +{
> +	static const struct dmi_system_id ignore_devices[] = {
> +		{
> +			/* On Hyper-V hypervisors the disks are exposed on
> +			 * both the emulated SATA controller and on the
> +			 * paravirtualised drivers.  The CD/DVD devices
> +			 * are only exposed on the emulated controller.
> +			 * Request we * ignore ATA devices on this host.

    '*' not needed here.

> +			 */
> +			.ident = "Hyper-V Virtual Machine",
> +			.matches = {
> +				DMI_MATCH(DMI_SYS_VENDOR,
> +						"Microsoft Corporation"),
> +				DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> +			},
> +			.driver_data = (void *)ATA_HOST_IGNORE_ATA,
> +		},
> +
> +		{ }	/* terminate list */
> +	};
> +	const struct dmi_system_id *dmi = dmi_first_match(ignore_devices);
> +
> +	if (dmi) {
> +		unsigned long flags = (unsigned long)dmi->driver_data;
> +
> +		host->flags |= flags;
> +		dev_info(host->dev, "%s detected, device ignore set %08lx\n",

    dev_dbg()?

MBR, Sergei
