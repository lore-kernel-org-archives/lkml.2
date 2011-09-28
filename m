Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab1I1Wsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257Ab1I1WsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:46 2011
Message-Id: <20110928220146.758158673@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [203/244] Bluetooth: Fix timeout on scanning for the second time
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 2d20a26a92f72e3bb658fe8ce99c3663756e9e7a upstream.

The checks for HCI_INQUIRY and HCI_MGMT were in the wrong order,
so that second scans always failed.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/hci_event.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -56,8 +56,8 @@ static void hci_cc_inquiry_cancel(struct
 	if (status)
 		return;
 
-	if (test_bit(HCI_MGMT, &hdev->flags) &&
-				test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
+	if (test_and_clear_bit(HCI_INQUIRY, &hdev->flags) &&
+			test_bit(HCI_MGMT, &hdev->flags))
 		mgmt_discovering(hdev->id, 0);
 
 	hci_req_complete(hdev, HCI_OP_INQUIRY_CANCEL, status);
@@ -74,8 +74,8 @@ static void hci_cc_exit_periodic_inq(str
 	if (status)
 		return;
 
-	if (test_bit(HCI_MGMT, &hdev->flags) &&
-				test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
+	if (test_and_clear_bit(HCI_INQUIRY, &hdev->flags) &&
+				test_bit(HCI_MGMT, &hdev->flags))
 		mgmt_discovering(hdev->id, 0);
 
 	hci_conn_check_pending(hdev);
@@ -851,9 +851,8 @@ static inline void hci_cs_inquiry(struct
 		return;
 	}
 
-	if (test_bit(HCI_MGMT, &hdev->flags) &&
-					!test_and_set_bit(HCI_INQUIRY,
-							&hdev->flags))
+	if (!test_and_set_bit(HCI_INQUIRY, &hdev->flags) &&
+				test_bit(HCI_MGMT, &hdev->flags))
 		mgmt_discovering(hdev->id, 1);
 }
 
@@ -1225,8 +1224,8 @@ static inline void hci_inquiry_complete_
 
 	BT_DBG("%s status %d", hdev->name, status);
 
-	if (test_bit(HCI_MGMT, &hdev->flags) &&
-				test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
+	if (test_and_clear_bit(HCI_INQUIRY, &hdev->flags) &&
+				test_bit(HCI_MGMT, &hdev->flags))
 		mgmt_discovering(hdev->id, 0);
 
 	hci_req_complete(hdev, HCI_OP_INQUIRY, status);


