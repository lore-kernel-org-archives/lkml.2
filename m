Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0LAQDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:03:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47901 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0LAQDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qagjbO4cpX/PdGG4E0IaBAgwM2oHWePw6n9lFuKqYO1LR74LDk+N3Bdm+nsE0SZK+z
         uoL5OKZE2WY0QBssS+IGV++ww9DelT991i2Xxe4kdlCgDAZa9oHF7kmYLC2TR8Tk0tGM
         OO05rIYmLVe+OjbARTSE9MiDCsqhUZszEDm2Q=
Subject: Re: [Patch] net: kill an RCU warning in inet_fill_link_af()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        Thomas Graf <tgraf@infradead.org>
In-Reply-To: <1291202063-6239-1-git-send-email-amwang@redhat.com>
References: <1291202063-6239-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 17:03:06 +0100
Message-ID: <1291219386.2856.924.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 décembre 2010 à 19:14 +0800, Amerigo Wang a écrit :
> From: WANG Cong <amwang@redhat.com>
> 
> The latest net-next-2.6 triggers an RCU warning during boot,
> lockdep complains that in inet_fill_link_af() we call rcu_dereference_check()
> without rcu_read_lock() protection.
> 
> This patch fixes it by replacing __in_dev_get_rcu() with in_dev_get().

Here is a better version, thanks a lot for your report and initial
patch.


[PATCH net-next-2.6] net: kill an RCU warning in inet_fill_link_af()

commits 9f0f7272 (ipv4: AF_INET link address family) and cf7afbfeb8c
(rtnl: make link af-specific updates atomic) used incorrect
__in_dev_get_rcu() in RTNL protected contexts, triggering PROVE_RCU
warnings.

Switch to __in_dev_get_rtnl(), wich is more appropriate, since we hold
RTNL.

Based on a report and initial patch from Amerigo Wang.

Reported-by: Amerigo Wang <amwang@redhat.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Graf <tgraf@infradead.org>
---
 net/ipv4/devinet.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index d9f71ba..3b06770 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1258,7 +1258,7 @@ errout:
 
 static size_t inet_get_link_af_size(const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 
 	if (!in_dev)
 		return 0;
@@ -1268,7 +1268,7 @@ static size_t inet_get_link_af_size(const struct net_device *dev)
 
 static int inet_fill_link_af(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	struct nlattr *nla;
 	int i;
 
@@ -1295,7 +1295,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int err, rem;
 
-	if (dev && !__in_dev_get_rcu(dev))
+	if (dev && !__in_dev_get_rtnl(dev))
 		return -EAFNOSUPPORT;
 
 	err = nla_parse_nested(tb, IFLA_INET_MAX, nla, inet_af_policy);
@@ -1319,7 +1319,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 
 static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int rem;
 


