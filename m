Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab0E0USb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:18:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab0E0US3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U4m4eH3LaRrBZakq+2xT1n09vvk4Ja51rFzxVhu1566Rqto4PlPbT8Z7UQ4C5MWtqc
         yiBCzjFdIEXlpfBrEG72f41xj/7rbbcYNNwwDbvyLWCFrDeImOZt3Up9TrxuJZz+5IBw
         RQZF0qTj1WZG3OYYYrJVjoc7vz/J2fiIZdP2M=
Subject: Re: boot crash in arp_error_report() (Re: [GIT] Networking)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1274989637.2446.1.camel@edumazet-laptop>
References: <20100525.165945.39198480.davem@davemloft.net>
	 <20100527190652.GA20303@elte.hu>
	 <alpine.LFD.2.00.1005271213091.3689@i5.linux-foundation.org>
	 <1274989637.2446.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 22:18:24 +0200
Message-ID: <1274991504.2446.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 27 mai 2010 à 21:47 +0200, Eric Dumazet a écrit :

> I am looking at this bug report, as I am probably at fault, please give
> me one or two hour ;)

I believe problem comes from commit 7fee226ad2
(net: add a noref bit on skb dst)

We probably should add a WARN in __skb_queue_tail() and similar enqueue
 functions to catch other problems. I'll post a followup.

Thanks !

[PATCH] net: fix __neigh_event_send()

commit 7fee226ad23 (net: add a noref bit on skb dst) missed one spot
where an skb is enqueued, with a possibly not refcounted dst entry.

__neigh_event_send() inserts skb into arp_queue, so we must make sure
dst entry is refcounted, or dst entry can be freed by garbage collector
after caller exits from rcu protected section.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/core/neighbour.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bff3790..6ba1c0e 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -934,6 +934,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 				kfree_skb(buff);
 				NEIGH_CACHE_STAT_INC(neigh->tbl, unres_discards);
 			}
+			skb_dst_force(skb);
 			__skb_queue_tail(&neigh->arp_queue, skb);
 		}
 		rc = 1;


