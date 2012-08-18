Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2HRFGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 01:06:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51122 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2HRFGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 01:06:09 -0400
MIME-Version: 1.0
X-Originating-IP: [121.7.238.199]
In-Reply-To: <15456EE0-A358-4864-9F8D-B7F13014C47E@marvell.com>
References: <1345194854-8330-1-git-send-email-daniel@quora.org>
	<15456EE0-A358-4864-9F8D-B7F13014C47E@marvell.com>
Date: Sat, 18 Aug 2012 13:06:07 +0800
Message-ID: <CAMVG2sv1h0AdzQ23jQaab2HhP6WOqwc0hFhyUhWtcarfZgP=Yw@mail.gmail.com>
Subject: Re: [PATCH] Add MSI support for SDHCI PCI hosts
From: Daniel J Blueman <daniel@quora.org>
To: Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

The interrupt could be from another source, though Message Signalled
Interrupts are a PCI (and variants) only feature at present. I'm happy
to split the patch and/or make the module param specific to sdhci-pci.

Let's see what the maintainers prefer...Chris?

Dan

On 18 August 2012 00:35, Philip Rakity <prakity@marvell.com> wrote:
>
> The interrupt source could be from a non-pci device.  Say a gpio or whatever.
> Does it make sense to break this patch into two patches ?
>
> On Aug 17, 2012, at 2:14 AM, Daniel J Blueman <daniel@quora.org> wrote:
>
>> Allow module parameter 'enable_msi' to request an MSI interrupt for
>> hosts where available (presently PCI). Useful as a workaround on
>> platforms where the legacy interrupt is broken.
>>
>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>> ---
>> drivers/mmc/host/sdhci-pci.c |   30 ++++++++++++++++++++++++++++++
>> drivers/mmc/host/sdhci.c     |   23 +++++++++++++++++++++++
>> drivers/mmc/host/sdhci.h     |    2 ++
>> 3 files changed, 55 insertions(+)
>>
>> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
>> index 504da71..fbde589 100644
>> --- a/drivers/mmc/host/sdhci-pci.c
>> +++ b/drivers/mmc/host/sdhci-pci.c
>> @@ -934,6 +934,34 @@ static int sdhci_pci_enable_dma(struct sdhci_host *host)
>>       return 0;
>> }
>>
>> +static int sdhci_pci_enable_msi(struct sdhci_host *host)
>> +{
>> +     struct sdhci_pci_slot *slot;
>> +     struct pci_dev *pdev;
>> +     int ret;
>> +
>> +     slot = sdhci_priv(host);
>> +     pdev = slot->chip->pdev;
>> +
>> +     ret = pci_enable_msi(pdev);
>> +     if (ret)
>> +             return ret;
>> +
>> +     host->irq = pdev->irq;
>> +     return 0;
>> +}
>> +
>> +static void sdhci_pci_disable_msi(struct sdhci_host *host)
>> +{
>> +     struct sdhci_pci_slot *slot;
>> +     struct pci_dev *pdev;
>> +
>> +     slot = sdhci_priv(host);
>> +     pdev = slot->chip->pdev;
>> +
>> +     pci_disable_msi(pdev);
>> +}
>> +
>> static int sdhci_pci_8bit_width(struct sdhci_host *host, int width)
>> {
>>       u8 ctrl;
>> @@ -976,6 +1004,8 @@ static void sdhci_pci_hw_reset(struct sdhci_host *host)
>>
>> static struct sdhci_ops sdhci_pci_ops = {
>>       .enable_dma     = sdhci_pci_enable_dma,
>> +     .enable_msi     = sdhci_pci_enable_msi,
>> +     .disable_msi    = sdhci_pci_disable_msi,
>>       .platform_8bit_width    = sdhci_pci_8bit_width,
>>       .hw_reset               = sdhci_pci_hw_reset,
>> };
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 9a11dc3..9fa2180 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -45,6 +45,7 @@
>>
>> static unsigned int debug_quirks = 0;
>> static unsigned int debug_quirks2;
>> +static bool enable_msi;
>>
>> static void sdhci_finish_data(struct sdhci_host *);
>>
>> @@ -2433,6 +2434,9 @@ int sdhci_suspend_host(struct sdhci_host *host)
>>
>>       free_irq(host->irq, host);
>>
>> +     if (host->ops->disable_msi && enable_msi)
>> +             host->ops->disable_msi(host);
>> +
>>       return ret;
>> }
>>
>> @@ -2447,6 +2451,12 @@ int sdhci_resume_host(struct sdhci_host *host)
>>                       host->ops->enable_dma(host);
>>       }
>>
>> +     if (host->ops->enable_msi && enable_msi) {
>> +             ret = host->ops->enable_msi(host);
>> +             if (ret)
>> +                     return ret;
>> +     }
>> +
>>       ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
>>                         mmc_hostname(host->mmc), host);
>>       if (ret)
>> @@ -3024,6 +3034,12 @@ int sdhci_add_host(struct sdhci_host *host)
>>               host->tuning_timer.function = sdhci_tuning_timer;
>>       }
>>
>> +     if (host->ops->enable_msi && enable_msi) {
>> +             ret = host->ops->enable_msi(host);
>> +             if (ret)
>> +                     return ret;
>> +     }
>> +
>>       ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
>>               mmc_hostname(mmc), host);
>>       if (ret) {
>> @@ -3071,6 +3087,8 @@ int sdhci_add_host(struct sdhci_host *host)
>> reset:
>>       sdhci_reset(host, SDHCI_RESET_ALL);
>>       free_irq(host->irq, host);
>> +     if (host->ops->disable_msi && enable_msi)
>> +             host->ops->disable_msi(host);
>> #endif
>> untasklet:
>>       tasklet_kill(&host->card_tasklet);
>> @@ -3114,6 +3132,9 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
>>
>>       free_irq(host->irq, host);
>>
>> +     if (host->ops->disable_msi && enable_msi)
>> +             host->ops->disable_msi(host);
>> +
>>       del_timer_sync(&host->timer);
>>
>>       tasklet_kill(&host->card_tasklet);
>> @@ -3162,6 +3183,7 @@ module_exit(sdhci_drv_exit);
>>
>> module_param(debug_quirks, uint, 0444);
>> module_param(debug_quirks2, uint, 0444);
>> +module_param(enable_msi, bool, 0444);
>>
>> MODULE_AUTHOR("Pierre Ossman <pierre@ossman.eu>");
>> MODULE_DESCRIPTION("Secure Digital Host Controller Interface core driver");
>> @@ -3169,3 +3191,4 @@ MODULE_LICENSE("GPL");
>>
>> MODULE_PARM_DESC(debug_quirks, "Force certain quirks.");
>> MODULE_PARM_DESC(debug_quirks2, "Force certain other quirks.");
>> +MODULE_PARM_DESC(debug_quirks2, "Enable MSI interrupt support where possible.");
>> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
>> index 97653ea..df4e003 100644
>> --- a/drivers/mmc/host/sdhci.h
>> +++ b/drivers/mmc/host/sdhci.h
>> @@ -264,6 +264,8 @@ struct sdhci_ops {
>>       void    (*set_clock)(struct sdhci_host *host, unsigned int clock);
>>
>>       int             (*enable_dma)(struct sdhci_host *host);
>> +     int             (*enable_msi)(struct sdhci_host *host);
>> +     void            (*disable_msi)(struct sdhci_host *host);
>>       unsigned int    (*get_max_clock)(struct sdhci_host *host);
>>       unsigned int    (*get_min_clock)(struct sdhci_host *host);
>>       unsigned int    (*get_timeout_clock)(struct sdhci_host *host);
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Daniel J Blueman
