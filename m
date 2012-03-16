Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946536Ab2CPXyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:54:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59349 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162109Ab2CPXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:07 -0400
Message-Id: <20120316233449.140916302@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        =?UTF-8?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/38] tcp: dont fragment SACKed skbs in tcp_mark_head_lost()
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit c0638c247f559e1a16ee79e54df14bca2cb679ea ]

In tcp_mark_head_lost() we should not attempt to fragment a SACKed skb
to mark the first portion as lost. This is for two primary reasons:

(1) tcp_shifted_skb() coalesces adjacent regions of SACKed skbs. When
doing this, it preserves the sum of their packet counts in order to
reflect the real-world dynamics on the wire. But given that skbs can
have remainders that do not align to MSS boundaries, this packet count
preservation means that for SACKed skbs there is not necessarily a
direct linear relationship between tcp_skb_pcount(skb) and
skb->len. Thus tcp_mark_head_lost()'s previous attempts to fragment
off and mark as lost a prefix of length (packets - oldcnt)*mss from
SACKed skbs were leading to occasional failures of the WARN_ON(len >
skb->len) in tcp_fragment() (which used to be a BUG_ON(); see the
recent "crash in tcp_fragment" thread on netdev).

(2) there is no real point in fragmenting off part of a SACKed skb and
calling tcp_skb_mark_lost() on it, since tcp_skb_mark_lost() is a NOP
for SACKed skbs.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Nandita Dukkipati <nanditad@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2549,6 +2549,7 @@ static void tcp_mark_head_lost(struct so
 
 		if (cnt > packets) {
 			if ((tcp_is_sack(tp) && !tcp_is_fack(tp)) ||
+			    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) ||
 			    (oldcnt >= packets))
 				break;
 


