Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993096Ab2KOEbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:31:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993029Ab2KOELx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tom Parkin <tparkin@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 52/66] l2tp: fix oops in l2tp_eth_create() error path
Date: Wed, 14 Nov 2012 20:10:57 -0800
Message-Id: <20121115040942.889795655@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Tom Parkin <tparkin@katalix.com>

[ Upstream commit 789336360e0a2aeb9750c16ab704a02cbe035e9e ]

When creating an L2TPv3 Ethernet session, if register_netdev() should fail for
any reason (for example, automatic naming for "l2tpeth%d" interfaces hits the
32k-interface limit), the netdev is freed in the error path.  However, the
l2tp_eth_sess structure's dev pointer is left uncleared, and this results in
l2tp_eth_delete() then attempting to unregister the same netdev later in the
session teardown.  This results in an oops.

To avoid this, clear the session dev pointer in the error path.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_eth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -290,6 +290,7 @@ static int l2tp_eth_create(struct net *n
 
 out_del_dev:
 	free_netdev(dev);
+	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
 out:


