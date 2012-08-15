Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2HOTtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:36409 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab2HOTtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 024/165] atm: br2684: Fix oops due to skb->dev being NULL
Date: Wed, 15 Aug 2012 15:46:08 -0400
Message-ID: <1345060109-9187-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fbe5e29ec1886967255e76946aaf537b8cc9b81e upstream.

This oops have been already fixed with commit

    27141666b69f535a4d63d7bc6d9e84ee5032f82a

    atm: [br2684] Fix oops due to skb->dev being NULL

    It happens that if a packet arrives in a VC between the call to open it on
    the hardware and the call to change the backend to br2684, br2684_regvcc
    processes the packet and oopses dereferencing skb->dev because it is
    NULL before the call to br2684_push().

but have been introduced again with commit

    b6211ae7f2e56837c6a4849316396d1535606e90

    atm: Use SKB queue and list helpers instead of doing it by-hand.

Signed-off-by: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/br2684.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index f3bae14..e9b5677 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -522,12 +522,13 @@ static int br2684_regvcc(struct atm_vcc *atmvcc, void __user * arg)
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	skb_queue_walk_safe(&queue, skb, tmp) {
-		struct net_device *dev = skb->dev;
+		struct net_device *dev;
+
+		br2684_push(atmvcc, skb);
+		dev = skb->dev;
 
 		dev->stats.rx_bytes -= skb->len;
 		dev->stats.rx_packets--;
-
-		br2684_push(atmvcc, skb);
 	}
 	__module_get(THIS_MODULE);
 	return 0;
-- 
1.7.12.rc2

