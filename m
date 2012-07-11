Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2GKFCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2GKFCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:02:53 -0400
Date: Wed, 11 Jul 2012 14:02:49 +0900 (JST)
Message-Id: <20120711.140249.2140295207701429925.yamato@redhat.com>
To: andrei.emeltchenko.news@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH v3 4/8] bluetooth: Added /proc/net/hci via bt_procfs_init()
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
 net/bluetooth/hci_sock.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index a7f04de..7c3d6c7 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1100,21 +1100,30 @@ int __init hci_sock_init(void)
 		return err;
 
 	err = bt_sock_register(BTPROTO_HCI, &hci_sock_family_ops);
-	if (err < 0)
+	if (err < 0) {
+		BT_ERR("HCI socket registration failed");
 		goto error;
+	}
+
+	err = bt_procfs_init(THIS_MODULE, &init_net, "hci", &hci_sk_list, NULL);
+	if (err < 0) {
+		BT_ERR("Failed to create HCI proc file");
+		bt_sock_unregister(BTPROTO_HCI);
+		goto error;
+	}
 
 	BT_INFO("HCI socket layer initialized");
 
 	return 0;
 
 error:
-	BT_ERR("HCI socket registration failed");
 	proto_unregister(&hci_sk_proto);
 	return err;
 }
 
 void hci_sock_cleanup(void)
 {
+	bt_procfs_cleanup(&init_net, "hci");
 	if (bt_sock_unregister(BTPROTO_HCI) < 0)
 		BT_ERR("HCI socket unregistration failed");
 
-- 
1.7.10.4

