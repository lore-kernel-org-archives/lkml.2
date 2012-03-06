Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2CFODj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:03:39 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:27853 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758264Ab2CFODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:03:36 -0500
Message-ID: <1331042608.2347.1.camel@bwh-desktop>
Subject: Re: [PATCH v4] lpc32xx: Added ethernet driver: smp_wmb()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Roland Stigge <stigge@antcom.de>
CC: <davem@davemloft.net>, <jeffrey.t.kirsher@intel.com>,
        <alexander.h.duyck@intel.com>, <eilong@broadcom.com>,
        <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <w.sang@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <kevin.wells@nxp.com>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <baruch@tkos.co.il>, <joe@perches.com>
Date: Tue, 6 Mar 2012 14:03:28 +0000
In-Reply-To: <4F55EA6D.3070602@antcom.de>
References: <1330983641-32622-1-git-send-email-stigge@antcom.de>
	 <1330987524.2538.61.camel@bwh-desktop> <4F55EA6D.3070602@antcom.de>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18756.003
X-TM-AS-Result: No--21.471000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 11:43 +0100, Roland Stigge wrote:
> On 03/05/2012 11:45 PM, Ben Hutchings wrote:
> >> +	/* Clear and enable interrupts */
> >> +	writel(0xFFFF, LPC_ENET_INTCLEAR(pldat->net_base));
> >> +	lpc_eth_enable_int(pldat->net_base);
> >> +
> >> +	/* Get the next TX buffer output index */
> >> +	pldat->num_used_tx_buffs = 0;
> >> +	pldat->last_tx_idx =
> >> +		readl(LPC_ENET_TXCONSUMEINDEX(pldat->net_base));
> > 
> > Doesn't this need to be done *before* enabling interrupts?  Also, I
> > think you need an smp_wmb() so that the interrupt handler is guaranteed
> > to see all these writes.
> 
> Do you mean _one_ smp_wmb() directly after lpc_eth_enable_int() (which
> I'm moving behind the above code?

The sequence should be

	pldat->state = values...;
	smp_wmb();
	enable_interrupts();

> Note that there is no SMP in LPCs and NXP is not planning to build one
> AFAIK.

Never say never!

> However, I'm fine with including smp_wmb() anyway for completeness.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

