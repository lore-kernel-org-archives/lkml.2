Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2KVVjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:39:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab2KVSk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Saurabh Mohan <saurabh.mohan@vyatta.com>,
        Ruben Herold <ruben@puettmann.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 55/83] ipv4/ip_vti.c: VTI fix post-decryption forwarding
Date: Wed, 21 Nov 2012 16:42:17 -0800
Message-Id: <20121122004218.609375364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Saurabh Mohan <saurabh.mohan@vyatta.com>

[ Upstream commit b2942004fb5c9f3304b77e187b8a1977b3626c9b ]

With the latest kernel there are two things that must be done post decryption
 so that the packet are forwarded.
 1. Remove the mark from the packet. This will cause the packet to not match
 the ipsec-policy again. However doing this causes the post-decryption check to
 fail also and the packet will get dropped. (cat /proc/net/xfrm_stat).
 2. Remove the sp association in the skbuff so that no policy check is done on
 the packet for VTI tunnels.

Due to #2 above we must now do a security-policy check in the vti rcv path
prior to resetting the mark in the skbuff.

Signed-off-by: Saurabh Mohan <saurabh.mohan@vyatta.com>
Reported-by: Ruben Herold <ruben@puettmann.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_vti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -341,12 +341,17 @@ static int vti_rcv(struct sk_buff *skb)
 	if (tunnel != NULL) {
 		struct pcpu_tstats *tstats;
 
+		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+			return -1;
+
 		tstats = this_cpu_ptr(tunnel->dev->tstats);
 		u64_stats_update_begin(&tstats->syncp);
 		tstats->rx_packets++;
 		tstats->rx_bytes += skb->len;
 		u64_stats_update_end(&tstats->syncp);
 
+		skb->mark = 0;
+		secpath_reset(skb);
 		skb->dev = tunnel->dev;
 		rcu_read_unlock();
 		return 1;


