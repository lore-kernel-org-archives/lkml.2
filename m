Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2AYIqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:46:43 -0500
Received: from 5-meo-dmt.ynet.sk ([147.175.167.220]:53563 "EHLO
	5-meo-dmt.ynet.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2AYIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:46:42 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.499
Date: Wed, 25 Jan 2012 09:43:15 +0100 (CET)
From: Stefan Gula <steweg@ynet.sk>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <26709175.701327480995351.JavaMail.root@5-MeO-DMT.ynet.sk>
In-Reply-To: <30372884.681327480899559.JavaMail.root@5-MeO-DMT.ynet.sk>
Subject: [patch v1, kernel 3.2.1] RTNETLINK adjusting values of
 min_ifinfo_dump_size
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [15.195.185.76]
X-Mailer: Zimbra 5.0.8_GA_2462.UBUNTU6 (ZimbraWebClient - FF3.0 (Win)/5.0.8_GA_2462.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@gmail.com>

This patch extends the rtnetlink.c. The problem is that calcit, which
returns the value min_ifinfo_dump_size, is called without ability to
get device info as well (struct net_device *dev is not accessible from
it). This create a problem if required size of struct sk_buff *skb is
not enough big to comply with all data returned by fill_info function
for the interface that required size can vary over time, e.g. some
dynamic structures will be putted to skb like hlists or lists. To do
this patch extends the do_setlink function with recalculating of
min_ifinfo_dump_size accordingly to device type and get_size
functions.

Signed-off-by: Stefan Gula <steweg@gmail.com>

---

code needed to be ok before I can resubmit my macvlan source mode patch

--- linux-3.2.1-orig/net/core/rtnetlink.c	2012-01-12 20:42:45.000000000 +0100
+++ linux/net/core/rtnetlink.c	2012-01-24 14:26:58.083219352 +0100
@@ -1506,6 +1506,9 @@ errout:
 
 	if (send_addr_notify)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	min_ifinfo_dump_size = max_t(u16, if_nlmsg_size(dev),
+					min_ifinfo_dump_size);
+
 	return err;
 }
