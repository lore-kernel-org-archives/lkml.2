Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2JGXWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38348 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab2JGXW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:28 -0400
Message-Id: <20121007225846.722454035@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Denys Fedoryschenko <denys@visp.net.lb>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 087/108] net-sched: sch_cbq: avoid infinite loop
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bdfc87f7d1e253e0a61e2fc6a75ea9d76f7fc03a ]

Its possible to setup a bad cbq configuration leading to
an infinite loop in cbq_classify()

DEV_OUT=eth0
ICMP="match ip protocol 1 0xff"
U32="protocol ip u32"
DST="match ip dst"
tc qdisc add dev $DEV_OUT root handle 1: cbq avpkt 1000 \
	bandwidth 100mbit
tc class add dev $DEV_OUT parent 1: classid 1:1 cbq \
	rate 512kbit allot 1500 prio 5 bounded isolated
tc filter add dev $DEV_OUT parent 1: prio 3 $U32 \
	$ICMP $DST 192.168.3.234 flowid 1:

Reported-by: Denys Fedoryschenko <denys@visp.net.lb>
Tested-by: Denys Fedoryschenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_cbq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 24d94c0..599f67a 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -250,10 +250,11 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 			else if ((cl = defmap[res.classid & TC_PRIO_MAX]) == NULL)
 				cl = defmap[TC_PRIO_BESTEFFORT];
 
-			if (cl == NULL || cl->level >= head->level)
+			if (cl == NULL)
 				goto fallback;
 		}
-
+		if (cl->level >= head->level)
+			goto fallback;
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:


