Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1ABHYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:35997 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1ABHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 119/260] tcp: Prevent overzealous packetization by SWS logic.
Date: Sun,  2 Jan 2011 02:16:55 -0500
Message-Id: <1293952756-15010-120-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:22:19.0727 (UTC) FILETIME=[CA8775F0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

commit 01f83d69844d307be2aa6fea88b0e8fe5cbdb2f4 upstream.

If peer uses tiny MSS (say, 75 bytes) and similarly tiny advertised
window, the SWS logic will packetize to half the MSS unnecessarily.

This causes problems with some embedded devices.

However for large MSS devices we do want to half-MSS packetize
otherwise we never get enough packets into the pipe for things
like fast retransmit and recovery to work.

Be careful also to handle the case where MSS > window, otherwise
we'll never send until the probe timer.

Reported-by: ツ Leandro Melo de Sales <leandroal@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/tcp.h |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index cae8c39..91cdffd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -518,8 +518,22 @@ extern unsigned int tcp_current_mss(struct sock *sk);
 /* Bound MSS / TSO packet size with the half of the window */
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
 {
-	if (tp->max_window && pktsize > (tp->max_window >> 1))
-		return max(tp->max_window >> 1, 68U - tp->tcp_header_len);
+	int cutoff;
+
+	/* When peer uses tiny windows, there is no use in packetizing
+	 * to sub-MSS pieces for the sake of SWS or making sure there
+	 * are enough packets in the pipe for fast recovery.
+	 *
+	 * On the other hand, for extremely large MSS devices, handling
+	 * smaller than MSS windows in this way does make sense.
+	 */
+	if (tp->max_window >= 512)
+		cutoff = (tp->max_window >> 1);
+	else
+		cutoff = tp->max_window;
+
+	if (cutoff && pktsize > cutoff)
+		return max_t(int, cutoff, 68U - tp->tcp_header_len);
 	else
 		return pktsize;
 }
-- 
1.7.3.3

