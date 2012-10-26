Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab2JZANE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:13:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:54079 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2JZAId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 70/85] ipv4: Dont report stale pmtu values to userspace
Date: Thu, 25 Oct 2012 17:06:28 -0700
Message-Id: <20121026000038.155639517@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit ee9a8f7ab2edf801b8b514c310455c94acc232f6 ]

We report cached pmtu values even if they are already expired.
Change this to not report these values after they are expired
and fix a race in the expire time calculation, as suggested by
Eric Dumazet.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2187,8 +2187,18 @@ static int rt_fill_info(struct net *net,
 	    nla_put_be32(skb, RTA_GATEWAY, rt->rt_gateway))
 		goto nla_put_failure;
 
+	expires = rt->dst.expires;
+	if (expires) {
+		unsigned long now = jiffies;
+
+		if (time_before(now, expires))
+			expires -= now;
+		else
+			expires = 0;
+	}
+
 	memcpy(metrics, dst_metrics_ptr(&rt->dst), sizeof(metrics));
-	if (rt->rt_pmtu)
+	if (rt->rt_pmtu && expires)
 		metrics[RTAX_MTU - 1] = rt->rt_pmtu;
 	if (rtnetlink_put_metrics(skb, metrics) < 0)
 		goto nla_put_failure;
@@ -2198,13 +2208,6 @@ static int rt_fill_info(struct net *net,
 		goto nla_put_failure;
 
 	error = rt->dst.error;
-	expires = rt->dst.expires;
-	if (expires) {
-		if (time_before(jiffies, expires))
-			expires -= jiffies;
-		else
-			expires = 0;
-	}
 
 	if (rt_is_input_route(rt)) {
 		if (nla_put_u32(skb, RTA_IIF, rt->rt_iif))


