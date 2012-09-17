Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2IQBHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:07:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33767 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab2IQAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:52 -0400
Message-Id: <20120917003635.355910562@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 066/135] dccp: fix info leak via  getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 7b07f8eb75aa3097cdfd4f6eac3da49db787381d ]

The CCID3 code fails to initialize the trailing padding bytes of struct
tfrc_tx_info added for alignment on 64 bit architectures. It that for
potentially leaks four bytes kernel stack via the getsockopt() syscall.
Add an explicit memset(0) before filling the structure to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dccp/ccids/ccid3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index 3d604e1..4caf63f 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -532,6 +532,7 @@ static int ccid3_hc_tx_getsockopt(struct sock *sk, const int optname, int len,
 	case DCCP_SOCKOPT_CCID_TX_INFO:
 		if (len < sizeof(tfrc))
 			return -EINVAL;
+		memset(&tfrc, 0, sizeof(tfrc));
 		tfrc.tfrctx_x	   = hc->tx_x;
 		tfrc.tfrctx_x_recv = hc->tx_x_recv;
 		tfrc.tfrctx_x_calc = hc->tx_x_calc;


