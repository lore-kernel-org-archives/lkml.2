Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab2JKCMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:12:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35005 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933216Ab2JKCM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:27 -0400
X-Sasl-enc: F8P8YIfxkzDWcoMBncrvFLZlLIb/32sf5HKcHcdkUwx0 1349921546
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/84] ipv6: release reference of ip6_null_entrys dst entry in __ip6_del_rt
Date: Thu, 11 Oct 2012 11:03:11 +0900
Message-Id: <20121011015421.961392374@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 6825a26c2dc21eb4f8df9c06d3786ddec97cf53b ]

as we hold dst_entry before we call __ip6_del_rt,
so we should alse call dst_release not only return
-ENOENT when the rt6_info is ip6_null_entry.

and we already hold the dst entry, so I think it's
safe to call dst_release out of the write-read lock.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1399,17 +1399,18 @@ static int __ip6_del_rt(struct rt6_info
 	struct fib6_table *table;
 	struct net *net = dev_net(rt->rt6i_dev);
 
-	if (rt == net->ipv6.ip6_null_entry)
-		return -ENOENT;
+	if (rt == net->ipv6.ip6_null_entry) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	table = rt->rt6i_table;
 	write_lock_bh(&table->tb6_lock);
-
 	err = fib6_del(rt, info);
-	dst_release(&rt->dst);
-
 	write_unlock_bh(&table->tb6_lock);
 
+out:
+	dst_release(&rt->dst);
 	return err;
 }
 


