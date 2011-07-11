Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab1GKVxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:53:32 -0400
Received: from void.printf.net ([89.145.121.20]:35730 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1GKVxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:53:30 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<1310419715-13254-2-git-send-email-manoj.iyer@canonical.com>
Date: Mon, 11 Jul 2011 17:53:15 -0400
In-Reply-To: <1310419715-13254-2-git-send-email-manoj.iyer@canonical.com>
	(Manoj Iyer's message of "Mon, 11 Jul 2011 16:28:35 -0500")
Message-ID: <m2wrfofpro.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj, adding linux-mmc@,

On Mon, Jul 11 2011, Manoj Iyer wrote:
> Ricoh 1180:e823 does not recognize certain types of SD/MMC cards.
> Lowering the SD base clock frequency from 200Mhz to 50Mhz fixes
> this issue. This solution was suggest by Koji Matsumuro, Ricoh
> Company,Ltd.
>
> BugLink: http://launchpad.net/bugs/773524
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
> Cc: Koji Matsumuro <matsumur@nts.ricoh.co.jp>
> ---
>  drivers/pci/quirks.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 02145e9..fe5bffa 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2758,6 +2758,30 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
>  
>  	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
>  	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
> +
> +	/* 
> +	 * RICOH 0xe823 SD/MMC card reader fails to recognize 
> +	 * certain types of SD/MMC cards. Lowering the SD base
> +	 * clock frequency from 200Mhz to 50Mhz fixes this issue.
> +	 *
> +	 * 0x150 - SD2.0 mode enable for changing base clock 
> +	 *	   frequency to 50Mhz
> +	 * 0xe1  - Base clock frequency
> +	 * 0x32  - 50Mhz new clock frequency
> +	 * 0xf9  - Key register for 0x150
> +	 * 0xfc  - key register for 0xe1
> +	 */
> +	if (dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
> +		pci_write_config_byte(dev, 0xf9, 0xfc);
> +		pci_write_config_byte(dev, 0x150, 0x10);
> +		pci_write_config_byte(dev, 0xf9, 0x00);
> +		pci_write_config_byte(dev, 0xfc, 0x01);
> +		pci_write_config_byte(dev, 0xe1, 0x32);
> +		pci_write_config_byte(dev, 0xfc, 0x00);
> +
> +		dev_notice(&dev->dev, "Controller base frequency changed to 50Mhz)\n");

There's an erroneous ")" in this string; I'll replace it with a "." if
this patch goes in via my tree.  Also, let's make it "MMC controller"
instead of just "Controller".

> +	}
> +
>  }
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);

Have you checked to see how SD I/O performance differs after this change?

(If this is significant, perhaps we want to try lowering the frequency
only after a card starts returning errors, since some cards work fine
at the higher frequency.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
