Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab1GMJaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:30:46 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1915 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965169Ab1GMJao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:30:44 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Arend van Spriel" <arend@broadcom.com>
To: davem@davemloft.net
cc: "Arend van Spriel" <arend@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: [PATCH] net: change return values in mac_pton() function
Date: Wed, 13 Jul 2011 11:30:24 +0200
Message-ID: <1310549424-5484-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
X-WSS-ID: 6203B95C62O24319609-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original commit adding this function noted a diverge from usual
0=success/-E=fail, but no motivation for it. To stay consistent this
commit adheres to the usual approach. The callers check for result
is changed from 'if(!mac_pton(x, y))' to 'if(mac_pton(x,y) < 0)'.

Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/netconsole.c |    2 +-
 net/core/netpoll.c       |    2 +-
 net/core/pktgen.c        |    4 ++--
 net/core/utils.c         |   10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index dfc8272..2e8adba 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -437,7 +437,7 @@ static ssize_t store_remote_mac(struct netconsole_target *nt,
 		return -EINVAL;
 	}
 
-	if (!mac_pton(buf, remote_mac))
+	if (mac_pton(buf, remote_mac) < 0)
 		return -EINVAL;
 	if (buf[3 * ETH_ALEN - 1] && buf[3 * ETH_ALEN - 1] != '\n')
 		return -EINVAL;
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index adf84dd..6b70699 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -691,7 +691,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 
 	if (*cur != 0) {
 		/* MAC address */
-		if (!mac_pton(cur, np->remote_mac))
+		if (mac_pton(cur, np->remote_mac) < 0)
 			goto parse_failed;
 	}
 
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index f76079c..f17ab6a 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1429,7 +1429,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (copy_from_user(valstr, &user_buffer[i], len))
 			return -EFAULT;
 
-		if (!mac_pton(valstr, pkt_dev->dst_mac))
+		if (mac_pton(valstr, pkt_dev->dst_mac) < 0)
 			return -EINVAL;
 		/* Set up Dest MAC */
 		memcpy(&pkt_dev->hh[0], pkt_dev->dst_mac, ETH_ALEN);
@@ -1446,7 +1446,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (copy_from_user(valstr, &user_buffer[i], len))
 			return -EFAULT;
 
-		if (!mac_pton(valstr, pkt_dev->src_mac))
+		if (mac_pton(valstr, pkt_dev->src_mac) < 0)
 			return -EINVAL;
 		/* Set up Src MAC */
 		memcpy(&pkt_dev->hh[6], pkt_dev->src_mac, ETH_ALEN);
diff --git a/net/core/utils.c b/net/core/utils.c
index 386e263f..73299f1 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -304,20 +304,20 @@ int mac_pton(const char *s, u8 *mac)
 
 	/* XX:XX:XX:XX:XX:XX */
 	if (strlen(s) < 3 * ETH_ALEN - 1)
-		return 0;
+		return -EINVAL;
 
 	/* Don't dirty result unless string is valid MAC. */
 	for (i = 0; i < ETH_ALEN; i++) {
 		if (!strchr("0123456789abcdefABCDEF", s[i * 3]))
-			return 0;
+			return -EINVAL;
 		if (!strchr("0123456789abcdefABCDEF", s[i * 3 + 1]))
-			return 0;
+			return -EINVAL;
 		if (i != ETH_ALEN - 1 && s[i * 3 + 2] != ':')
-			return 0;
+			return -EINVAL;
 	}
 	for (i = 0; i < ETH_ALEN; i++) {
 		mac[i] = (hex_to_bin(s[i * 3]) << 4) | hex_to_bin(s[i * 3 + 1]);
 	}
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(mac_pton);
-- 
1.7.4.1


