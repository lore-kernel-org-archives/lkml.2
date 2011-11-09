Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889Ab1KJD1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934856Ab1KJD1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:15 2011
Message-Id: <20111109212715.001132361@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zheng Yan <zheng.z.yan@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [143/262] tcp: properly update lost_cnt_hint during shifting
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit 1e5289e121372a3494402b1b131b41bfe1cf9b7f ]

lost_skb_hint is used by tcp_mark_head_lost() to mark the first unhandled skb.
lost_cnt_hint is the number of packets or sacked packets before the lost_skb_hint;
When shifting a skb that is before the lost_skb_hint, if tcp_is_fack() is ture,
the skb has already been counted in the lost_cnt_hint; if tcp_is_fack() is false,
tcp_sacktag_one() will increase the lost_cnt_hint. So tcp_shifted_skb() does not
need to adjust the lost_cnt_hint by itself. When shifting a skb that is equal to
lost_skb_hint, the shifted packets will not be counted by tcp_mark_head_lost().
So tcp_shifted_skb() should adjust the lost_cnt_hint even tcp_is_fack(tp) is true.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1380,9 +1380,7 @@ static int tcp_shifted_skb(struct sock *
 
 	BUG_ON(!pcount);
 
-	/* Tweak before seqno plays */
-	if (!tcp_is_fack(tp) && tcp_is_sack(tp) && tp->lost_skb_hint &&
-	    !before(TCP_SKB_CB(tp->lost_skb_hint)->seq, TCP_SKB_CB(skb)->seq))
+	if (skb == tp->lost_skb_hint)
 		tp->lost_cnt_hint += pcount;
 
 	TCP_SKB_CB(prev)->end_seq += shifted;


