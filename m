Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0IXRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:00:54 -0400
Received: from kroah.org ([198.145.64.141]:46019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab0IXQ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:27:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:15 2010
Message-Id: <20100924162615.335646075@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:23:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [05/80] gro: Re-fix different skb headrooms
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 64289c8e6851bca0e589e064c9a5c9fbd6ae5dd4 ]

The patch: "gro: fix different skb headrooms" in its part:
"2) allocate a minimal skb for head of frag_list" is buggy. The copied
skb has p->data set at the ip header at the moment, and skb_gro_offset
is the length of ip + tcp headers. So, after the change the length of
mac header is skipped. Later skb_set_mac_header() sets it into the
NET_SKB_PAD area (if it's long enough) and ip header is misaligned at
NET_SKB_PAD + NET_IP_ALIGN offset. There is no reason to assume the
original skb was wrongly allocated, so let's copy it as it was.

bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
fixes commit: 3d3be4333fdf6faa080947b331a6a19bce1a4f57

Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2707,7 +2707,7 @@ int skb_gro_receive(struct sk_buff **hea
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	headroom = skb_headroom(p);
 	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;


