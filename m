Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2DSV7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:59:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab2DSVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:05:49 -0400
Message-Id: <20120419210304.585009371@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Guedes <andre.guedes@openbossa.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Ulisses Furquim <ulisses@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [ 17/75] Bluetooth: Remove unneeded locking
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Guedes <andre.guedes@openbossa.org>

commit e72acc13c770a82b4ce4a07e9716f29320eae0f8 upstream.

We don't need locking hdev in hci_conn_timeout() since it doesn't
access any hdev's shared resources, it basically queues HCI commands.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Reviewed-by: Ulisses Furquim <ulisses@profusion.mobi>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Alexander Holler <holler@ahsoftware.de>
[reported to fix lockups on battery-powered bluetooth devices - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -279,7 +279,6 @@ static void hci_conn_timeout(struct work
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn,
 							disc_work.work);
-	struct hci_dev *hdev = conn->hdev;
 	__u8 reason;
 
 	BT_DBG("conn %p state %d", conn, conn->state);
@@ -287,8 +286,6 @@ static void hci_conn_timeout(struct work
 	if (atomic_read(&conn->refcnt))
 		return;
 
-	hci_dev_lock(hdev);
-
 	switch (conn->state) {
 	case BT_CONNECT:
 	case BT_CONNECT2:
@@ -308,8 +305,6 @@ static void hci_conn_timeout(struct work
 		conn->state = BT_CLOSED;
 		break;
 	}
-
-	hci_dev_unlock(hdev);
 }
 
 /* Enter sniff mode */


