Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1HNQXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:23:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab1HNQIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.405297273@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>, Michal Soltys <soltys@ziu.info>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [49/90] sch_sfq: fix sfq_enqueue()
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit e1738bd9cecc5c867b0e2996470c1ff20f66ba79 ]

commit 8efa88540635 (sch_sfq: avoid giving spurious NET_XMIT_CN signals)
forgot to call qdisc_tree_decrease_qlen() to signal upper levels that a
packet (from another flow) was dropped, leading to various problems.

With help from Michal Soltys and Michal Pokrywka, who did a bisection.

Bugzilla ref: https://bugzilla.kernel.org/show_bug.cgi?id=39372
Debian ref: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=631945

Reported-by: Lucas Bocchi <lucas.bocchi@gmail.com>
Reported-and-bisected-by: Michal Pokrywka <wolfmoon@o2.pl>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Michal Soltys <soltys@ziu.info>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_sfq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -410,7 +410,12 @@ sfq_enqueue(struct sk_buff *skb, struct
 	/* Return Congestion Notification only if we dropped a packet
 	 * from this flow.
 	 */
-	return (qlen != slot->qlen) ? NET_XMIT_CN : NET_XMIT_SUCCESS;
+	if (qlen != slot->qlen)
+		return NET_XMIT_CN;
+
+	/* As we dropped a packet, better let upper stack know this */
+	qdisc_tree_decrease_qlen(sch, 1);
+	return NET_XMIT_SUCCESS;
 }
 
 static struct sk_buff *


