Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1DXAhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 20:37:39 -0400
Received: from void.printf.net ([89.145.121.20]:55323 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294Ab1DXAhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 20:37:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Aries Lee <arieslee@jmicron.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v2] mmc: Fix read-only detection with JMicron 388 chip
References: <s5hd3kfihpd.wl%tiwai@suse.de>
Date: Sat, 23 Apr 2011 20:41:24 -0400
In-Reply-To: <s5hd3kfihpd.wl%tiwai@suse.de> (Takashi Iwai's message of "Thu,
	21 Apr 2011 20:26:38 +0200")
Message-ID: <m3wrikv5u3.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 21 2011, Takashi Iwai wrote:
> On HP laptops with JMicron 388 chip, the write-locked SD card isn't
> detected correctly as read-only in many cases.  This is because the
> PRESENT_STATE register becomes unsable just after plugging, and it
> returns the WRITE_PROTECT bit wrongly at the first read.
>
> This patch fixes the read-only detection by adding a new sdhci quirk
> indicating to check the register more intensively with a relatively
> long delay.
>
> The patch is tested with 2.6.39-rc4 kernel.
>
> Cc: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> v1->v2
>  rewritten to use a quirk
>
>  drivers/mmc/host/sdhci-pci.c |    5 +++++
>  drivers/mmc/host/sdhci.c     |   28 ++++++++++++++++++++++++----
>  include/linux/mmc/sdhci.h    |    2 ++
>  3 files changed, 31 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index a136be7..5781395 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -329,6 +329,11 @@ static int jmicron_probe(struct sdhci_pci_chip *chip)
>  		return ret;
>  	}
>  
> +	/* quirk for unsable RO-detection on JM388 chips */
> +	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_SD ||
> +	    chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
> +		chip->quirks |= SDHCI_QUIRK_UNSTABLE_RO_DETECT;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 9e15f41..8097171 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1237,14 +1237,11 @@ out:
>  	spin_unlock_irqrestore(&host->lock, flags);
>  }
>  
> -static int sdhci_get_ro(struct mmc_host *mmc)
> +static int check_ro(struct sdhci_host *host)
>  {
> -	struct sdhci_host *host;
>  	unsigned long flags;
>  	int is_readonly;
>  
> -	host = mmc_priv(mmc);
> -
>  	spin_lock_irqsave(&host->lock, flags);
>  
>  	if (host->flags & SDHCI_DEVICE_DEAD)
> @@ -1262,6 +1259,29 @@ static int sdhci_get_ro(struct mmc_host *mmc)
>  		!is_readonly : is_readonly;
>  }
>  
> +#define SAMPLE_COUNT	5
> +
> +static int sdhci_get_ro(struct mmc_host *mmc)
> +{
> +	struct sdhci_host *host;
> +	int i, ro_count;
> +
> +	host = mmc_priv(mmc);
> +
> +	if (!(host->quirks & SDHCI_QUIRK_UNSTABLE_RO_DETECT))
> +		return check_ro(host);
> + 
> +	ro_count = 0;
> +	for (i = 0; i < SAMPLE_COUNT; i++) {
> +		if (check_ro(host)) {
> +			if (++ro_count > SAMPLE_COUNT / 2)
> +				return 1;
> +		}
> +		msleep(30);
> +	}
> +	return 0;
> +}
> + 
>  static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
>  {
>  	struct sdhci_host *host;
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 83bd9f7..92e1c9a 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -85,6 +85,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK_NO_HISPD_BIT			(1<<29)
>  /* Controller treats ADMA descriptors with length 0000h incorrectly */
>  #define SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC		(1<<30)
> +/* The read-only detection via SDHCI_PRESENT_STATE register is unstable */
> +#define SDHCI_QUIRK_UNSTABLE_RO_DETECT			(1<<31)
>  
>  	int irq;		/* Device IRQ */
>  	void __iomem *ioaddr;	/* Mapped address */

Thanks, pushed to mmc-next for .39.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
