Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1LGRDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:03:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1LGRC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:02:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:01 2011
Message-Id: <20111207165601.339899873@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:44 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        davem@davemloft.net
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
        Jesse Gross <jesse@nicira.com>, Benjamin Poirier <bpoirier@suse.de>
Subject: [11/27] gro: reset vlan_tci on reuse
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

This one liner is part of upstream
commit 3701e51382a026cba10c60b03efabe534fba4ca4
Author: Jesse Gross <jesse@nicira.com>

    vlan: Centralize handling of hardware acceleration.

The bulk of that commit is a rework of the hardware assisted vlan tagging
driver interface, and as such doesn't classify for -stable inclusion. The fix
that is needed is a part of that commit but can work independently of the
rest.

This patch can avoid panics on the 2.6.32.y -stable kernels and is in the same
spirit as mainline commits
66c46d7 gro: Reset dev pointer on reuse
6d152e2 gro: reset skb_iif on reuse
which are already in -stable.

For drivers using the vlan_gro_frags() interface, a packet with an invalid tci
leads to GRO_DROP and napi_reuse_skb(). The skb has to be sanitized before
being reused or we may send an skb with an invalid vlan_tci field up the stack
where it is not expected.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Cc: Jesse Gross <jesse@nicira.com>
Acked-by: David S. Miller <davem@davemloft.net>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2614,6 +2614,7 @@ void napi_reuse_skb(struct napi_struct *
 {
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->iif = 0;
 


