Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161019Ab2JSDOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:14:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:51569 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab2JSCro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 42/62] netfilter: limit, hashlimit: avoid duplicated inline
Date: Thu, 18 Oct 2012 19:45:10 -0700
Message-Id: <20121019024302.764086176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 7a909ac70f6b0823d9f23a43f19598d4b57ac901 upstream.

credit_cap can be set to credit, which avoids inlining user2credits
twice. Also, remove inline keyword and let compiler decide.

old:
    684     192       0     876     36c net/netfilter/xt_limit.o
   4927     344      32    5303    14b7 net/netfilter/xt_hashlimit.o
now:
    668     192       0     860     35c net/netfilter/xt_limit.o
   4793     344      32    5169    1431 net/netfilter/xt_hashlimit.o

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |    8 +++-----
 net/netfilter/xt_limit.c     |    5 ++---
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -389,8 +389,7 @@ static void htable_put(struct xt_hashlim
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 /* Precision saver. */
-static inline u_int32_t
-user2credits(u_int32_t user)
+static u32 user2credits(u32 user)
 {
 	/* If multiplying would overflow... */
 	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
@@ -400,7 +399,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_HASHLIMIT_SCALE;
 }
 
-static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
+static void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 {
 	dh->rateinfo.credit += (now - dh->rateinfo.prev) * CREDITS_PER_JIFFY;
 	if (dh->rateinfo.credit > dh->rateinfo.credit_cap)
@@ -535,8 +534,7 @@ hashlimit_mt(const struct sk_buff *skb,
 		dh->rateinfo.prev = jiffies;
 		dh->rateinfo.credit = user2credits(hinfo->cfg.avg *
 		                      hinfo->cfg.burst);
-		dh->rateinfo.credit_cap = user2credits(hinfo->cfg.avg *
-		                          hinfo->cfg.burst);
+		dh->rateinfo.credit_cap = dh->rateinfo.credit;
 		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
 	} else {
 		/* update expiration timeout */
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -88,8 +88,7 @@ limit_mt(const struct sk_buff *skb, stru
 }
 
 /* Precision saver. */
-static u_int32_t
-user2credits(u_int32_t user)
+static u32 user2credits(u32 user)
 {
 	/* If multiplying would overflow... */
 	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
@@ -123,7 +122,7 @@ static int limit_mt_check(const struct x
 		   128. */
 		priv->prev = jiffies;
 		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
-		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
+		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
 	return 0;


