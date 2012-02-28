Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab2B1BH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:07:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2B1BHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.216.129 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010209.362485044@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Lu <shawn.lu@ericsson.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 32/73] tcp_v4_send_reset: binding oif to iif in no sock case
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Shawn Lu <shawn.lu@ericsson.com>

[ Upstream commit e2446eaab5585555a38ea0df4e01ff313dbb4ac9 ]

Binding RST packet outgoing interface to incoming interface
for tcp v4 when there is no socket associate with it.
when sk is not NULL, using sk->sk_bound_dev_if instead.
(suggested by Eric Dumazet).

This has few benefits:
1. tcp_v6_send_reset already did that.
2. This helps tcp connect with SO_BINDTODEVICE set. When
connection is lost, we still able to sending out RST using
same interface.
3. we are sending reply, it is most likely to be succeed
if iif is used

Signed-off-by: Shawn Lu <shawn.lu@ericsson.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -650,6 +650,11 @@ static void tcp_v4_send_reset(struct soc
 				      arg.iov[0].iov_len, IPPROTO_TCP, 0);
 	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
 	arg.flags = (sk && inet_sk(sk)->transparent) ? IP_REPLY_ARG_NOSRCCHECK : 0;
+	/* When socket is gone, all binding information is lost.
+	 * routing might fail in this case. using iif for oif to
+	 * make sure we can deliver it
+	 */
+	arg.bound_dev_if = sk ? sk->sk_bound_dev_if : inet_iif(skb);
 
 	net = dev_net(skb_dst(skb)->dev);
 	ip_send_reply(net->ipv4.tcp_sock, skb, ip_hdr(skb)->saddr,


