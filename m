Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2LMO3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:29:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101Ab2LMOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Jie Liu <jeff.liu@oracle.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 179/241] RDS: fix rds-ping spinlock recursion
Date: Thu, 13 Dec 2012 11:59:04 -0200
Message-Id: <1355407206-17100-180-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "jeff.liu" <jeff.liu@oracle.com>

commit 5175a5e76bbdf20a614fb47ce7a38f0f39e70226 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/rds/send.c |    2 +-
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
-- 
1.7.9.5

