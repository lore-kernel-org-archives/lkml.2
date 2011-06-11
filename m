Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1FKVWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 17:22:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53685 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1FKVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 17:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ivL89+jwf3lQWJ04rznKRgRYDq/0B/LOWw4EAb3cJJg2MNriqsDvSpbLmJDUqSlAyK
         zAhdI8arAd60QfL0hF4ujtwgS/tisHKss9wyklHrvvC0hHZOGDKl/x9eLEn59w8+KALU
         0ZUwBoeLaJQ1zV3/TQOQyiKjhDJShJOw+sZkQ=
From: Connor Hansen <cmdkhh@gmail.com>
To: marcel@holtmann.org
Cc: padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH] drivers/bluetooth/bpa10x.c: missing kfrees
Date: Sat, 11 Jun 2011 14:21:36 -0700
Message-Id: <1307827296-21363-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

both bpa10x_submit_initr_urb() and bpa10x_submit_bulk_urb()
malloc a char buffer(buf) for usb_fill_init_usb() but fail to
free it after freeing the urb.

Likewise, bpa10x_send_frame() allocates a usb_ctrlrequest(dr)
for sending packets but does not free it after the
usb_fill_control_urb() call.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 drivers/bluetooth/bpa10x.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 751b338..7dfd9ca 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -254,6 +254,7 @@ static inline int bpa10x_submit_intr_urb(struct hci_dev *hdev)
 	}
 
 	usb_free_urb(urb);
+	kfree(buf);
 
 	return err;
 }
@@ -295,6 +296,7 @@ static inline int bpa10x_submit_bulk_urb(struct hci_dev *hdev)
 	}
 
 	usb_free_urb(urb);
+	kfree(buf);
 
 	return err;
 }
@@ -393,6 +395,7 @@ static int bpa10x_send_frame(struct sk_buff *skb)
 				skb->data, skb->len, bpa10x_tx_complete, skb);
 
 		hdev->stat.cmd_tx++;
+		kfree(df);
 		break;
 
 	case HCI_ACLDATA_PKT:
-- 
1.7.4.4

