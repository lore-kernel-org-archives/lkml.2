Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2H0QYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:24:36 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4299 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2H0QYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:24:32 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <503B9F31.5050502@broadcom.com>
Date: Mon, 27 Aug 2012 18:24:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: swarren@wwwdotorg.org, "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        rvossen@broadcom.com, krakesh@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 2/6] brcmfmac: Handling the interrupt in ISR
 directly for non-OOB
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
 <1346063114-30361-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1346063114-30361-3-git-send-email-wni@nvidia.com>
X-WSS-ID: 7C25413749824030767-01-01
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 12:25 PM, Wei Ni wrote:
> In case of inband interrupts, if we handle the interrupt in dpc thread,
> two level of thread switching takes place to process wifi interrupts.
> One in SDHCI driver and the other in Wifi driver. This may cause the system
> instability.

Looking into the sdhci/mmc code indeed shows that the brcmfmac irq 
handler is not called in true IRQ context. So the dpc thread may add 
unnecessary complexity, but to me there is not indication that there is 
a stability issue.

> Because the SDHCI calls sdio_irq_thread() to handle the irq, this thread locks
> mmc host and calls wifi handler. It expects WiFi handler to be quick and
> enables sdio interrupt from card at end. If wifi handler defers this work for
> a different thread, sdio_irq_thread() will be stuck on next wifi interrupt
> since mmc lock is not freed.

Not sure if I can follow this explanation. The isr is called with host 
claimed (by sdio_irq_thread) and all it does is at a linked list member 
and signal the dpc thread. After doing this the host is released.

> Handling the interrupt in ISR directly will prevent thread context switching in
> wifi driver. It can fix the instability problems.

This basically increases the duration of the isr in brcmfmac.

> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 ++
>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +++++++-
>   2 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 8e7e692..5cf6c3b 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -121,7 +121,9 @@ static void brcmf_sdio_irqhandler(struct sdio_func *func)
>
>   	brcmf_dbg(INTR, "ib intr triggered\n");
>
> +	sdio_release_host(sdiodev->func[1]);
>   	brcmf_sdbrcm_isr(sdiodev->bus);
> +	sdio_claim_host(sdiodev->func[1]);

This is probably needed because the ISR now locks the host to long 
because brcmf_sdbrcm_dpc() is called directly.

>   }
>
>   /* dummy handler for SDIO function 2 interrupt */
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> index 472f2ef..4576d59 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> @@ -2347,7 +2347,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
>   	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
>   	bool rxdone = true;	/* Flag for no more read data */
>   	bool resched = false;	/* Flag indicating resched wanted */
> -	int err;
> +	int err = 0;
>
>   	brcmf_dbg(TRACE, "Enter\n");
>
> @@ -3786,11 +3786,17 @@ void brcmf_sdbrcm_isr(void *arg)
>   	if (!bus->intr)
>   		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
>
> +
> +#ifndef CONFIG_BRCMFMAC_SDIO_OOB
> +	while (brcmf_sdbrcm_dpc(bus))
> +		;
> +#else
>   	bus->dpc_sched = true;
>   	if (bus->dpc_tsk) {
>   		brcmf_sdbrcm_adddpctsk(bus);
>   		complete(&bus->dpc_wait);
>   	}
> +#endif
>   }
>
>   static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
>

I would really like to know what issue is solved by this change. Could 
you provide more details.

Franky,

Do you have anything to add here?

Gr. AvS

