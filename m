Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2I1Sxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:53:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2I1Sxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:53:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anton Mich <lp2s1h@gmail.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 001/262] codel: refine one condition to avoid a nul rec_inv_sqrt
Date: Fri, 28 Sep 2012 11:48:50 -0700
Message-Id: <20120928182958.162174904@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2359a47671fc4fb0fe5e9945f76c2cb10792c0f8 ]

One condition before codel_Newton_step() was not good if
we never left the dropping state for a flow. As a result
rec_inv_sqrt was 0, instead of the ~0 initial value.

codel control law was then set to a very aggressive mode, dropping
many packets before reaching 'target' and recovering from this problem.

To keep codel_vars_init() as efficient as possible, refine
the condition to make sure rec_inv_sqrt initial value is correct

Many thanks to Anton Mich for discovering the issue and suggesting
a fix.

Reported-by: Anton Mich <lp2s1h@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/codel.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -305,6 +305,8 @@ static struct sk_buff *codel_dequeue(str
 			}
 		}
 	} else if (drop) {
+		u32 delta;
+
 		if (params->ecn && INET_ECN_set_ce(skb)) {
 			stats->ecn_mark++;
 		} else {
@@ -320,9 +322,11 @@ static struct sk_buff *codel_dequeue(str
 		 * assume that the drop rate that controlled the queue on the
 		 * last cycle is a good starting point to control it now.
 		 */
-		if (codel_time_before(now - vars->drop_next,
+		delta = vars->count - vars->lastcount;
+		if (delta > 1 &&
+		    codel_time_before(now - vars->drop_next,
 				      16 * params->interval)) {
-			vars->count = (vars->count - vars->lastcount) | 1;
+			vars->count = delta;
 			/* we dont care if rec_inv_sqrt approximation
 			 * is not very precise :
 			 * Next Newton steps will correct it quadratically.


