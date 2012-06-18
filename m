Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2FRKBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab2FRKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:01:42 -0400
Date: Mon, 18 Jun 2012 19:01:40 +0900 (JST)
Message-Id: <20120618.190140.1065000539334810754.yamato@redhat.com>
In-Reply-To: <20120615080007.GD7205@aemeltch-MOBL1>
References: <20120615080007.GD7205@aemeltch-MOBL1>
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 3/8] Added /proc/net/cmtp via bt_procfs_init()
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
 net/bluetooth/cmtp/sock.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 311668d..880ba45 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -42,6 +42,10 @@
 
 #include "cmtp.h"
 
+static struct bt_sock_list cmtp_sk_list = {
+	.lock = __RW_LOCK_UNLOCKED(cmtp_sk_list.lock)
+};
+
 static int cmtp_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -51,6 +55,8 @@ static int cmtp_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	bt_sock_unlink(&cmtp_sk_list, sk);
+	
 	sock_orphan(sk);
 	sock_put(sk);
 
@@ -214,6 +220,8 @@ static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_protocol = protocol;
 	sk->sk_state    = BT_OPEN;
 
+	bt_sock_link(&cmtp_sk_list, sk);
+	
 	return 0;
 }
 
@@ -232,19 +240,30 @@ int cmtp_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_CMTP, &cmtp_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+		BT_ERR("Can't register CMTP socket");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "cmtp", &cmtp_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create CMTP proc file");
+		bt_sock_unregister(BTPROTO_HIDP);
+		goto error;		
+	}
+	
+	BT_INFO("CMTP socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("Can't register CMTP socket");
 	proto_unregister(&cmtp_proto);
 	return err;
 }
 
 void cmtp_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "cmtp");
 	if (bt_sock_unregister(BTPROTO_CMTP) < 0)
 		BT_ERR("Can't unregister CMTP socket");
 
-- 
1.7.10.2

