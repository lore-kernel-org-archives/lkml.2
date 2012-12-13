Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab2LMOW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:22:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab2LMONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulrich Weber <ulrich.weber@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 211/241] netfilter: nf_nat: don't check for port change on ICMP tuples
Date: Thu, 13 Dec 2012 11:59:36 -0200
Message-Id: <1355407206-17100-212-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Weber <ulrich.weber@sophos.com>

commit 38fe36a248ec3228f8e6507955d7ceb0432d2000 upstream.

ICMP tuples have id in src and type/code in dst.
So comparing src.u.all with dst.u.all will always fail here
and ip_xfrm_me_harder() is called for every ICMP packet,
even if there was no NAT.

This patch is a backport of:

[ 38fe36a netfilter: nf_nat: don't check for port change on ICMP tuples ]

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/netfilter/nf_nat_standalone.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 3828a42..da4098f 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -194,7 +194,8 @@ nf_nat_out(unsigned int hooknum,
 
 		if ((ct->tuplehash[dir].tuple.src.u3.ip !=
 		     ct->tuplehash[!dir].tuple.dst.u3.ip) ||
-		    (ct->tuplehash[dir].tuple.src.u.all !=
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
 		     ct->tuplehash[!dir].tuple.dst.u.all)
 		   )
 			return ip_xfrm_me_harder(skb) == 0 ? ret : NF_DROP;
@@ -230,7 +231,8 @@ nf_nat_local_fn(unsigned int hooknum,
 				ret = NF_DROP;
 		}
 #ifdef CONFIG_XFRM
-		else if (ct->tuplehash[dir].tuple.dst.u.all !=
+		else if (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+			 ct->tuplehash[dir].tuple.dst.u.all !=
 			 ct->tuplehash[!dir].tuple.src.u.all)
 			if (ip_xfrm_me_harder(skb))
 				ret = NF_DROP;
-- 
1.7.9.5

