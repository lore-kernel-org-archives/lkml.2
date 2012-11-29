Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2K2PiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:38:04 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:37243 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2K2PiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:38:03 -0500
Date: Thu, 29 Nov 2012 10:37:44 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Krzysztof Mazur <krzysiek@podlesie.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121129103744.38149dc6@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1354141115.21562.101.camel@shinybook.infradead.org>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
	<1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
	<1354036592.2534.6.camel@shinybook.infradead.org>
	<20121127173906.GA11390@shrek.podlesie.net>
	<1354039349.2534.11.camel@shinybook.infradead.org>
	<20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
	<AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
	<1354141115.21562.101.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 22:18:35 +0000
David Woodhouse <dwmw2@infradead.org> wrote:


> diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
> index 9851093..3720670 100644
> --- a/drivers/atm/solos-pci.c
> +++ b/drivers/atm/solos-pci.c
> @@ -92,6 +92,7 @@ struct pkt_hdr {
>  };
>  
>  struct solos_skb_cb {
> +	struct completion c;
>  	struct atm_vcc *vcc;
>  	uint32_t dma_addr;
>  };
> @@ -881,11 +882,18 @@ static void pclose(struct atm_vcc *vcc)
>  	header->vci = cpu_to_le16(vcc->vci);
>  	header->type = cpu_to_le16(PKT_PCLOSE);
>  
> +	init_completion(&SKB_CB(skb)->c);
> +
>  	fpga_queue(card, SOLOS_CHAN(vcc->dev), skb, NULL);
>  
>  	clear_bit(ATM_VF_ADDR, &vcc->flags);
>  	clear_bit(ATM_VF_READY, &vcc->flags);

you shouldnt clear ATM_VF_ADDR until the vpi/vci is actually closed and
ready for reuse.  at this point, it isnt. ATM_VF_READY should already
be clear at this point but you should set it before you queue your
PKT_CLOSE.  these flags probably should be handled outside the drivers
since the context for them is pretty clear.  just another patch i never
got around to writing...

checking for ATM_VF_READY in find_vcc() is probably going to give you
grief as well since ATM_VF_READY isnt entirely under your control.  you
need to be able to find the vcc until after pclose() is finished since
your tasklet might have a few packets it is still processing?
