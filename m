Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2HOVdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:33:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2HOVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:33:17 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>
Subject: [PATCH 12/14] dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
Date: Wed, 15 Aug 2012 23:31:55 +0200
Message-Id: <1345066317-22512-13-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CCID3 code fails to initialize the trailing padding bytes of struct
tfrc_tx_info added for alignment on 64 bit architectures. It that for
potentially leaks four bytes kernel stack via the getsockopt() syscall.
Add an explicit memset(0) before filling the structure to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 net/dccp/ccids/ccid3.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index d65e987..119c043 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -535,6 +535,7 @@ static int ccid3_hc_tx_getsockopt(struct sock *sk, const int optname, int len,
 	case DCCP_SOCKOPT_CCID_TX_INFO:
 		if (len < sizeof(tfrc))
 			return -EINVAL;
+		memset(&tfrc, 0, sizeof(tfrc));
 		tfrc.tfrctx_x	   = hc->tx_x;
 		tfrc.tfrctx_x_recv = hc->tx_x_recv;
 		tfrc.tfrctx_x_calc = hc->tx_x_calc;
-- 
1.7.10.4

