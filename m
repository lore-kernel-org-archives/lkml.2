Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2GYQ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab2GYQ3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:29:07 -0400
Date: Thu, 26 Jul 2012 01:29:00 +0900 (JST)
Message-Id: <20120726.012900.1562774684228699074.yamato@redhat.com>
To: gustavo@padovan.org
Cc: andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH v5 5/8] Bluetooth: Added /proc/net/hidp via bt_procfs_init()
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20120725003507.GR20029@joana>
References: <20120716.222018.2029110835026223294.yamato@redhat.com>
	<20120725001214.GP20029@joana>
	<20120725003507.GR20029@joana>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added /proc/net/hidp via bt_procfs_init().

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/bluetooth/hidp/sock.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 18b3f68..eca3889 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -25,6 +25,10 @@
 
 #include "hidp.h"
 
+static struct bt_sock_list hidp_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(hidp_sk_list.lock)
+};
+
 static int hidp_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -34,6 +38,8 @@ static int hidp_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&hidp_sk_list, sk);
+
 	sock_orphan(sk);
 	sock_put(sk);
 
@@ -253,6 +259,8 @@ static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_protocol = protocol;
 	sk->sk_state	= BT_OPEN;
 
+	bt_sock_link(&hidp_sk_list, sk);
+
 	return 0;
 }
 
@@ -271,8 +279,19 @@ int __init hidp_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_HIDP, &hidp_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+		BT_ERR("Can't register HIDP socket");
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
 
@@ -284,6 +303,7 @@ error:
 
 void __exit hidp_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "hidp");
 	if (bt_sock_unregister(BTPROTO_HIDP) < 0)
 		BT_ERR("Can't unregister HIDP socket");
 
-- 
1.7.10.4

