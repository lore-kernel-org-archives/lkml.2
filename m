Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1BBBDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:03:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab1BBAn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960531"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, ak@linux.intel.com, bhutchings@solarflare.com,
        william.allen.simpson@gmail.com, davem@davemloft.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [50/139] tcp: protect sysctl_tcp_cookie_size reads
Message-Id: <20110202004406.2E84C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit f19872575ff7819a3723154657a497d9bca66b33 ]

Make sure sysctl_tcp_cookie_size is read once in
tcp_cookie_size_check(), or we might return an illegal value to caller
if sysctl_tcp_cookie_size is changed by another cpu.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: William Allen Simpson <william.allen.simpson@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6.35.y/net/ipv4/tcp_output.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/tcp_output.c
+++ linux-2.6.35.y/net/ipv4/tcp_output.c
@@ -390,27 +390,30 @@ struct tcp_out_options {
  */
 static u8 tcp_cookie_size_check(u8 desired)
 {
-	if (desired > 0) {
+	int cookie_size;
+
+	if (desired > 0)
 		/* previously specified */
 		return desired;
-	}
-	if (sysctl_tcp_cookie_size <= 0) {
+
+	cookie_size = ACCESS_ONCE(sysctl_tcp_cookie_size);
+	if (cookie_size <= 0)
 		/* no default specified */
 		return 0;
-	}
-	if (sysctl_tcp_cookie_size <= TCP_COOKIE_MIN) {
+
+	if (cookie_size <= TCP_COOKIE_MIN)
 		/* value too small, specify minimum */
 		return TCP_COOKIE_MIN;
-	}
-	if (sysctl_tcp_cookie_size >= TCP_COOKIE_MAX) {
+
+	if (cookie_size >= TCP_COOKIE_MAX)
 		/* value too large, specify maximum */
 		return TCP_COOKIE_MAX;
-	}
-	if (0x1 & sysctl_tcp_cookie_size) {
+
+	if (cookie_size & 1)
 		/* 8-bit multiple, illegal, fix it */
-		return (u8)(sysctl_tcp_cookie_size + 0x1);
-	}
-	return (u8)sysctl_tcp_cookie_size;
+		cookie_size++;
+
+	return (u8)cookie_size;
 }
 
 /* Write previously computed TCP options to the packet.
