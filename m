Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2GKFDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2GKFDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:03:40 -0400
Date: Wed, 11 Jul 2012 14:03:37 +0900 (JST)
Message-Id: <20120711.140337.6492431783697495.yamato@redhat.com>
To: andrei.emeltchenko.news@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH v3 6/8] bluetooth: Added /proc/net/l2cap via
 bt_procfs_init()
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20120711.135831.1712662939552441872.yamato@redhat.com>
References: <20120629.020253.963694178693689545.yamato@redhat.com>
	<20120710140400.GA15795@aemeltch-MOBL1>
	<20120711.135831.1712662939552441872.yamato@redhat.com>
Organization: Red Hat Japan, Inc.
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
index a4bb27e..c9a9f1c 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -34,6 +34,10 @@
 #include <net/bluetooth/l2cap.h>
 #include <net/bluetooth/smp.h>
 
+static struct bt_sock_list l2cap_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(l2cap_sk_list.lock)
+};
+
 static const struct proto_ops l2cap_sock_ops;
 static void l2cap_sock_init(struct sock *sk, struct sock *parent);
 static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock, int proto, gfp_t prio);
@@ -886,6 +890,8 @@ static int l2cap_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&l2cap_sk_list, sk);
+
 	err = l2cap_sock_shutdown(sock, 2);
 
 	sock_orphan(sk);
@@ -1210,6 +1216,7 @@ static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol,
 		return -ENOMEM;
 
 	l2cap_sock_init(sk, NULL);
+	bt_sock_link(&l2cap_sk_list, sk);
 	return 0;
 }
 
@@ -1248,22 +1255,30 @@ int __init l2cap_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_L2CAP, &l2cap_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+		BT_ERR("L2CAP socket registration failed");
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
1.7.10.4

