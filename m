Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2FRKED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab2FRKEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:04:01 -0400
Date: Mon, 18 Jun 2012 19:03:59 +0900 (JST)
Message-Id: <20120618.190359.1061230883755245903.yamato@redhat.com>
In-Reply-To: <20120615080007.GD7205@aemeltch-MOBL1>
References: <20120615080007.GD7205@aemeltch-MOBL1>
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 6/8] Added /proc/net/l2cap via bt_procfs_init()
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
 net/bluetooth/l2cap_sock.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 3bb1611..b5e1966 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -35,6 +35,10 @@
 #include <net/bluetooth/l2cap.h>
 #include <net/bluetooth/smp.h>
 
+static struct bt_sock_list l2cap_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(l2cap_sk_list.lock)
+};
+
 static const struct proto_ops l2cap_sock_ops;
 static void l2cap_sock_init(struct sock *sk, struct sock *parent);
 static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock, int proto, gfp_t prio);
@@ -866,6 +870,8 @@ static int l2cap_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&l2cap_sk_list, sk);
+
 	err = l2cap_sock_shutdown(sock, 2);
 
 	sock_orphan(sk);
@@ -1102,6 +1108,7 @@ static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol,
 		return -ENOMEM;
 
 	l2cap_sock_init(sk, NULL);
+	bt_sock_link(&l2cap_sk_list, sk);
 	return 0;
 }
 
@@ -1140,21 +1147,30 @@ int __init l2cap_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_L2CAP, &l2cap_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+	  	BT_ERR("L2CAP socket registration failed");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "l2cap", &l2cap_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create L2CAP proc file");
+		bt_sock_unregister(BTPROTO_L2CAP);
+		goto error;		
+	}
 
 	BT_INFO("L2CAP socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("L2CAP socket registration failed");
 	proto_unregister(&l2cap_proto);
 	return err;
 }
 
 void l2cap_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "l2cap");
 	if (bt_sock_unregister(BTPROTO_L2CAP) < 0)
 		BT_ERR("L2CAP socket unregistration failed");
 
-- 
1.7.10.2

