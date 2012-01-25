Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2AYIhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:37:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34065 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2AYIhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:37:08 -0500
Message-ID: <1327480624.14373.51.camel@edumazet-laptop>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesse Gross <jesse@nicira.com>
Cc: David Miller <davem@davemloft.net>, joseph.glanville@orionvm.com.au,
        steweg@ynet.sk, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2012 09:37:04 +0100
In-Reply-To: <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
References: <20120123.134352.1621146585245670953.davem@davemloft.net>
	 <CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
	 <CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
	 <20120124.230203.1478271172075708903.davem@davemloft.net>
	 <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 23:11 -0800, Jesse Gross a écrit :

> I think it's actually the opposite - Open vSwitch can be used to
> implement this type of thing as well as for many other use cases.  On
> the other hand, even when implementing a multipoint L2 solution it can
> be useful to have additional levels of control but you can't do that
> with this patch because it essentially statically glues together
> tunneling and bridging.

Unless you can provide a working solution in a very short time, this
patch is a pragmatic one.

Code is not perfect and could be improved (for example using a helper
function to keep ipgre_rcv() shorter and reduce indentation level)

Stefan, could you move this code out of ipgre_rcv() ?


+#ifdef CONFIG_NET_IPGRE_BRIDGE
+                       if (ipv4_is_multicast(tunnel->parms.iph.daddr)) {
+                               tethhdr = eth_hdr(skb);
+                               if (!is_multicast_ether_addr(
+                                       tethhdr->h_source)) {
+                                       head = &tunnel->hash[
+                                               ipgre_tap_bridge_hash(
+                                                       tethhdr->h_source)];
+                                       entry = ipgre_tap_bridge_find_rcu(head,
+                                               tethhdr->h_source);
+                                       if (likely(entry)) {
+                                               entry->raddr = orig_source;
+                                               entry->updated = jiffies;
+                                       } else {
+                                         spin_lock(&tunnel->hash_lock);
+                                         if (!ipgre_tap_bridge_find(head,
+                                               tethhdr->h_source))
+                                               ipgre_tap_bridge_create(
+                                                       head,
+                                                       orig_source,
+                                                       tethhdr->h_source);
+                                         spin_unlock(&tunnel->hash_lock);
+                                       }
+                               }
+                       }
+#endif



