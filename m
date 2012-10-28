Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2J1X3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:29:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42269 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab2J1X2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:35 -0400
Message-Id: <20121028231543.196824194@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "jeff.liu" <jeff.liu@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 020/105] RDS: fix rds-ping spinlock recursion
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "jeff.liu" <jeff.liu@oracle.com>

[ Upstream commit 5175a5e76bbdf20a614fb47ce7a38f0f39e70226 ]

This is the revised patch for fixing rds-ping spinlock recursion
according to Venkat's suggestions.

RDS ping/pong over TCP feature has been broken for years(2.6.39 to
3.6.0) since we have to set TCP cork and call kernel_sendmsg() between
ping/pong which both need to lock "struct sock *sk". However, this
lock has already been hold before rds_tcp_data_ready() callback is
triggerred. As a result, we always facing spinlock resursion which
would resulting in system panic.

Given that RDS ping is only used to test the connectivity and not for
serious performance measurements, we can queue the pong transmit to
rds_wq as a delayed response.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
CC: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
CC: David S. Miller <davem@davemloft.net>
CC: James Morris <james.l.morris@oracle.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rds/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 96531d4..88eace5 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1122,7 +1122,7 @@ rds_send_pong(struct rds_connection *conn, __be16 dport)
 	rds_stats_inc(s_send_pong);
 
 	if (!test_bit(RDS_LL_SEND_FULL, &conn->c_flags))
-		rds_send_xmit(conn);
+		queue_delayed_work(rds_wq, &conn->c_send_w, 0);
 
 	rds_message_put(rm);
 	return 0;


