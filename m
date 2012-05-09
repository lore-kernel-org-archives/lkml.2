Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2EIGUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:20:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38928 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226Ab2EIFxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:21 -0400
Message-Id: <20120509055039.814414757@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 072/167] [PATCH 12/26] tcp: fix tcp_rcv_rtt_update() use of an unscaled RTT
 sample
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 18a223e0b9ec8979320ba364b47c9772391d6d05 ]

Fix a code path in tcp_rcv_rtt_update() that was comparing scaled and
unscaled RTT samples.

The intent in the code was to only use the 'm' measurement if it was a
new minimum.  However, since 'm' had not yet been shifted left 3 bits
but 'new_sample' had, this comparison would nearly always succeed,
leading us to erroneously set our receive-side RTT estimate to the 'm'
sample when that sample could be nearly 8x too high to use.

The overall effect is to often cause the receive-side RTT estimate to
be significantly too large (up to 40% too large for brief periods in
my tests).

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e4d1e4a..4c46fa7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -473,8 +473,11 @@ static void tcp_rcv_rtt_update(struct tcp_sock *tp, u32 sample, int win_dep)
 		if (!win_dep) {
 			m -= (new_sample >> 3);
 			new_sample += m;
-		} else if (m < new_sample)
-			new_sample = m << 3;
+		} else {
+			m <<= 3;
+			if (m < new_sample)
+				new_sample = m;
+		}
 	} else {
 		/* No previous measure. */
 		new_sample = m << 3;
-- 
1.7.10



