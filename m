Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0GBFow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:44:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35138 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0GBFov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SEZNK4azjIS962ifjXPUznd7Rd2KIT0Xtb0Ytbbga2EQSx272/SAjDVWFuTXHaW5h7
         /JZnvXtxN9ITDNt2Ynw/uTtJ3KQ1ZIlE3ZUcQTcnjKLewngOeH9rHhIXciNPaPbSKPAE
         x99WIwq1eWUmgI5tZPSi6a1dZrUQwvBDc5WVc=
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C2D53D3.6050106@linux-ipv6.org>
References: <4C2D53D3.6050106@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 07:38:31 +0200
Message-ID: <1278049111.2597.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 juillet 2010 à 11:49 +0900, YOSHIFUJI Hideaki a écrit :
> Switch to netdev.
> 

thanks ;)

> --yoshfuji
> 
> -------- Original Message --------
> Subject: Possible bug in net/ipv4/route.c?
> Date: Thu, 1 Jul 2010 16:00:29 -0700
> From: Sol Kavy <skavy@ubicom.com>
> To: <linux-kernel@vger.kernel.org>
> CC: Greg Ren <gren@ubicom.com>, Guojun Jin <gjin@ubicom.com>,        Murat Sezgin <msezgin@ubicom.com>, Sener Ilgen <silgen@ubicom.com>
> 
> Found Linux: 2.6.28
> Arch: Ubicom32 <not yet pushed>
> Project: uCLinux based Router
> Test: Bit torrent Stress Test
> 
> Note: The top of Linus git net/ipv4/route.c appears to have the same issue.
> 

Please use < 72 char lines

> The following is a patch for clearing out IP options area in an input

>  skb during link failure processing.  Without this patch, the

>  icmp_send() can result in a call to ip_options_echo() where the 

> common buffer area of the skb is incorrectly interpreted.  Depending on the previous use of the skb->cb[], the interpreted option length values can cause stack corruption by copying more than 40 bytes to the output options.
> 
> In our case, a driver is using the skb->cb[] area to hold driver
> specific data.   The driver is not zeroing out the area after use.  I
> can see three basic solutions:
> 
> 1) Drivers are not allowed to use the skb->cb[] area at all.  Ubicom
> should modify the driver to use a different approach.
> 
> 2) The layer using skb->cb[] should clear this area after use and
> before handing the skb to another layer.  Ubicom should modify the
> driver to clear the skb->cb[] area before sending it up the line.
> 

This is the right option. If you use one word in cb[], only your driver
knows how to clear it efficiently.

> 3) Any layer that "uses" the skb->cb[] area must clear the area before
> use.  In which case, the proposed patch would fix the problem for the
> ipv4_link_failure().  I believe that this is the correct fix because I
> see ip_rcv() clears the skb->cb[] before using it.
> 

No : ip_rcv clears() skb->cb when leaving ip_rcv, not entering.

skb allocation clears whole cb[], and each layer is responsible to clear
the part it eventually dirtied.

> Can someone confirm that this is the appropriate fix?  If this is
> documented somewhere, please direct me to the documentation.
> 
> Please send email to sol@ubicom.com in addition to posting your
> response.
> 
> Thanks,
> 
> Sol Kavy/Murat Sezgin
> Ubicom, Inc.
> 
> Patch:  
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 125ee64..d13805f 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1606,6 +1606,14 @@ static void ipv4_link_failure(struct sk_buff *skb)
> {
>         struct rtable *rt;
> 
> +       /*
> +         * Since link failure can be called with skbs from many layers (see arp)
> +         * the cb area of the skb must be cleared before use. Because the cb area 
> +         * can be formatted according to the caller layer's cb area format and it may cause
> +         * corruptions when it is handled in a different network layer.
> +         */
> +       memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
>         icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
>         rt = skb->rtable;
> 
> The packet is enqueud by:
> do_IRQ()->do_softirq()->__do_softirq()->net_rx_action()->ubi32_eth_napi_poll()->ubi32_eth_receive()->__vlan_hwaccel_rx()->netif_receive_skb()->br_handle_frame()->nf_hook_slow()->br_nf_pre_routing_finish()->br_nfr_pre_routing_finish_bridge()->neight_resolve_output()->__neigh_event_send().
> 
> The packet is then dequeued by: 
> do_IRQ() -> irq_exit() -> do_softirq() -> run_timer_softirq() -> neigh_timer_handler() -> arp_error_report() -> ipv4_link_failure() -> icmp_send() -> ip_options_echo().
> 
> Because the Ubicom Ethernet driver overwrites the common buffer area, the enqueued packet contains garbage when casted as an IP options data structure.  This results in ip_options_echo() miss reading the option length information and overwriting memory.  By clearing the skb->cb[] before processing the icmp_send() against the packet, we ensure that ip_options_echo() does not corrupt memory.   
> 
> 
> 


