Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031239Ab2I1UVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:21:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031193Ab2I1UVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:21:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 006/218] pptp: lookup route with the proper net namespace
Date: Fri, 28 Sep 2012 13:13:43 -0700
Message-Id: <20120928201501.999367165@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 08252b32311c3fa84219ad794d640af7399b5485 ]

pptp always use init_net as the net namespace to lookup
route, this will cause route lookup failed in container.

because we already set the correct net namespace to struct
sock in pptp_create,so fix this by using sock_net(sk) to
replace &init_net.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pptp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -189,7 +189,7 @@ static int pptp_xmit(struct ppp_channel
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
 		goto tx_error;
 
-	rt = ip_route_output_ports(&init_net, &fl4, NULL,
+	rt = ip_route_output_ports(sock_net(sk), &fl4, NULL,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
@@ -468,7 +468,7 @@ static int pptp_connect(struct socket *s
 	po->chan.private = sk;
 	po->chan.ops = &pptp_chan_ops;
 
-	rt = ip_route_output_ports(&init_net, &fl4, sk,
+	rt = ip_route_output_ports(sock_net(sk), &fl4, sk,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0,


