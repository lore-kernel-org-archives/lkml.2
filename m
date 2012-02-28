Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2B1Bbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:31:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab2B1BHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.201.196 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010209.893321075@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/73] tcp: fix tcp_shifted_skb() adjustment of lost_cnt_hint for FACK
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 0af2a0d0576205dda778d25c6c344fc6508fc81d ]

This commit ensures that lost_cnt_hint is correctly updated in
tcp_shifted_skb() for FACK TCP senders. The lost_cnt_hint adjustment
in tcp_sacktag_one() only applies to non-FACK senders, so FACK senders
need their own adjustment.

This applies the spirit of 1e5289e121372a3494402b1b131b41bfe1cf9b7f -
except now that the sequence range passed into tcp_sacktag_one() is
correct we need only have a special case adjustment for FACK.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1385,6 +1385,10 @@ static int tcp_shifted_skb(struct sock *
 
 	BUG_ON(!pcount);
 
+	/* Adjust hint for FACK. Non-FACK is handled in tcp_sacktag_one(). */
+	if (tcp_is_fack(tp) && (skb == tp->lost_skb_hint))
+		tp->lost_cnt_hint += pcount;
+
 	TCP_SKB_CB(prev)->end_seq += shifted;
 	TCP_SKB_CB(skb)->seq += shifted;
 


