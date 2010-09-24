Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab0IXQfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:11 -0400
Received: from kroah.org ([198.145.64.141]:37083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab0IXQfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:45 2010
Message-Id: <20100924163345.161283548@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [13/68] tcp: Prevent overzealous packetization by SWS logic.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

[ Upstream commit 01f83d69844d307be2aa6fea88b0e8fe5cbdb2f4 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/tcp.h |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -511,8 +511,22 @@ extern unsigned int tcp_current_mss(stru
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


