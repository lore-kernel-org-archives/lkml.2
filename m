Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2FRKDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2FRKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:03:38 -0400
Date: Mon, 18 Jun 2012 19:03:36 +0900 (JST)
Message-Id: <20120618.190336.2038782472992211666.yamato@redhat.com>
In-Reply-To: <20120615080007.GD7205@aemeltch-MOBL1>
References: <20120615080007.GD7205@aemeltch-MOBL1>
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 5/8] Added /proc/net/hidp via bt_procfs_init()
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/bluetooth/hidp/sock.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 73a32d7..3bd5d63 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -39,6 +39,10 @@
 
 #include "hidp.h"
 
+static struct bt_sock_list hidp_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(hidp_sk_list.lock)
+};
+
 static int hidp_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -48,6 +52,8 @@ static int hidp_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&hidp_sk_list, sk);
+
 	sock_orphan(sk);
 	sock_put(sk);
 
@@ -267,6 +273,8 @@ static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_protocol = protocol;
 	sk->sk_state	= BT_OPEN;
 
+	bt_sock_link(&hidp_sk_list, sk);
+
 	return 0;
 }
 
@@ -285,19 +293,30 @@ int __init hidp_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_HIDP, &hidp_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+	  	BT_ERR("Can't register HIDP socket");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "hidp", &hidp_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create HIDP proc file");
+		bt_sock_unregister(BTPROTO_HIDP);
+		goto error;		
+	}
+
+	BT_INFO("HIDP socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("Can't register HIDP socket");
 	proto_unregister(&hidp_proto);
 	return err;
 }
 
 void __exit hidp_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "hidp");
 	if (bt_sock_unregister(BTPROTO_HIDP) < 0)
 		BT_ERR("Can't unregister HIDP socket");
 
-- 
1.7.10.2

