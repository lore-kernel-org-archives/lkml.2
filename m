Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1DUQg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:36:28 -0400
Received: from void.printf.net ([89.145.121.20]:60752 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1DUQg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:36:27 -0400
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Aries Lee <arieslee@jmicron.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Fix read-only detection with JMicron 388 chip
References: <s5hoc3zd27i.wl%tiwai@suse.de>
Date: Thu, 21 Apr 2011 12:40:26 -0400
In-Reply-To: <s5hoc3zd27i.wl%tiwai@suse.de> (Takashi Iwai's message of "Thu,
	21 Apr 2011 18:00:17 +0200")
Message-ID: <m339lba77p.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Thu, Apr 21 2011, Takashi Iwai wrote:
> On HP laptops with JMicron 388 chip, the write-locked SD card isn't
> detected correctly as read-only in many cases.  This is because the
> PRESENT_STATE register becomes unsable just after plugging, and it
> returns the WRITE_PROTECT bit wrongly at the first read.
>
> This patch fixes the read-only detection by adding the own get_ro op
> for checking the register more intensively with a relatively long
> delay.
>
> The patch is tested with 2.6.39-rc4 kernel.
>
> Cc: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/host/sdhci-pci.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index a136be7..9037b2a 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -346,6 +346,35 @@ static void jmicron_enable_mmc(struct sdhci_host *host, int on)
>  	writeb(scratch, host->ioaddr + 0xC0);
>  }
>  
> +/* As PRESENT_STATE register becomes unstable just after plugging,
> + * need to check the RO-cap multiple times with a relatively long delay.
> + */
> +
> +#define SAMPLE_COUNT	5
> +
> +static unsigned int jmicron_get_ro(struct sdhci_host *host)
> +{
> +	int i, ro_count;
> +
> +	ro_count = 0;
> +	for (i = 0; i < SAMPLE_COUNT; i++) {
> +		int present = sdhci_readl(host, SDHCI_PRESENT_STATE);
> +		if (!(present & SDHCI_WRITE_PROTECT)) {
> +			if (++ro_count > SAMPLE_COUNT / 2)
> +				return 1;
> +		}
> +		msleep(30);
> +	}
> +	return 0;
> +}
> +
> +static int sdhci_pci_enable_dma(struct sdhci_host *host);
> +
> +static struct sdhci_ops jmicron_pci_ops = {
> +	.enable_dma	= sdhci_pci_enable_dma,
> +	.get_ro		= jmicron_get_ro,
> +};
> +
>  static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
>  {
>  	if (slot->chip->pdev->revision == 0) {
> @@ -383,6 +412,11 @@ static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
>  
>  	slot->host->mmc->caps |= MMC_CAP_BUS_WIDTH_TEST;
>  
> +	/* Replace the ops for unstable get_ro detection */
> +	if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_SD ||
> +	    slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
> +		slot->host->ops = &jmicron_pci_ops;
> +
>  	return 0;
>  }

I don't like overwriting ops here -- it's too magical, and now we have
to maintain the ops table in two places.  A quirk seems justified here,
even though we're trying to reduce them in general.  Can anyone find a
better solution?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
