Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2BAVpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:45:24 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35761 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190Ab2BAVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:06 -0500
X-Sasl-enc: KruFikmp5i4dNEe+5aw5GNMcXXnVNxl48m//lxLyddZp 1328130545
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:42 2012
Message-Id: <20120201205742.382071669@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        =?UTF-8?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [56/65] tcp: fix tcp_trim_head() to adjust segment count with skb MSS
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 5b35e1e6e9ca651e6b291c96d1106043c9af314a ]

This commit fixes tcp_trim_head() to recalculate the number of
segments in the skb with the skb's existing MSS, so trimming the head
causes the skb segment count to be monotonically non-increasing - it
should stay the same or go down, but not increase.

Previously tcp_trim_head() used the current MSS of the connection. But
if there was a decrease in MSS between original transmission and ACK
(e.g. due to PMTUD), this could cause tcp_trim_head() to
counter-intuitively increase the segment count when trimming bytes off
the head of an skb. This violated assumptions in tcp_tso_acked() that
tcp_trim_head() only decreases the packet count, so that packets_acked
in tcp_tso_acked() could underflow, leading tcp_clean_rtx_queue() to
pass u32 pkts_acked values as large as 0xffffffff to
ca_ops->pkts_acked().

As an aside, if tcp_trim_head() had really wanted the skb to reflect
the current MSS, it should have called tcp_set_skb_tso_segs()
unconditionally, since a decrease in MSS would mean that a
single-packet skb should now be sliced into multiple segments.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Nandita Dukkipati <nanditad@google.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1134,11 +1134,9 @@ int tcp_trim_head(struct sock *sk, struc
 	sk_mem_uncharge(sk, len);
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 
-	/* Any change of skb->len requires recalculation of tso
-	 * factor and mss.
-	 */
+	/* Any change of skb->len requires recalculation of tso factor. */
 	if (tcp_skb_pcount(skb) > 1)
-		tcp_set_skb_tso_segs(sk, skb, tcp_current_mss(sk));
+		tcp_set_skb_tso_segs(sk, skb, tcp_skb_mss(skb));
 
 	return 0;
 }


