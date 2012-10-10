Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2JJWyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:54:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47573 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757728Ab2JJWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:36 -0400
X-Sasl-enc: 8EHWJB4zxQSCNmoHfr2D8PDEjV6E7gXda+dPwANuJnRi 1349909675
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Denys Fedoryschenko <denys@visp.net.lb>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 039/133] net-sched: sch_cbq: avoid infinite loop
Date: Thu, 11 Oct 2012 07:51:05 +0900
Message-Id: <20121010224901.530933898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -250,10 +250,11 @@ cbq_classify(struct sk_buff *skb, struct
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


