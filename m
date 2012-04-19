Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab2DSVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab2DSVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:16 -0400
Message-Id: <20120419210611.546117757@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 05/59] [PATCH] Bluetooth: uart-ldisc: Fix memory leak
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

This is a partial, self-contained, minimal backport of commit
797fe796c4335b35d95d5326824513befdb5d1e9 upstream which fixes the memory
leak:

Bluetooth: uart-ldisc: Fix memory leak and remove destruct cb

We currently leak the hci_uart object if HCI_UART_PROTO_SET is never set
because the hci-destruct callback will then never be called.  This fix
removes the hci-destruct callback and frees the driver internal private
hci_uart object directly on tty-close. We call hci_unregister_dev() here
so the hci-core will never call our callbacks again (except destruct).
Therefore, we can safely free the driver internal data right away and
set the destruct callback to NULL.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -237,7 +237,6 @@ static void hci_uart_destruct(struct hci
 		return;
 
 	BT_DBG("%s", hdev->name);
-	kfree(hdev->driver_data);
 }
 
 /* ------ LDISC part ------ */
@@ -316,6 +315,7 @@ static void hci_uart_tty_close(struct tt
 				hci_free_dev(hdev);
 			}
 		}
+		kfree(hu);
 	}
 }
 


