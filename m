Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab0GESDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:03:35 -0400
Received: from mail.vyatta.com ([76.74.103.46]:39378 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0GESDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:03:34 -0400
Date: Mon, 5 Jul 2010 11:03:28 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Sol Kavy <skavy@ubicom.com>, linux-kernel@vger.kernel.org, gren@ubicom.com,
       gjin@ubicom.com, msezgin@ubicom.com, silgen@ubicom.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Possible bug in net/ipv4/route.c?
Message-ID: <20100705110328.65702fc1@nehalam>
In-Reply-To: <20100705120413.GA6219@gondor.apana.org.au>
References: <CB2DD11991B27C4F99935E6229450D3205B28E91@STORK.scenix.com>
	<20100705120413.GA6219@gondor.apana.org.au>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jul 2010 20:04:13 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Sol Kavy <skavy@ubicom.com> wrote:
> > Found Linux: 2.6.28
> > Arch: Ubicom32 <not yet pushed>
> > Project: uCLinux based Router
> > Test: Bit torrent Stress Test
> > 
> > Note: The top of Linus git net/ipv4/route.c appears to have the same issue.
> > 
> > The following is a patch for clearing out IP options area in an input skb during link failure processing.  Without this patch, the icmp_send() can result in a call to ip_options_echo() where the common buffer area of the skb is incorrectly interpreted.  Depending on the previous use of the skb->cb[], the interpreted option length values can cause stack corruption by copying more than 40 bytes to the output options.
> > 
> > In our case, a driver is using the skb->cb[] area to hold driver specific data.   The driver is not zeroing out the area after use.  I can see three basic solutions:
> > 
> > 1) Drivers are not allowed to use the skb->cb[] area at all.  Ubicom should modify the driver to use a different approach.
> > 
> > 2) The layer using skb->cb[] should clear this area after use and before handing the skb to another layer.  Ubicom should modify the driver to clear the skb->cb[] area before sending it up the line.
> > 
> > 3) Any layer that "uses" the skb->cb[] area must clear the area before use.  In which case, the proposed patch would fix the problem for the ipv4_link_failure().  I believe that this is the correct fix because I see ip_rcv() clears the skb->cb[] before using it.
> > 
> > Can someone confirm that this is the appropriate fix?  If this is documented somewhere, please direct me to the documentation.
> 
> Thanks for the report!
>  
> > Patch:  
> > 
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 125ee64..d13805f 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1606,6 +1606,14 @@ static void ipv4_link_failure(struct sk_buff *skb)
> > {
> >         struct rtable *rt;
> > 
> > +       /*
> > +         * Since link failure can be called with skbs from many layers (see arp)
> > +         * the cb area of the skb must be cleared before use. Because the cb area 
> > +         * can be formatted according to the caller layer's cb area format and it may cause
> > +         * corruptions when it is handled in a different network layer.
> > +         */
> > +       memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
> >         icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
> >         rt = skb->rtable;
> > 
> > The packet is enqueud by:
> > do_IRQ()->do_softirq()->__do_softirq()->net_rx_action()->ubi32_eth_napi_poll()->ubi32_eth_receive()->__vlan_hwaccel_rx()->netif_receive_skb()->br_handle_frame()->nf_hook_slow()->br_nf_pre_routing_finish()->br_nfr_pre_routing_finish_bridge()->neight_resolve_output()->__neigh_event_send().
> > 
> > The packet is then dequeued by: 
> > do_IRQ() -> irq_exit() -> do_softirq() -> run_timer_softirq() -> neigh_timer_handler() -> arp_error_report() -> ipv4_link_failure() -> icmp_send() -> ip_options_echo().
> > 
> > Because the Ubicom Ethernet driver overwrites the common buffer area, the enqueued packet contains garbage when casted as an IP options data structure.  This results in ip_options_echo() miss reading the option length information and overwriting memory.  By clearing the skb->cb[] before processing the icmp_send() against the packet, we ensure that ip_options_echo() does not corrupt memory.   
> 
> Generally this area should be cleared on entry to each stack
> intending on using it.  So in this case, I'd point the finger
> of blame at the bridge stack for letting this packet into the
> IP stack through the back entrance without taking the proper
> precautions.

The CB is used in two places in the bridge code.
1) The recent multicast changes (IGMP)
2) Netfilter / ebtables to store header.

Ebtables is okay because the only part of the cb[] it uses
is the incoming device (brdev) which is always initialized coming into
the bridge: br_dev_xmit and br_handle_frame_finish

The IGMP code looks buggy.

/* net device transmit always called with no BH (preempt_disabled) */
netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
{
... [A]
	BR_INPUT_SKB_CB(skb)->brdev = dev;

	skb_reset_mac_header(skb);
	skb_pull(skb, ETH_HLEN);

	if (is_multicast_ether_addr(dest)) {
		if (br_multicast_rcv(br, NULL, skb))
			goto out;

		mdst = br_mdb_get(br, skb);
		if (mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb))
			... [B]

The problem is that br_dev_xmit is looking at flags in the CB[] that
are uninitialized.

if br_dev_xmit cleared the CB at [A] the mrouters_only would always be zero
at [B].

Where should the mrouters and igmp_only fields in skb be initialized?


