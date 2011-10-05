Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997Ab1JEQ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:27:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934476Ab1JEQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:27:15 -0400
Date: Wed, 5 Oct 2011 11:27:01 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@sleepy
To: Josh Boyer <jwboyer@redhat.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
In-Reply-To: <20111005154449.GA2479@zod.bos.redhat.com>
Message-ID: <alpine.DEB.2.02.1110051059550.3478@sleepy>
References: <20111005154449.GA2479@zod.bos.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Josh Boyer wrote:

> Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
> base frequency.  However, the quirk first checks to see if the proprietary
> MMC controller is disabled, and returns if so.  On some devices, such as the
> Lenovo X220, the MMC controller is already disabled by firmware it seems,

It is possible that the newer firmware from Lenovo disables the MMC 
controller. When the patch was done, these laptops had just been 
announced, so they had a very early version of the firmware (ver 1.02 
iirc).

> but the frequency change is still needed so sdhci-pci can talk to the cards.
> Since the MMC controller is disabled, the frequency fixup was never being run
> on these machines.
>
> This moves the e823 check above the MMC controller check so that it always
> gets run.
>
> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=722509
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
> drivers/pci/quirks.c |   28 ++++++++++++++--------------
> 1 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 1196f61..cec4629 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2745,20 +2745,6 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
> 	/* disable must be done via function #0 */
> 	if (PCI_FUNC(dev->devfn))
> 		return;
> -
> -	pci_read_config_byte(dev, 0xCB, &disable);
> -
> -	if (disable & 0x02)
> -		return;
> -
> -	pci_read_config_byte(dev, 0xCA, &write_enable);
> -	pci_write_config_byte(dev, 0xCA, 0x57);
> -	pci_write_config_byte(dev, 0xCB, disable | 0x02);
> -	pci_write_config_byte(dev, 0xCA, write_enable);
> -
> -	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
> -	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
> -
> 	/*
> 	 * RICOH 0xe823 SD/MMC card reader fails to recognize
> 	 * certain types of SD/MMC cards. Lowering the SD base
> @@ -2781,6 +2767,20 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
>
> 		dev_notice(&dev->dev, "MMC controller base frequency changed to 50Mhz.\n");
> 	}
> +
> +	pci_read_config_byte(dev, 0xCB, &disable);
> +
> +	if (disable & 0x02)
> +		return;
> +
> +	pci_read_config_byte(dev, 0xCA, &write_enable);
> +	pci_write_config_byte(dev, 0xCA, 0x57);
> +	pci_write_config_byte(dev, 0xCB, disable | 0x02);
> +	pci_write_config_byte(dev, 0xCA, write_enable);
> +
> +	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
> +	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
> +
> }
> DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
> DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
> -- 
> 1.7.6.4
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
