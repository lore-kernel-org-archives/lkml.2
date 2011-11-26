Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1KZEHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:07:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KZEHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:07:07 -0500
Message-ID: <1322280423.10212.3.camel@edumazet-laptop>
Subject: Re: [bug?] r8169: hangs under heavy load
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        Armin Kazmi <armin.kazmi@tu-dortmund.de>, Gerd <booster@wolke7.net>
Date: Sat, 26 Nov 2011 05:07:03 +0100
In-Reply-To: <20111126004447.GA14744@electric-eye.fr.zoreil.com>
References: <4E7F4D45.7040902@wolke7.net>
	 <1316978632.4122.103.camel@deadeye> <4E82C0B5.1050902@wolke7.net>
	 <1317254171.4068.12.camel@deadeye>
	 <20111124044137.GA18262@elie.hsd1.il.comcast.net>
	 <4ECFE7A7.5070300@wolke7.net>
	 <20111125201936.GA26692@elie.hsd1.il.comcast.net>
	 <1322253122.2550.3.camel@edumazet-laptop>
	 <20111125222211.GA13719@electric-eye.fr.zoreil.com>
	 <1322262357.2550.12.camel@edumazet-laptop>
	 <20111126004447.GA14744@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 26 novembre 2011 à 01:44 +0100, Francois Romieu a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> :
> > Le vendredi 25 novembre 2011 ?? 23:22 +0100, Francois Romieu a ??crit :
> [...]
> > > This path is not used.
> > 
> > OK, then we receive a RxFIFOOver indication while napi handler is
> > running (quite possible if machine under network load)
> 
> Welcome to the post 92fc43b4159b518f5baae57301f26d770b0834c9 world. :o/
> 
> The hack below could help (the XID matches RTL_GIGA_MAC_VER_22):
> 
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 6f06aa1..4fcfb3f 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -5818,7 +5818,6 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  			switch (tp->mac_version) {
>  			/* Work around for rx fifo overflow */
>  			case RTL_GIGA_MAC_VER_11:
> -			case RTL_GIGA_MAC_VER_22:
>  			case RTL_GIGA_MAC_VER_26:
>  				netif_stop_queue(dev);
>  				rtl8169_tx_timeout(dev);
> @@ -5835,6 +5834,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  			case RTL_GIGA_MAC_VER_31:
>  			/* Experimental science. Pktgen proof. */
>  			case RTL_GIGA_MAC_VER_12:
> +			case RTL_GIGA_MAC_VER_22:
>  			case RTL_GIGA_MAC_VER_25:
>  				if (status == RxFIFOOver)
>  					goto done;
> 
> 
> Traffic may stop flowing though. The patch below should be better:
> 

Yes, this is a workaround, and following _is_ the way to go...




> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 6f06aa1..54be9e1 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -5820,8 +5820,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  			case RTL_GIGA_MAC_VER_11:
>  			case RTL_GIGA_MAC_VER_22:
>  			case RTL_GIGA_MAC_VER_26:
> -				netif_stop_queue(dev);
> -				rtl8169_tx_timeout(dev);
> +				rtl8169_schedule_work(dev, rtl8169_reset_task);
>  				goto done;
>  			/* Testers needed. */
>  			case RTL_GIGA_MAC_VER_17:
> 

Please Jonathan, Gerd, try this fix !


