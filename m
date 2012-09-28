Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032934Ab2I1V5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:57:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031713Ab2I1UW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 019/218] dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
Date: Fri, 28 Sep 2012 13:13:56 -0700
Message-Id: <20120928201503.537526849@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/ccids/ccid3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -531,6 +531,7 @@ static int ccid3_hc_tx_getsockopt(struct
 	case DCCP_SOCKOPT_CCID_TX_INFO:
 		if (len < sizeof(tfrc))
 			return -EINVAL;
+		memset(&tfrc, 0, sizeof(tfrc));
 		tfrc.tfrctx_x	   = hc->tx_x;
 		tfrc.tfrctx_x_recv = hc->tx_x_recv;
 		tfrc.tfrctx_x_calc = hc->tx_x_calc;


