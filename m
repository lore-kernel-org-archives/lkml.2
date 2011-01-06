Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1AFAwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:52:05 -0500
Received: from kroah.org ([198.145.64.141]:35703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab1AFA3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:50 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.141581701@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        William Allen Simpson <william.allen.simpson@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [058/152] tcp: protect sysctl_tcp_cookie_size reads
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit f19872575ff7819a3723154657a497d9bca66b33 ]

Make sure sysctl_tcp_cookie_size is read once in
tcp_cookie_size_check(), or we might return an illegal value to caller
if sysctl_tcp_cookie_size is changed by another cpu.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: William Allen Simpson <william.allen.simpson@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -391,27 +391,30 @@ struct tcp_out_options {
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


