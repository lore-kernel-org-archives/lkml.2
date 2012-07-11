Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2GKFDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:03:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2GKFDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:03:14 -0400
Date: Wed, 11 Jul 2012 14:03:10 +0900 (JST)
Message-Id: <20120711.140310.150561481084375373.yamato@redhat.com>
To: andrei.emeltchenko.news@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH v3 5/8] bluetooth: Added /proc/net/hidp via bt_procfs_init()
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
 net/bluetooth/hidp/sock.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 18b3f68..a481f8d 100644
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
 
@@ -271,9 +279,20 @@ int __init hidp_init_sockets(void)
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
 
+	BT_INFO("HIDP socket layer initialized");
+
 	return 0;
 
 error:
@@ -284,6 +303,7 @@ error:
 
 void __exit hidp_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "hidp");
 	if (bt_sock_unregister(BTPROTO_HIDP) < 0)
 		BT_ERR("Can't unregister HIDP socket");
 
-- 
1.7.10.4

