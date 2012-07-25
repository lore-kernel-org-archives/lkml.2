Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2GYQ3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:29:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab2GYQ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:29:54 -0400
Date: Thu, 26 Jul 2012 01:29:49 +0900 (JST)
Message-Id: <20120726.012949.2010933451187088004.yamato@redhat.com>
To: gustavo@padovan.org
Cc: andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH v5 7/8] Bluetooth: Added /proc/net/rfcomm via
 bt_procfs_init()
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

Added /proc/net/rfcomm via bt_procfs_init().

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/bluetooth/rfcomm/sock.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 7e1e596..260821a 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -1033,8 +1033,17 @@ int __init rfcomm_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_RFCOMM, &rfcomm_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+		BT_ERR("RFCOMM socket layer registration failed");
+		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "rfcomm", &rfcomm_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create RFCOMM proc file");
+		bt_sock_unregister(BTPROTO_RFCOMM);
 		goto error;
+	}
 
 	if (bt_debugfs) {
 		rfcomm_sock_debugfs = debugfs_create_file("rfcomm", 0444,
@@ -1048,13 +1057,14 @@ int __init rfcomm_init_sockets(void)
 	return 0;
 
 error:
-	BT_ERR("RFCOMM socket layer registration failed");
 	proto_unregister(&rfcomm_proto);
 	return err;
 }
 
 void __exit rfcomm_cleanup_sockets(void)
 {
+	bt_procfs_cleanup(&init_net, "rfcomm");
+
 	debugfs_remove(rfcomm_sock_debugfs);
 
 	if (bt_sock_unregister(BTPROTO_RFCOMM) < 0)
-- 
1.7.10.4

