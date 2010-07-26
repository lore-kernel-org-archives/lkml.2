Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0GZUN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:13:26 -0400
Received: from mail.atheros.com ([12.36.123.2]:29683 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0GZUNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:13:24 -0400
Date: Mon, 26 Jul 2010 13:13:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <kernel-team@lists.ubuntu.com>, <tim.gardner@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Quan <David.Quan@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
Message-ID: <20100726201322.GI14855@tux>
References: <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
 <1276856142.9114.1.camel@maxim-laptop>
 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
 <1276859156.19554.2.camel@maxim-laptop>
 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
 <1276870309.23783.3.camel@maxim-laptop>
 <1276933774.16697.11.camel@maxim-laptop>
 <20100619123841.GA31838@hash.localnet>
 <1276952554.3332.3.camel@maxim-laptop>
 <1276961564.5173.12.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1276961564.5173.12.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 08:32:44AM -0700, Maxim Levitsky wrote:
> On Sat, 2010-06-19 at 16:02 +0300, Maxim Levitsky wrote: 
> > On Sat, 2010-06-19 at 08:38 -0400, Bob Copeland wrote: 
> > > On Sat, Jun 19, 2010 at 10:49:34AM +0300, Maxim Levitsky wrote:
> > > > How this patch?
> > > 
> > > Looks fine to me.  Some nitpicking below but feel free to add my
> > > 
> > > Acked-by: Bob Copeland <me@bobcopeland.com>
> > > 
> Done.
> 
> Best regards,
> Maxim Levitsky
> 
> --- 
> 
> commit 616afa397b3e843f2aba06be12a30e72dfff7740
> Author: Maxim Levitsky <maximlevitsky@gmail.com>
> Date:   Thu Jun 17 23:21:42 2010 +0300
> 
>     ath5k: disable ASPM
>     
>     Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>     Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>     enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>     'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
>     these problems.
>     Also card sends a storm of RXORN interrupts even though medium is idle.
>     
>     Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
>     both ends (usually stalls within seconds).
>     
>     Unfortunately BIOS enables ASPM on this card by default on these machines
>     This means that, problem shows up (less often) without pcie_aspm=force too. 
>     Therefore to benefit from this fix you need to _enable_ CONFIG_PCIEASPM
>     
> 
>     All credit for this patch goes to Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>     for finding and fixing this bug.
>     
>     Based on patch that is
>     From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>     
>     
>     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>     Acked-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

But please resubmit and completley modify the commit log to indicate
ath5k cards support ASPM but L0s must be disabled, only L1
works correctly.

The comments about ASPM force should be removed as it would
lead others to try to use the same and the fact of the matter is
that ASPM force should never be used. As was clarified out of
some of these discussions worth noting also is that in newer
kernels CONFIG_PCIEASPM=y will always become the default, for
older kernels this was never the default and some distributions
(Ubunutu) do not have this enabled, the benefit of having it
enabled is it will disable ASPM for these cases:

(a) the PCIE device is pre PCIE 1.1
(b) the firmware has the FADT flag set to tell you not to and
(c) the firmware doesn't grant control via _OSC. The powersave policy will
enable ASPM even if the BIOS didn't, but only if something else doesn't
tell us not to.

The last two checks were only recently added by Mathew and forcing
CONFIG_PCIEASPM=y was also only recently made default.

In short, Linux distributions should also start enabling
CONFIG_PCIEASPM=y on older kernels.

  Luis

> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 3abbe75..4f6bd7c 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -48,6 +48,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/cache.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/ethtool.h>
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
> @@ -469,6 +470,19 @@ ath5k_pci_probe(struct pci_dev *pdev,
>  	int ret;
>  	u8 csz;
>  
> +	/*
> +	 * Disable PCIE ASPM L0S on the card.
> +	 * ASPM triggers hardware bug, that makes card stall transmission
> +	 * untill reset, and even that doesn't always help.
> +	 * This happens on meduim to heavy transmit utilization.
> +	 * In addition to stall, hardware usually gives a storm of
> +	 * RXORN interrupts, despite idle channel, and otherwise doesn't work.
> +	 * Windows driver also disables the L0s ASPM,
> +	 * probably due to same reason
> +	 * Note: to benefit from this fix, please _enable_ CONFIG_PCIEASPM
> +	 */
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +
>  	ret = pci_enable_device(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "can't enable device\n");
> 
> 
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
