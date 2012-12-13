Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2LMOFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2LMOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 081/241] Bluetooth: Fix having bogus entries in mgmt_read_index_list reply
Date: Thu, 13 Dec 2012 11:57:26 -0200
Message-Id: <1355407206-17100-82-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/mgmt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3571450..ec098bd 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -323,7 +323,7 @@ static int read_index_list(struct sock *sk, struct hci_dev *hdev, void *data,
 	struct hci_dev *d;
 	size_t rp_len;
 	u16 count;
-	int i, err;
+	int err;
 
 	BT_DBG("sock %p", sk);
 
@@ -341,17 +341,18 @@ static int read_index_list(struct sock *sk, struct hci_dev *hdev, void *data,
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
-- 
1.7.9.5

