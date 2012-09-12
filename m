Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2ILME5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:04:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51178 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753792Ab2ILMEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:04:55 -0400
Message-ID: <1347451493.8707.4.camel@joe2Laptop>
Subject: [PATCH V2] netfilter/iptables: Fix log-level processing
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: auto75914331@hushmail.com, Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Sep 2012 05:04:53 -0700
In-Reply-To: <1347437245.13103.697.camel@edumazet-glaptop>
References: <20120912045120.9E1A76F446@smtp.hushmail.com>
	 <1347435973.2456.23.camel@joe2Laptop>
	 <1347437245.13103.697.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

auto75914331@hushmail.com reports that iptables does not correctly
output the KERN_<level>.

$IPTABLES -A RULE_0_in  -j LOG  --log-level notice --log-prefix "DENY  in: "

result with linux 3.6-rc5
Sep 12 06:37:29 xxxxx kernel: <5>DENY  in: IN=eth0 OUT= MAC=.......

result with linux 3.5.3 and older:
Sep  9 10:43:01 xxxxx kernel: DENY  in: IN=eth0 OUT= MAC......

commit 04d2c8c83d0
("printk: convert the format for KERN_<LEVEL> to a 2 byte pattern")
updated the syslog header style but did not update netfilter uses.

Do so.

Signed-off-by: Joe Perches <joe@perches.com>
cc: auto75914331@hushmail.com
---
v2: Use KERN_SOH and string concatenation instead of "%c" KERN_SOH_ASCII
as suggested by Eric Dumazet.

 net/bridge/netfilter/ebt_log.c |    2 +-
 net/netfilter/xt_LOG.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f88ee53..92de5e5 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -80,7 +80,7 @@ ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 	unsigned int bitmask;
 
 	spin_lock_bh(&ebt_log_lock);
-	printk("<%c>%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
+	printk(KERN_SOH "%c%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
 	       '0' + loginfo->u.log.level, prefix,
 	       in ? in->name : "", out ? out->name : "",
 	       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index ff5f75f..d1609dd 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -436,8 +436,8 @@ log_packet_common(struct sbuff *m,
 		  const struct nf_loginfo *loginfo,
 		  const char *prefix)
 {
-	sb_add(m, "<%d>%sIN=%s OUT=%s ", loginfo->u.log.level,
-	       prefix,
+	sb_add(m, KERN_SOH "%c%sIN=%s OUT=%s ",
+	       '0' + loginfo->u.log.level, prefix,
 	       in ? in->name : "",
 	       out ? out->name : "");
 #ifdef CONFIG_BRIDGE_NETFILTER



