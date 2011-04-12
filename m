Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1DLPnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:43:41 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:49092 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab1DLPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RRf7mAiBppA+f5wzFGOdryHERz28292cs5TqFIIBDRHRVbWXrMzRCnlnokWoVzOZ6o
         xh+Qm66eXBqhW/c4fJ65Ms/TtRYz9O0HwprCm8aZRYksJkKMv7EoKBOVLS0sURMbkL7+
         6LgHHVhPHNwXQxQzWoBq0y66ohcUlF7hDTprA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [PATCH] Bluetooth: Fix HCI_RESET command synchronization backported to stable
Date: Tue, 12 Apr 2011 08:43:27 -0700
Message-Id: <1302623007-16402-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backported to stable. did not have the time to compile test this, but patch applies.

Reported-by: Mikko Vinni <mmvinni@yahoo.com>
Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Tested-by: Justin P. Mattock <justinmattock@gmail.com>
Tested-by: Mikko Vinni <mmvinni@yahoo.com>
Tested-by: Ed Tomlinson <edt@aei.ca>


diff -Naur linux-2.6.38.2-orig/include/net/bluetooth/hci.h linux-2.6.38.2/include/net/bluetooth/hci.h
--- linux-2.6.38.2-orig/include/net/bluetooth/hci.h	2011-03-27 11:37:20.000000000 -0700
+++ linux-2.6.38.2/include/net/bluetooth/hci.h	2011-04-12 08:27:55.905603867 -0700
@@ -74,6 +74,7 @@
 	HCI_AUTH,
 	HCI_ENCRYPT,
 	HCI_INQUIRY,
+	HCI_RESET,
 
 	HCI_RAW,
 };
diff -Naur linux-2.6.38.2-orig/net/bluetooth/hci_core.c linux-2.6.38.2/net/bluetooth/hci_core.c
--- linux-2.6.38.2-orig/net/bluetooth/hci_core.c	2011-03-27 11:37:20.000000000 -0700
+++ linux-2.6.38.2/net/bluetooth/hci_core.c	2011-04-12 08:29:40.178300280 -0700
@@ -184,6 +184,7 @@
 	BT_DBG("%s %ld", hdev->name, opt);
 
 	/* Reset device */
+	set_bit(HCI_RESET, &hdev->flags);
 	hci_send_cmd(hdev, HCI_OP_RESET, 0, NULL);
 }
 
@@ -210,7 +211,8 @@
 	/* Mandatory initialization */
 
 	/* Reset */
-	if (!test_bit(HCI_QUIRK_NO_RESET, &hdev->quirks))
+	if (!test_bit(HCI_QUIRK_NO_RESET, &hdev->quirks)) {
+                        set_bit(HCI_RESET, &hdev->flags);
 			hci_send_cmd(hdev, HCI_OP_RESET, 0, NULL);
 
 	/* Read Local Supported Features */
diff -Naur linux-2.6.38.2-orig/net/bluetooth/hci_event.c linux-2.6.38.2/net/bluetooth/hci_event.c
--- linux-2.6.38.2-orig/net/bluetooth/hci_event.c	2011-03-27 11:37:20.000000000 -0700
+++ linux-2.6.38.2/net/bluetooth/hci_event.c	2011-04-12 08:30:54.816367176 -0700
@@ -183,6 +183,8 @@
 
 	BT_DBG("%s status 0x%x", hdev->name, status);
 
+	clear_bit(HCI_RESET, &hdev->flags);
+
 	hci_req_complete(hdev, HCI_OP_RESET, status);
 }
 
@@ -1398,7 +1400,7 @@
 		break;
 	}
 
-	if (ev->ncmd) {
+	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
 		atomic_set(&hdev->cmd_cnt, 1);
 		if (!skb_queue_empty(&hdev->cmd_q))
 			tasklet_schedule(&hdev->cmd_task);
