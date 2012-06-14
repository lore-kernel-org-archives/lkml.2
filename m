Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2FNRSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2FNRSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:18:37 -0400
Date: Fri, 15 Jun 2012 02:18:35 +0900 (JST)
Message-Id: <20120615.021835.1759601069982013045.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Subject: [PATCH 7/8] Added /proc/net/rfcomm via bt_procfs_init()
From: Masatake YAMATO <yamato@redhat.com>
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
 net/bluetooth/rfcomm/sock.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index e8707de..0d0a35f 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -1052,8 +1052,18 @@ int __init rfcomm_init_sockets(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_RFCOMM, &rfcomm_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+	  	BT_ERR("RFCOMM socket layer registration failed");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "rfcomm", &rfcomm_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create RFCOMM proc file");
+		bt_sock_unregister(BTPROTO_RFCOMM);
+		goto error;
+	}
+
 
 	if (bt_debugfs) {
 		rfcomm_sock_debugfs = debugfs_create_file("rfcomm", 0444,
@@ -1067,13 +1077,14 @@ int __init rfcomm_init_sockets(void)
 	return 0;
 
 error:
-	BT_ERR("RFCOMM socket layer registration failed");
 	proto_unregister(&rfcomm_proto);
 	return err;
 }
 
 void __exit rfcomm_cleanup_sockets(void)
 {
+  	bt_procfs_cleanup(&init_net, "rfcomm");
+
 	debugfs_remove(rfcomm_sock_debugfs);
 
 	if (bt_sock_unregister(BTPROTO_RFCOMM) < 0)
-- 
1.7.10.2

