Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab2ILXil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:38:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab2ILXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Ram Malovany <ramm@ti.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 32/85] Bluetooth: Fix using a NULL inquiry cache entry
Date: Wed, 12 Sep 2012 16:36:15 -0700
Message-Id: <20120912233545.105190562@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ram Malovany <ramm@ti.com>

commit 7cc8380eb10347016d95bf6f9d842c2ae6d12932 upstream.

If the device was not found in a list of found devices names of which
are pending.This may happen in a case when HCI Remote Name Request
was sent as a part of incoming connection establishment procedure.
Hence there is no need to continue resolving a next name as it will
be done upon receiving another Remote Name Request Complete Event.
This will fix a kernel crash when trying to use this entry to resolve
the next name.

Signed-off-by: Ram Malovany <ramm@ti.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1388,12 +1388,18 @@ static void hci_check_pending_name(struc
 		return;
 
 	e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
-	if (e) {
+	/* If the device was not found in a list of found devices names of which
+	 * are pending. there is no need to continue resolving a next name as it
+	 * will be done upon receiving another Remote Name Request Complete
+	 * Event */
+	if (!e)
+		return;
+
+	list_del(&e->list);
+	if (name) {
 		e->name_state = NAME_KNOWN;
-		list_del(&e->list);
-		if (name)
-			mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
-					 e->data.rssi, name, name_len);
+		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
+				 e->data.rssi, name, name_len);
 	}
 
 	if (hci_resolve_next_name(hdev))


