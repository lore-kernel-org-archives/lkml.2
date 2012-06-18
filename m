Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2FRKAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2FRKAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:00:52 -0400
Date: Mon, 18 Jun 2012 19:00:49 +0900 (JST)
Message-Id: <20120618.190049.1291417432266224200.yamato@redhat.com>
In-Reply-To: <20120615080007.GD7205@aemeltch-MOBL1>
References: <20120615080007.GD7205@aemeltch-MOBL1>
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 2/8] Added /proc/net/bnep via bt_procfs_init()
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
 net/bluetooth/bnep/sock.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 180bfc4..b5bccd2 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -45,6 +45,10 @@
 
 #include "bnep.h"
 
+static struct bt_sock_list bnep_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(bnep_sk_list.lock)
+};
+
 static int bnep_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -54,6 +58,8 @@ static int bnep_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&bnep_sk_list, sk);
+
 	sock_orphan(sk);
 	sock_put(sk);
 	return 0;
@@ -220,6 +226,7 @@ static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_protocol = protocol;
 	sk->sk_state	= BT_OPEN;
 
+	bt_sock_link(&bnep_sk_list, sk);
 	return 0;
 }
 
@@ -238,19 +245,30 @@ int __init bnep_sock_init(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_BNEP, &bnep_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+	  	BT_ERR("Can't register BNEP socket");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "bnep", &bnep_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create BNEP proc file");
+		bt_sock_unregister(BTPROTO_BNEP);
+		goto error;		
+	}
+
+	BT_INFO("BNEP socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("Can't register BNEP socket");
 	proto_unregister(&bnep_proto);
 	return err;
 }
 
 void __exit bnep_sock_cleanup(void)
 {
+	bt_procfs_cleanup(&init_net, "bnep");
 	if (bt_sock_unregister(BTPROTO_BNEP) < 0)
 		BT_ERR("Can't unregister BNEP socket");
 
-- 
1.7.10.2

