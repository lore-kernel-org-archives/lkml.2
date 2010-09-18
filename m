Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0IRTiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:38:55 -0400
Received: from kroah.org ([198.145.64.141]:43212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab0IRTOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:50 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.636561309@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [016/129] netfilter: fix CONFIG_COMPAT support
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Westphal <fw@strlen.de>

commit cca77b7c81876d819a5806f408b3c29b5b61a815 upstream.

commit f3c5c1bfd430858d3a05436f82c51e53104feb6b
(netfilter: xtables: make ip_tables reentrant) forgot to
also compute the jumpstack size in the compat handlers.

Result is that "iptables -I INPUT -j userchain" turns into -j DROP.

Reported by Sebastian Roesner on #netfilter, closes
http://bugzilla.netfilter.org/show_bug.cgi?id=669.

Note: arptables change is compile-tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/arp_tables.c |    3 +++
 net/ipv4/netfilter/ip_tables.c  |    3 +++
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 3 files changed, 9 insertions(+)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1420,6 +1420,9 @@ static int translate_compat_table(const
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(arpt_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1747,6 +1747,9 @@ translate_compat_table(struct net *net,
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(ipt_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1765,6 +1765,9 @@ translate_compat_table(struct net *net,
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(ip6t_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*


