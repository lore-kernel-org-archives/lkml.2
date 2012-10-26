Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2JZAq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:46:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:52561 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2JZAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Jie Liu <jeff.liu@oracle.com>
Subject: [ 21/31] RDS: fix rds-ping spinlock recursion
Date: Thu, 25 Oct 2012 17:04:28 -0700
Message-Id: <20121026000217.117544027@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1121,7 +1121,7 @@ rds_send_pong(struct rds_connection *con
 	rds_stats_inc(s_send_pong);
 
 	if (!test_bit(RDS_LL_SEND_FULL, &conn->c_flags))
-		rds_send_xmit(conn);
+		queue_delayed_work(rds_wq, &conn->c_send_w, 0);
 
 	rds_message_put(rm);
 	return 0;


