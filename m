Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1BEXp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:45:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:48318 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BEXp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:45:59 -0500
Subject: Re: Sun GEM PPC32 Bug?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "R. Herbst" <ruediger.herbst@googlemail.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Matt <jackdachef@gmail.com>, geert@linux-m68k.org
In-Reply-To: <1296949161.2349.839.camel@pasglop>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	 <1296852667.2349.804.camel@pasglop>
	 <20110204.145508.59670453.davem@davemloft.net>
	 <4D4D9882.107@googlemail.com>  <1296949161.2349.839.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 10:45:49 +1100
Message-ID: <1296949549.2349.845.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If I find some time tonight, else tomorrow, I'll whip up a couple of
> patches:
> 
>  - One simpler re-arranging our Rx reset sequence and adding a test for
> the overflow bit at the end, printing out the results, etc... 
> 
>  - One that basically always reset the chip on overflow.

Actually, the second one is trivial, just modify gem_rxmac_interrupt()
as follow:

	if (rxmac_stat & MAC_RXSTAT_OFLW) {
		u32 smac = readl(gp->regs + MAC_SMACHINE);

		netdev_err(dev, "RX MAC fifo overflow smac[%08x]\n", smac);
		gp->net_stats.rx_over_errors++;
		gp->net_stats.rx_fifo_errors++;

-		ret = gem_rxmac_reset(gp);
+		ret = 1;
	}

And tell us if that makes a difference.

Cheers,
Ben.



