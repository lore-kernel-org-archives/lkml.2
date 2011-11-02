Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856Ab1KCBm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934782Ab1KCBmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.843606094@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jarek Poplawski <jarkao2@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [088/101] gro: Re-fix different skb headrooms
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

commit 64289c8e6851bca0e589e064c9a5c9fbd6ae5dd4 upstream.

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
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2711,7 +2711,7 @@ int skb_gro_receive(struct sk_buff **hea
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	headroom = skb_headroom(p);
 	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;


