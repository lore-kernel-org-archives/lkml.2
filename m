Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab2KVVz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:55:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2KVSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 52/83] Bluetooth: Fix having bogus entries in mgmt_read_index_list reply
Date: Wed, 21 Nov 2012 16:42:14 -0800
Message-Id: <20121122004218.309118841@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 476e44cb19f1fbf2d5883dddcc0ce31b33b45915 upstream.

The mgmt_read_index_list uses one loop to calculate the max needed size
of its response with the help of an upper-bound of the controller count.
The second loop is more strict as it checks for HCI_SETUP (which might
have gotten set after the first loop) and could result in some indexes
being skipped. Because of this the function needs to readjust the event
length and index count after filling in the response array.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -321,7 +321,7 @@ static int read_index_list(struct sock *
 	struct hci_dev *d;
 	size_t rp_len;
 	u16 count;
-	int i, err;
+	int err;
 
 	BT_DBG("sock %p", sk);
 
@@ -339,17 +339,18 @@ static int read_index_list(struct sock *
 		return -ENOMEM;
 	}
 
-	rp->num_controllers = cpu_to_le16(count);
-
-	i = 0;
+	count = 0;
 	list_for_each_entry(d, &hci_dev_list, list) {
 		if (test_bit(HCI_SETUP, &d->dev_flags))
 			continue;
 
-		rp->index[i++] = cpu_to_le16(d->id);
+		rp->index[count++] = cpu_to_le16(d->id);
 		BT_DBG("Added hci%u", d->id);
 	}
 
+	rp->num_controllers = cpu_to_le16(count);
+	rp_len = sizeof(*rp) + (2 * count);
+
 	read_unlock(&hci_dev_list_lock);
 
 	err = cmd_complete(sk, MGMT_INDEX_NONE, MGMT_OP_READ_INDEX_LIST, 0, rp,


