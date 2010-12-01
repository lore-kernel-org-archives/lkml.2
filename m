Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0LAKz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:55:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34757 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0LAKz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:55:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cx6x5UPofkdnwcjDGEKJxU9s9Z/PVCVqDviVIN6hAkkyb5VPpbSG3kte56QWI+N4iY
         8BdoNIMCNBh5ppDVYjORZom/kJwQ3dd0l+Xwpi8CY60PwLME0VPlbhfGlpBQz1KH1a4K
         BdzriOKNd7hAk0OH1DfB4AP3UYuTAM1faRH1E=
Subject: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Leun <lkml20101129@newton.leun.net>,
        David Miller <davem@davemloft.net>
Cc: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Gross <jesse@nicira.com>,
        stable@kernel.org
In-Reply-To: <20101201111716.424fb771@xenia.leun.net>
References: <20101129201716.1d0257c4@xenia.leun.net>
	 <4CF442FA.4070701@candelatech.com> <20101130095944.41b5f7b6@xenia.leun.net>
	 <1291108809.2904.3.camel@edumazet-laptop>
	 <20101201111716.424fb771@xenia.leun.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 11:55:14 +0100
Message-ID: <1291200914.2856.546.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 décembre 2010 à 11:17 +0100, Michael Leun a écrit :

> Yup, from what I've tested this works (and tcpdump sees broadcast
> packets even for vlans not configured at the moment including vlan tag
> - yipee!).
> 

Thanks Michael !

Here is the revised patch again then for stable team, via David Miller
agreement.


[PATCH v2 2.6.36] vlan: Avoid hwaccel vlan packets when vid not used.

Normally hardware accelerated vlan packets are quickly dropped if
there is no corresponding vlan device configured.  The one exception
is promiscuous mode, where we allow all of these packets through so
they can be picked up by tcpdump.  However, this behavior causes a
crash if we actually try to receive these packets.  This fixes that
crash by ignoring packets with vids not corresponding to a configured
device in the vlan hwaccel routines and then dropping them before they
get to consumers in the network stack.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Michael Leun <lkml20101129@newton.leun.net>
---
v2: survives to tcpdump :)

 net/core/dev.c        |   10 ++++++++++
 net/8021q/vlan_core.c |    3 +++
 2 files changed, 13 insertions(+)

--- linux-2.6.36/net/core/dev.c.orig
+++ linux-2.6.36/net/core/dev.c
@@ -2891,6 +2891,15 @@
 ncls:
 #endif
 
+	/* If we got this far with a hardware accelerated VLAN tag, it means
+	 * that we were put in promiscuous mode but nobody is interested in
+	 * this vid. Drop the packet now to prevent it from getting propagated
+	 * to other parts of the stack that won't know how to deal with packets
+	 * tagged in this manner.
+	 */
+	if (unlikely(vlan_tx_tag_present(skb)))
+		goto bypass;
+
 	/* Handle special case of bridge or macvlan */
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (rx_handler) {
@@ -2927,6 +2936,7 @@
 		}
 	}
 
+bypass:
 	if (pt_prev) {
 		ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 	} else {
--- linux-2.6.36/net/8021q/vlan_core.c.orig
+++ linux-2.6.36/net/8021q/vlan_core.c
@@ -43,6 +43,9 @@
 	struct net_device *dev = skb->dev;
 	struct vlan_rx_stats     *rx_stats;
 
+	if (unlikely(!is_vlan_dev(dev)))
+		return 0;
+
 	skb->dev = vlan_dev_info(dev)->real_dev;
 	netif_nit_deliver(skb);
 


