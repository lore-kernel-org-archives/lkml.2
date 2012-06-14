Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2FNRRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2FNRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:17:44 -0400
Date: Fri, 15 Jun 2012 02:17:42 +0900 (JST)
Message-Id: <20120615.021742.1385079555521232550.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Subject: [PATCH 5/8] Added /proc/net/hidp via bt_procfs_init()
From: Masatake YAMATO <yamato@redhat.com>
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
 net/bluetooth/hidp/sock.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 73a32d7..dd31d8f 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -39,6 +39,11 @@
 
 #include "hidp.h"
 
+
+static struct bt_sock_list hidp_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(hidp_sk_list.lock)
+};
+
 static int hidp_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -48,6 +53,8 @@ static int hidp_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&hidp_sk_list, sk);
+
 	sock_orphan(sk);
 	sock_put(sk);
 
@@ -267,6 +274,8 @@ static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_protocol = protocol;
 	sk->sk_state	= BT_OPEN;
 
+	bt_sock_link(&hidp_sk_list, sk);
+
 	return 0;
 }
 
@@ -285,19 +294,30 @@ int __init hidp_init_sockets(void)
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

