Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0GBAXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:23:06 -0400
Received: from server70.appriver.com ([69.20.119.203]:2415 "EHLO
	server70.appriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0GBAXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:23:04 -0400
X-Greylist: delayed 4048 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 20:23:04 EDT
X-Policy: GLOBAL - ubicom.com
X-Primary: skavy@ubicom.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: skavy@ubicom.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.112.109.98
X-Note-Reverse-DNS: 216.112.109.98.ptr.us.xo.net
X-Note-WHTLIST: skavy@ubicom.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G200 G201 G202 G203 G207 G208 G219 G307 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: Possible bug in net/ipv4/route.c?
Date: Thu, 1 Jul 2010 17:19:52 -0700
Message-ID: <CB2DD11991B27C4F99935E6229450D3205B28EBB@STORK.scenix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Possible bug in net/ipv4/route.c?
Thread-Index: AcsZfEngE++4uyjiSyaAHzCCBUG6+w==
From: "Sol Kavy" <skavy@ubicom.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Greg Ren" <gren@ubicom.com>, "Guojun Jin" <gjin@ubicom.com>,
       "Murat Sezgin" <msezgin@ubicom.com>, "Sener Ilgen" <silgen@ubicom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found Linux: 2.6.28
Arch: Ubicom32 <not yet pushed>
Project: uCLinux based Router
Test: Bit torrent Stress Test

Note: The top of Linus git net/ipv4/route.c appears to have the same issue.

The following is a patch for clearing out IP options area in an input skb during link failure processing.  Without this patch, the icmp_send() can result in a call to ip_options_echo() where the common buffer area of the skb is incorrectly interpreted.  Depending on the previous use of the skb->cb[], the interpreted option length values can cause stack corruption by copying more than 40 bytes to the output options.

In our case, a driver is using the skb->cb[] area to hold driver specific data.   The driver is not zeroing out the area after use.  I can see three basic solutions:

1) Drivers are not allowed to use the skb->cb[] area at all.  Ubicom should modify the driver to use a different approach.

2) The layer using skb->cb[] should clear this area after use and before handing the skb to another layer.  Ubicom should modify the driver to clear the skb->cb[] area before sending it up the line.

3) Any layer that "uses" the skb->cb[] area must clear the area before use.  In which case, the proposed patch would fix the problem for the ipv4_link_failure().  I believe that this is the correct fix because I see ip_rcv() clears the skb->cb[] before using it.

Can someone confirm that this is the appropriate fix?  If this is documented somewhere, please direct me to the documentation.

Please send email to sol@ubicom.com in addition to posting your response.

Thanks,

Sol Kavy/Murat Sezgin
Ubicom, Inc.

Patch:  

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 125ee64..d13805f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1606,6 +1606,14 @@ static void ipv4_link_failure(struct sk_buff *skb)
{
        struct rtable *rt;

+       /*
+         * Since link failure can be called with skbs from many layers (see arp)
+         * the cb area of the skb must be cleared before use. Because the cb area 
+         * can be formatted according to the caller layer's cb area format and it may cause
+         * corruptions when it is handled in a different network layer.
+         */
+       memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
        icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
        rt = skb->rtable;

The packet is enqueud by:
do_IRQ()->do_softirq()->__do_softirq()->net_rx_action()->ubi32_eth_napi_poll()->ubi32_eth_receive()->__vlan_hwaccel_rx()->netif_receive_skb()->br_handle_frame()->nf_hook_slow()->br_nf_pre_routing_finish()->br_nfr_pre_routing_finish_bridge()->neight_resolve_output()->__neigh_event_send().

The packet is then dequeued by: 
do_IRQ() -> irq_exit() -> do_softirq() -> run_timer_softirq() -> neigh_timer_handler() -> arp_error_report() -> ipv4_link_failure() -> icmp_send() -> ip_options_echo().

Because the Ubicom Ethernet driver overwrites the common buffer area, the enqueued packet contains garbage when casted as an IP options data structure.  This results in ip_options_echo() miss reading the option length information and overwriting memory.  By clearing the skb->cb[] before processing the icmp_send() against the packet, we ensure that ip_options_echo() does not corrupt memory.   



