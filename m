Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1ABHzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:55:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:35421 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1ABHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jarek Poplawski <jarkao2@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 111/260] gro: Re-fix different skb headrooms
Date: Sun,  2 Jan 2011 02:16:47 -0500
Message-Id: <1293952756-15010-112-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:11.0430 (UTC) FILETIME=[C5957060:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/skbuff.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c1c86f5..9e7214e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2711,7 +2711,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	headroom = skb_headroom(p);
 	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;
-- 
1.7.3.3

