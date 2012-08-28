Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2H1GJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 02:09:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13910 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2H1GJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 02:09:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 27 Aug 2012 23:08:51 -0700
Subject: Re: [PATCH 2/6] brcmfmac: Handling the interrupt in ISR directly
 for non-OOB
From: Wei Ni <wni@nvidia.com>
To: Arend van Spriel <arend@broadcom.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "rvossen@broadcom.com" <rvossen@broadcom.com>,
        Rakesh Kumar <krakesh@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
In-Reply-To: <503B9F31.5050502@broadcom.com>
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
	 <1346063114-30361-3-git-send-email-wni@nvidia.com>
	 <503B9F31.5050502@broadcom.com>
Date: Tue, 28 Aug 2012 14:08:29 +0800
Message-ID: <1346134109.3516.39.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 00:24 +0800, Arend van Spriel wrote:
> On 08/27/2012 12:25 PM, Wei Ni wrote:
> > In case of inband interrupts, if we handle the interrupt in dpc thread,
> > two level of thread switching takes place to process wifi interrupts.
> > One in SDHCI driver and the other in Wifi driver. This may cause the system
> > instability.
> 
> Looking into the sdhci/mmc code indeed shows that the brcmfmac irq 
> handler is not called in true IRQ context. So the dpc thread may add 
> unnecessary complexity, but to me there is not indication that there is 
> a stability issue.
> 
> > Because the SDHCI calls sdio_irq_thread() to handle the irq, this thread locks
> > mmc host and calls wifi handler. It expects WiFi handler to be quick and
> > enables sdio interrupt from card at end. If wifi handler defers this work for
> > a different thread, sdio_irq_thread() will be stuck on next wifi interrupt
> > since mmc lock is not freed.
> 
> Not sure if I can follow this explanation. The isr is called with host 
> claimed (by sdio_irq_thread) and all it does is at a linked list member 
> and signal the dpc thread. After doing this the host is released.
> 
> > Handling the interrupt in ISR directly will prevent thread context switching in
> > wifi driver. It can fix the instability problems.
> 
> This basically increases the duration of the isr in brcmfmac.
> 
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > ---
> >   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 ++
> >   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +++++++-
> >   2 files changed, 9 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> > index 8e7e692..5cf6c3b 100644
> > --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> > +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> > @@ -121,7 +121,9 @@ static void brcmf_sdio_irqhandler(struct sdio_func *func)
> >
> >   	brcmf_dbg(INTR, "ib intr triggered\n");
> >
> > +	sdio_release_host(sdiodev->func[1]);
> >   	brcmf_sdbrcm_isr(sdiodev->bus);
> > +	sdio_claim_host(sdiodev->func[1]);
> 
> This is probably needed because the ISR now locks the host to long 
> because brcmf_sdbrcm_dpc() is called directly.
> 
> >   }
> >
> >   /* dummy handler for SDIO function 2 interrupt */
> > diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> > index 472f2ef..4576d59 100644
> > --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> > +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> > @@ -2347,7 +2347,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
> >   	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
> >   	bool rxdone = true;	/* Flag for no more read data */
> >   	bool resched = false;	/* Flag indicating resched wanted */
> > -	int err;
> > +	int err = 0;
> >
> >   	brcmf_dbg(TRACE, "Enter\n");
> >
> > @@ -3786,11 +3786,17 @@ void brcmf_sdbrcm_isr(void *arg)
> >   	if (!bus->intr)
> >   		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
> >
> > +
> > +#ifndef CONFIG_BRCMFMAC_SDIO_OOB
> > +	while (brcmf_sdbrcm_dpc(bus))
> > +		;
> > +#else
> >   	bus->dpc_sched = true;
> >   	if (bus->dpc_tsk) {
> >   		brcmf_sdbrcm_adddpctsk(bus);
> >   		complete(&bus->dpc_wait);
> >   	}
> > +#endif
> >   }
> >
> >   static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
> >
> 
> I would really like to know what issue is solved by this change. Could 
> you provide more details.

If without this fix, the system is instability, we observed interrupt
from Wi-Fi cards pilling up in the system. We observed following issue
because of this:
1. Device is slow while downloading file through WiFi
2. WiFi performance is bad
3. WiFi does not turn on single CPU
4. Sometimes it will show following spew from kernel, and system will
hang up, it was caused by the semaphore which didn't be released.

INFO: task brcmf_watchdog:248 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
brcmf_watchdog  D c041aeac     0   248      2 0x00000000
[<c041aeac>] (__schedule+0x3c4/0x6d0) from [<c0418fe0>]
(schedule_timeout+0x1b0/0x218)
[<c0418fe0>] (schedule_timeout+0x1b0/0x218) from [<c041a748>] (__down
+0x68/0x98)
[<c041a748>] (__down+0x68/0x98) from [<c004c13c>] (down+0x44/0x4c)
[<c004c13c>] (down+0x44/0x4c) from [<bf017210>]
(brcmf_sdbrcm_bus_watchdog+0x28/0x1d0 [brcmfmac])
[<bf017210>] (brcmf_sdbrcm_bus_watchdog+0x28/0x1d0 [brcmfmac]) from
[<bf0173e4>] (brcmf_sdbrcm_watchdog_thread+0x2c/0x50 [brcmfmac])
[<bf0173e4>] (brcmf_sdbrcm_watchdog_thread+0x2c/0x50 [brcmfmac]) from
[<c0046328>] (kthread+0x8c/0x98)
[<c0046328>] (kthread+0x8c/0x98) from [<c000f5e4>] (kernel_thread_exit
+0x0/0x8)

After add this fix, everything looks ok.

I noticed that in the old version driver, it also has this fix, but
removed in http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
2.6.git;a=commit;h=b61c23c846978a4381fdc499055bd66b7bd24120

Thanks.
Wei.

> 
> Franky,
> 
> Do you have anything to add here?
> 
> Gr. AvS
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


