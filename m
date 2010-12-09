Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0LICSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:18:42 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:38543 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0LICSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mmLHv4jfmzBs5Qrdll2lszpVkW5pxm3msNu7SVwyNJOLJ5zZblMpjnTTtH2C3lq+LA
         JanT+r0vUzsCaOtASu9ladSfXpCozFa2KG6xw2ExFFEBwfmrHAkH1y/a28owjpa1Q0bh
         5TXofzWrtqF+ucw+gamEygMbVRTXqBzDsYcX4=
MIME-Version: 1.0
In-Reply-To: <s5h7hfk3aap.wl%tiwai@suse.de>
References: <s5h7hfk3aap.wl%tiwai@suse.de>
Date: Wed, 8 Dec 2010 21:18:38 -0500
Message-ID: <AANLkTimhu9+42H1PYGjXih=J_x480g16SpWASUi+joUC@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: Add support for JMicron 388 SD/MMC controller
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aries Lee <arieslee@jmicron.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 4:04 AM, Takashi Iwai <tiwai@suse.de> wrote:
> JMicron 388 SD/MMC combo controller supports the 1.8V low-voltage for
> SD, but MMC doesn't work with the low-voltage, resulting in an error
> at probing.
>
> This patch adds the support for multiple voltage mask per device type,
> so that SD works with 1.8V while MMC forces 3.3V.  Here new ocr_avail_*
> fields for each device are introduced, so that the actual OCR mask is
> switched dynamically.

It is great that you also have 1.8v requirement, could you help share some info?
What's the card you are using, mmc or sd, if sd, does cmd11 is required?
Which component will provide voltage in your platform, external pmic
or controller?
What's the init voltage, 3.3v? and then switch to 1.8v, does some time
required to wait voltage to be stable?

Thanks a lot.

