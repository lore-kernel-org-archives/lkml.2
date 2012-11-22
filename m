Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab2KVWbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab2KVSdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ulrich Weber <ulrich.weber@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 043/171] netfilter: nf_nat: dont check for port change on ICMP tuples
Date: Wed, 21 Nov 2012 16:39:49 -0800
Message-Id: <20121122004037.681496012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Weber <ulrich.weber@sophos.com>

commit 38fe36a248ec3228f8e6507955d7ceb0432d2000 upstream.

ICMP tuples have id in src and type/code in dst.
So comparing src.u.all with dst.u.all will always fail here
and ip_xfrm_me_harder() is called for every ICMP packet,
even if there was no NAT.

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/ipv4/netfilter/nf_nat_standalone.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


