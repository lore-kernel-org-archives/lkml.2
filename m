Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2B1Bir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:38:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2B1BGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.194.200 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010208.992455840@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/73] net_sched: Bug in netem reordering
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hagen Paul Pfeifer <hagen@jauu.net>

[ Upstream commit eb10192447370f19a215a8c2749332afa1199d46 ]

Not now, but it looks you are correct. q->qdisc is NULL until another
additional qdisc is attached (beside tfifo). See 50612537e9ab2969312.
The following patch should work.

From: Hagen Paul Pfeifer <hagen@jauu.net>

netem: catch NULL pointer by updating the real qdisc statistic

Reported-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -381,8 +381,8 @@ static int netem_enqueue(struct sk_buff
 		q->counter = 0;
 
 		__skb_queue_head(&q->qdisc->q, skb);
-		q->qdisc->qstats.backlog += qdisc_pkt_len(skb);
-		q->qdisc->qstats.requeues++;
+		sch->qstats.backlog += qdisc_pkt_len(skb);
+		sch->qstats.requeues++;
 		ret = NET_XMIT_SUCCESS;
 	}
 


