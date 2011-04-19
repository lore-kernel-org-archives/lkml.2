Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1DSUS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:18:27 -0400
Received: from kroah.org ([198.145.64.141]:35777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1DSURu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:50 2011
Message-Id: <20110419201050.551458116@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [69/70] Bluetooth: Fix HCI_RESET command synchronization
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gustavo F. Padovan <padovan@profusion.mobi>

commit f630cf0d5434e3923e1b8226ffa2753ead6b0ce5 upstream.

We can't send new commands before a cmd_complete for the HCI_RESET command
shows up.

Reported-by: Mikko Vinni <mmvinni@yahoo.com>
Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Tested-by: Justin P. Mattock <justinmattock@gmail.com>
Tested-by: Mikko Vinni <mmvinni@yahoo.com>
Tested-by: Ed Tomlinson <edt@aei.ca>


---
 include/net/bluetooth/hci.h |    2 ++
 net/bluetooth/hci_core.c    |    5 ++++-
 net/bluetooth/hci_event.c   |    4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -76,6 +76,8 @@ enum {
 	HCI_INQUIRY,
 
 	HCI_RAW,
+
+	HCI_RESET,
 };
 
 /* HCI ioctl defines */
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -184,6 +184,7 @@ static void hci_reset_req(struct hci_dev
 	BT_DBG("%s %ld", hdev->name, opt);
 
 	/* Reset device */
+	set_bit(HCI_RESET, &hdev->flags);
 	hci_send_cmd(hdev, HCI_OP_RESET, 0, NULL);
 }
 
@@ -210,8 +211,10 @@ static void hci_init_req(struct hci_dev
 	/* Mandatory initialization */
 
 	/* Reset */
-	if (!test_bit(HCI_QUIRK_NO_RESET, &hdev->quirks))
+	if (!test_bit(HCI_QUIRK_NO_RESET, &hdev->quirks)) {
+			set_bit(HCI_RESET, &hdev->flags);
 			hci_send_cmd(hdev, HCI_OP_RESET, 0, NULL);
+	}
 
 	/* Read Local Supported Features */
 	hci_send_cmd(hdev, HCI_OP_READ_LOCAL_FEATURES, 0, NULL);
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -183,6 +183,8 @@ static void hci_cc_reset(struct hci_dev
 
 	BT_DBG("%s status 0x%x", hdev->name, status);
 
+	clear_bit(HCI_RESET, &hdev->flags);
+
 	hci_req_complete(hdev, HCI_OP_RESET, status);
 }
 
@@ -1464,7 +1466,7 @@ static inline void hci_cmd_status_evt(st
 		break;
 	}
 
-	if (ev->ncmd) {
+	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
 		atomic_set(&hdev->cmd_cnt, 1);
 		if (!skb_queue_empty(&hdev->cmd_q))
 			tasklet_schedule(&hdev->cmd_task);


