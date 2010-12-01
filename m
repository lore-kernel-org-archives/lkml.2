Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0LALKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0LALKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:10:35 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [Patch] net: kill an RCU warning in inet_fill_link_af()
Date: Wed,  1 Dec 2010 19:14:23 +0800
Message-Id: <1291202063-6239-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>

The latest net-next-2.6 triggers an RCU warning during boot,
lockdep complains that in inet_fill_link_af() we call rcu_dereference_check()
without rcu_read_lock() protection.

This patch fixes it by replacing __in_dev_get_rcu() with in_dev_get().

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index d9f71ba..73baed8 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1258,31 +1258,36 @@ errout:
 
 static size_t inet_get_link_af_size(const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = in_dev_get(dev);
 
 	if (!in_dev)
 		return 0;
 
+	in_dev_put(in_dev);
 	return nla_total_size(IPV4_DEVCONF_MAX * 4); /* IFLA_INET_CONF */
 }
 
 static int inet_fill_link_af(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = in_dev_get(dev);
 	struct nlattr *nla;
-	int i;
+	int i, ret = 0;
 
 	if (!in_dev)
 		return -ENODATA;
 
 	nla = nla_reserve(skb, IFLA_INET_CONF, IPV4_DEVCONF_MAX * 4);
-	if (nla == NULL)
-		return -EMSGSIZE;
+	if (nla == NULL) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
 
 	for (i = 0; i < IPV4_DEVCONF_MAX; i++)
 		((u32 *) nla_data(nla))[i] = in_dev->cnf.data[i];
 
-	return 0;
+out:
+	in_dev_put(in_dev);
+	return ret;
 }
 
 static const struct nla_policy inet_af_policy[IFLA_INET_MAX+1] = {
@@ -1293,11 +1298,14 @@ static int inet_validate_link_af(const struct net_device *dev,
 				 const struct nlattr *nla)
 {
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
+	struct in_device *in_dev = in_dev_get(dev);
 	int err, rem;
 
-	if (dev && !__in_dev_get_rcu(dev))
+	if (dev && !in_dev)
 		return -EAFNOSUPPORT;
 
+	in_dev_put(in_dev);
+
 	err = nla_parse_nested(tb, IFLA_INET_MAX, nla, inet_af_policy);
 	if (err < 0)
 		return err;
@@ -1319,7 +1327,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 
 static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = in_dev_get(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int rem;
 
@@ -1334,6 +1342,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 			ipv4_devconf_set(in_dev, nla_type(a), nla_get_u32(a));
 	}
 
+	in_dev_put(in_dev);
 	return 0;
 }
 
