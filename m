Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2JEO4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56682 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2JEO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 08/16] ipvs: fix ip_vs_set_timeout debug messages
Date: Fri,  5 Oct 2012 16:55:22 +0200
Message-Id: <1349448930-23976-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:15PWLEmIEoMWV8roWyUOu+kbM8WPb8gdE6moE2RrSEZ
 wpH81CFYKbfC0Wnn9ylbDjzA4r65FSacFpRIX/cZH+dLELvJSl
 82rirP0W0OBlJoCIoDbvZJJUOBLb2/DnjIk/26EbNwFIhyyJVx
 ccXHwh2u/avZanxfR+IGNmtJHT6iXL7nKXMzn3dJwI3XE8zrLl
 ctUKcC5whjeCJ71S8RKxNxLfWig9k285U5x1RI1Rnf7AafBzvY
 6FpgRTl0AkayYrmIvvuif35/EWVRL+UxKdDfNGAxIzwYvEhg2t
 SUXe7eBgpJUxpu45Gl8oUhnBmR+yYkI6WGH09K37/8wfXGulCE
 XPsihERSsaCUNDJCSJFSrsOeYmtH4a9+uPYM/TUKWdiUsoQrPa
 AllfrULIukg3yWXqs1I7A5V0iD/MM3Vv4Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ip_vs_set_timeout function sets timeouts for TCP and UDP, which
can be enabled independently at compile time. The debug message
always prints both timeouts that are passed into the function,
but if one is disabled, the message will show uninitialized data.

This splits the debug message into two separte IP_VS_DBG statements
that are in the same #ifdef section to ensure we only print the
text about what is actually going on.

Without this patch, building ARM ixp4xx_defconfig results in:

net/netfilter/ipvs/ip_vs_ctl.c: In function 'ip_vs_genl_set_cmd':
net/netfilter/ipvs/ip_vs_ctl.c:2238:47: warning: 't.udp_timeout' may be used uninitialized in this function [-Wuninitialized]
net/netfilter/ipvs/ip_vs_ctl.c:3322:28: note: 't.udp_timeout' was declared here
net/netfilter/ipvs/ip_vs_ctl.c:2238:47: warning: 't.tcp_fin_timeout' may be used uninitialized in this function [-Wuninitialized]
net/netfilter/ipvs/ip_vs_ctl.c:3322:28: note: 't.tcp_fin_timeout' was declared here
net/netfilter/ipvs/ip_vs_ctl.c:2238:47: warning: 't.tcp_timeout' may be used uninitialized in this function [-Wuninitialized]
net/netfilter/ipvs/ip_vs_ctl.c:3322:28: note: 't.tcp_timeout' was declared here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org
Cc: coreteam@netfilter.org
---
 net/netfilter/ipvs/ip_vs_ctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index f51013c..f3a66c3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2237,12 +2237,11 @@ static int ip_vs_set_timeout(struct net *net, struct ip_vs_timeout_user *u)
 	struct ip_vs_proto_data *pd;
 #endif
 
-	IP_VS_DBG(2, "Setting timeout tcp:%d tcpfin:%d udp:%d\n",
+#ifdef CONFIG_IP_VS_PROTO_TCP
+	IP_VS_DBG(2, "Setting timeout tcp:%d tcpfin:%d\n",
 		  u->tcp_timeout,
-		  u->tcp_fin_timeout,
-		  u->udp_timeout);
+		  u->tcp_fin_timeout);
 
-#ifdef CONFIG_IP_VS_PROTO_TCP
 	if (u->tcp_timeout) {
 		pd = ip_vs_proto_data_get(net, IPPROTO_TCP);
 		pd->timeout_table[IP_VS_TCP_S_ESTABLISHED]
@@ -2257,6 +2256,9 @@ static int ip_vs_set_timeout(struct net *net, struct ip_vs_timeout_user *u)
 #endif
 
 #ifdef CONFIG_IP_VS_PROTO_UDP
+	IP_VS_DBG(2, "Setting timeout udp:%d\n",
+		  u->udp_timeout);
+
 	if (u->udp_timeout) {
 		pd = ip_vs_proto_data_get(net, IPPROTO_UDP);
 		pd->timeout_table[IP_VS_UDP_S_NORMAL]
-- 
1.7.10

