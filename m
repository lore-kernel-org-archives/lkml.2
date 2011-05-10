Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1EJDr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:47:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1EJDrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MINS1IUB3Prsr1sG2Ecasb02xw/D7lnsummtUKtcbSBVfZDRfUmCuyU71Sy3Eb5Fle
         xqm+nON2+OSrXbtl+n76Zw/F22/1TyNVyR/NbKStoE0eDqgUE2nBw+97Xm8QX2ma/eD2
         nUvpQtm5rLck3+H3ynqUefN8bKb6UEpp9uFM4=
Subject: Re: 2.6.39-rc6-mmotm0506 - another lockdep splat (networking this
 time)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1304994188.3050.17.camel@edumazet-laptop>
References: <6954.1304989523@localhost>
	 <1304994188.3050.17.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 05:47:51 +0200
Message-ID: <1304999271.3050.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 mai 2011 à 04:23 +0200, Eric Dumazet a écrit :

> Thanks for the report, I am taking a look how to fix this.
> 

OK here is the official patch submission

Thanks Valdis !

[PATCH net-next-2.6] net: fix two lockdep splats

Commit e67f88dd12f6 (net: dont hold rtnl mutex during netlink dump
callbacks) switched rtnl protection to RCU, but we forgot to adjust two
rcu_dereference() lockdep annotations :

inet_get_link_af_size() or inet_fill_link_af() might be called with
rcu_read_lock or rtnl held, so use rcu_dereference_rtnl()
instead of rtnl_dereference()

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/devinet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index cd9ca08..6b1eb92 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1369,7 +1369,7 @@ errout:
 
 static size_t inet_get_link_af_size(const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rtnl(dev);
+	struct in_device *in_dev = rcu_dereference_rtnl(dev->ip_ptr);
 
 	if (!in_dev)
 		return 0;
@@ -1379,7 +1379,7 @@ static size_t inet_get_link_af_size(const struct net_device *dev)
 
 static int inet_fill_link_af(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rtnl(dev);
+	struct in_device *in_dev = rcu_dereference_rtnl(dev->ip_ptr);
 	struct nlattr *nla;
 	int i;
 


