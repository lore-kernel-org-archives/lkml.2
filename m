Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2FNRRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2FNRRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:17:19 -0400
Date: Fri, 15 Jun 2012 02:17:18 +0900 (JST)
Message-Id: <20120615.021718.862586446299200414.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Subject: [PATCH 4/8] Added /proc/net/hci via bt_procfs_init()
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added /proc/net/hci via bt_procfs_init().

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/bluetooth/hci_sock.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 5914623..3452d27 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1107,21 +1107,32 @@ int __init hci_sock_init(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_HCI, &hci_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+	  	BT_ERR("HCI socket registration failed");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "hci", &hci_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create HCI proc file");
+		bt_sock_unregister(BTPROTO_HCI);
+		goto error;
+	}
+
 
 	BT_INFO("HCI socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("HCI socket registration failed");
 	proto_unregister(&hci_sk_proto);
 	return err;
 }
 
 void hci_sock_cleanup(void)
 {
+        bt_procfs_cleanup(&init_net, "hci");
+
 	if (bt_sock_unregister(BTPROTO_HCI) < 0)
 		BT_ERR("HCI socket unregistration failed");
 
-- 
1.7.10.2

