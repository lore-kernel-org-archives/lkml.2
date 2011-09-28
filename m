Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1I1MJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:09:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57346 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1I1MI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:08:58 -0400
Subject: Re: Possible NULL dereference caused by -stable commit
 ef81bb40bf15f350fe865f31fa42f1082772a576
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@redhat.com>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        stable@kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amos Kong <akong@redhat.com>
In-Reply-To: <4E82FC4E.5010101@redhat.com>
References: <4E82FC4E.5010101@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 14:09:09 +0200
Message-ID: <1317211749.2941.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 28 septembre 2011 à 18:51 +0800, Jason Wang a écrit :
> Hi all:
> 
> A possible NULL dereference were noticed by the stable commit 
> ef81bb40bf15f350fe865f31fa42f1082772a576 (which is a backport of 
> 87c48fa3b4630905f98268dde838ee43626a060c). The case happens when bridge 
> froward a packet from guest to a physical nic, at this time no route is 
> attached to the skb which may lead a NULL dereference in 
> ipv6_select_ident(). -Next version have this check so it is fine. The 
> following patch may be used to avoid this but may also lead the ip 
> identification predicable, and this defect is also exist -next version 
> when no route because we still depends on a global variable to generate 
> the identification.  Any thought on this?

1) Discussion on current kernel :

All we need here is not the route but inet_peer, so that inet_getid()
can be called on it.

If no route is given to ipv6_select_ident(), at least we can try to get
inet_peer, and release it before exiting from ipv6_select_ident()

2) On stable kernel, we already use an array
(ipv6_fragmentation_id[FID_HASH_SZ];) to make less predictables
fragments ids.

So we could get dst addr from the packet to be forwarded instead of the
(possibly NULL) route.