>
> Also, the restriction of low-voltage in core/sd.c is removed when the
> bit is allowed explicitly via ocr_avail_sd mask.
>
> This patch was rewritten from scratch based on Aries' original code.
>
> Signed-off-by: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>
> v1->v2
>  - Rebased to the latest mmc-next branch of linux-mmc tree
>
>  drivers/mmc/core/mmc.c       |    2 +
>  drivers/mmc/core/sd.c        |    5 +++-
>  drivers/mmc/core/sdio.c      |    2 +
>  drivers/mmc/host/sdhci-pci.c |   47 ++++++++++++++++++++++++++++++++++++-----
>  drivers/mmc/host/sdhci.c     |   23 ++++++++++++++++----
>  include/linux/mmc/host.h     |    3 ++
>  include/linux/mmc/sdhci.h    |    4 +++
>  include/linux/pci_ids.h      |    2 +
>  8 files changed, 76 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 77f93c3..76bb621 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -745,6 +745,8 @@ int mmc_attach_mmc(struct mmc_host *host, u32 ocr)
>        WARN_ON(!host->claimed);
>
>        mmc_attach_bus_ops(host);
> +       if (host->ocr_avail_mmc)
> +               host->ocr_avail = host->ocr_avail_mmc;
>
>        /*
>         * We need to get OCR a different way for SPI.
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 49da4df..de062eb 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -772,6 +772,8 @@ int mmc_attach_sd(struct mmc_host *host, u32 ocr)
>        WARN_ON(!host->claimed);
>
>        mmc_sd_attach_bus_ops(host);
> +       if (host->ocr_avail_sd)
> +               host->ocr_avail = host->ocr_avail_sd;
>
>        /*
>         * We need to get OCR a different way for SPI.
> @@ -795,7 +797,8 @@ int mmc_attach_sd(struct mmc_host *host, u32 ocr)
>                ocr &= ~0x7F;
>        }
>
> -       if (ocr & MMC_VDD_165_195) {
> +       if ((ocr & MMC_VDD_165_195) &&
> +           !(host->ocr_avail_sd & MMC_VDD_165_195)) {
>                printk(KERN_WARNING "%s: SD card claims to support the "
>                       "incompletely defined 'low voltage range'. This "
>                       "will be ignored.\n", mmc_hostname(host));
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index efef5f9..c18810a 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -700,6 +700,8 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
>        WARN_ON(!host->claimed);
>
>        mmc_attach_bus(host, &mmc_sdio_ops);
> +       if (host->ocr_avail_sdio)
> +               host->ocr_avail = host->ocr_avail_sdio;
>
>        /*
>         * Sanity check the voltages that the card claims to
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 831cf91..d2638ff 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -272,6 +272,7 @@ static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)
>  static int jmicron_probe(struct sdhci_pci_chip *chip)
>  {
>        int ret;
> +       u16 mmcdev = 0;
>
>        if (chip->pdev->revision == 0) {
>                chip->quirks |= SDHCI_QUIRK_32BIT_DMA_ADDR |
> @@ -293,12 +294,17 @@ static int jmicron_probe(struct sdhci_pci_chip *chip)
>         * 2. The MMC interface has a lower subfunction number
>         *    than the SD interface.
>         */
> -       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_SD) {
> +       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_SD)
> +               mmcdev = PCI_DEVICE_ID_JMICRON_JMB38X_MMC;
> +       else if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_SD)
> +               mmcdev = PCI_DEVICE_ID_JMICRON_JMB388_ESD;
> +
> +       if (mmcdev) {
>                struct pci_dev *sd_dev;
>
>                sd_dev = NULL;
>                while ((sd_dev = pci_get_device(PCI_VENDOR_ID_JMICRON,
> -                       PCI_DEVICE_ID_JMICRON_JMB38X_MMC, sd_dev)) != NULL) {
> +                                               mmcdev, sd_dev)) != NULL) {
>                        if ((PCI_SLOT(chip->pdev->devfn) ==
>                                PCI_SLOT(sd_dev->devfn)) &&
>                                (chip->pdev->bus == sd_dev->bus))
> @@ -358,11 +364,21 @@ static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
>                        slot->host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
>        }
>
> +       /* JM388 MMC doesn't support 1.8V while SD supports it */
> +       if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD) {
> +               slot->host->ocr_avail_sd = MMC_VDD_32_33 | MMC_VDD_33_34 |
> +                       MMC_VDD_29_30 | MMC_VDD_30_31 |
> +                       MMC_VDD_165_195; /* allow 1.8V */
> +               slot->host->ocr_avail_mmc = MMC_VDD_32_33 | MMC_VDD_33_34 |
> +                       MMC_VDD_29_30 | MMC_VDD_30_31; /* no 1.8V for MMC */
> +       }
> +
>        /*
>         * The secondary interface requires a bit set to get the
>         * interrupts.
>         */
> -       if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC)
> +       if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
> +           slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
>                jmicron_enable_mmc(slot->host, 1);
>
>        return 0;
> @@ -373,7 +389,8 @@ static void jmicron_remove_slot(struct sdhci_pci_slot *slot, int dead)
>        if (dead)
>                return;
>
> -       if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC)
> +       if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
> +           slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
>                jmicron_enable_mmc(slot->host, 0);
>  }
>
> @@ -381,7 +398,8 @@ static int jmicron_suspend(struct sdhci_pci_chip *chip, pm_message_t state)
>  {
>        int i;
>
> -       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC) {
> +       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
> +           chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD) {
>                for (i = 0;i < chip->num_slots;i++)
>                        jmicron_enable_mmc(chip->slots[i]->host, 0);
>        }
> @@ -393,7 +411,8 @@ static int jmicron_resume(struct sdhci_pci_chip *chip)
>  {
>        int ret, i;
>
> -       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC) {
> +       if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
> +           chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD) {
>                for (i = 0;i < chip->num_slots;i++)
>                        jmicron_enable_mmc(chip->slots[i]->host, 1);
>        }
> @@ -582,6 +601,22 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
>        },
>
>        {
> +               .vendor         = PCI_VENDOR_ID_JMICRON,
> +               .device         = PCI_DEVICE_ID_JMICRON_JMB388_SD,
> +               .subvendor      = PCI_ANY_ID,
> +               .subdevice      = PCI_ANY_ID,
> +               .driver_data    = (kernel_ulong_t)&sdhci_jmicron,
> +       },
> +
> +       {
> +               .vendor         = PCI_VENDOR_ID_JMICRON,
> +               .device         = PCI_DEVICE_ID_JMICRON_JMB388_ESD,
> +               .subvendor      = PCI_ANY_ID,
> +               .subdevice      = PCI_ANY_ID,
> +               .driver_data    = (kernel_ulong_t)&sdhci_jmicron,
> +       },
> +
> +       {
>                .vendor         = PCI_VENDOR_ID_SYSKONNECT,
>                .device         = 0x8000,
>                .subvendor      = PCI_ANY_ID,
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 8a74fcb..508ea5a 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1739,7 +1739,7 @@ EXPORT_SYMBOL_GPL(sdhci_alloc_host);
>  int sdhci_add_host(struct sdhci_host *host)
>  {
>        struct mmc_host *mmc;
> -       unsigned int caps;
> +       unsigned int caps, ocr_avail;
>        int ret;
>
>        WARN_ON(host == NULL);
> @@ -1893,13 +1893,26 @@ int sdhci_add_host(struct sdhci_host *host)
>            mmc_card_is_removable(mmc))
>                mmc->caps |= MMC_CAP_NEEDS_POLL;
>
> -       mmc->ocr_avail = 0;
> +       ocr_avail = 0;
>        if (caps & SDHCI_CAN_VDD_330)
> -               mmc->ocr_avail |= MMC_VDD_32_33|MMC_VDD_33_34;
> +               ocr_avail |= MMC_VDD_32_33 | MMC_VDD_33_34;
>        if (caps & SDHCI_CAN_VDD_300)
> -               mmc->ocr_avail |= MMC_VDD_29_30|MMC_VDD_30_31;
> +               ocr_avail |= MMC_VDD_29_30 | MMC_VDD_30_31;
>        if (caps & SDHCI_CAN_VDD_180)
> -               mmc->ocr_avail |= MMC_VDD_165_195;
> +               ocr_avail |= MMC_VDD_165_195;
> +
> +       mmc->ocr_avail = ocr_avail;
> +       mmc->ocr_avail_sdio = ocr_avail;
> +       if (host->ocr_avail_sdio)
> +               mmc->ocr_avail_sdio &= host->ocr_avail_sdio;
> +       mmc->ocr_avail_sd = ocr_avail;
> +       if (host->ocr_avail_sd)
> +               mmc->ocr_avail_sd &= host->ocr_avail_sd;
> +       else /* normal SD controllers don't support 1.8V */
> +               mmc->ocr_avail_sd &= ~MMC_VDD_165_195;
> +       mmc->ocr_avail_mmc = ocr_avail;
> +       if (host->ocr_avail_mmc)
> +               mmc->ocr_avail_sd &= host->ocr_avail_mmc;
>
>        if (mmc->ocr_avail == 0) {
>                printk(KERN_ERR "%s: Hardware doesn't report any "
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 381c77f..4a9d9d25 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -131,6 +131,9 @@ struct mmc_host {
>        unsigned int            f_max;
>        unsigned int            f_init;
>        u32                     ocr_avail;
> +       u32                     ocr_avail_sdio; /* SDIO-specific OCR */
> +       u32                     ocr_avail_sd;   /* SD-specific OCR */
> +       u32                     ocr_avail_mmc;  /* MMC-specific OCR */
>        struct notifier_block   pm_notify;
>
>  #define MMC_VDD_165_195                0x00000080      /* VDD voltage 1.65 - 1.95 */
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 1fdc673..0d953f5 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -139,6 +139,10 @@ struct sdhci_host {
>
>        unsigned int caps;      /* Alternative capabilities */
>
> +       unsigned int            ocr_avail_sdio; /* OCR bit masks */
> +       unsigned int            ocr_avail_sd;
> +       unsigned int            ocr_avail_mmc;
> +
>        unsigned long private[0] ____cacheline_aligned;
>  };
>  #endif /* __SDHCI_H */
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 7a58875..2f17b4c 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2368,6 +2368,8 @@
>  #define PCI_DEVICE_ID_JMICRON_JMB38X_SD        0x2381
>  #define PCI_DEVICE_ID_JMICRON_JMB38X_MMC 0x2382
>  #define PCI_DEVICE_ID_JMICRON_JMB38X_MS        0x2383
> +#define PCI_DEVICE_ID_JMICRON_JMB388_SD        0x2391
> +#define PCI_DEVICE_ID_JMICRON_JMB388_ESD 0x2392
>
>  #define PCI_VENDOR_ID_KORENIX          0x1982
>  #define PCI_DEVICE_ID_KORENIX_JETCARDF0        0x1600
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
