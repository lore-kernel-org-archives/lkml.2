Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829Ab2DKX3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:29:51 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965815Ab2DKX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:46 -0400
Message-Id: <20120411231314.787023068@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Hurley <peter@hurleysoftware.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [ 42/42] Bluetooth: Fix l2cap conn failures for ssp devices
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Peter Hurley <peter@hurleysoftware.com>

commit 18daf1644e634bae951a6e3d4d19d89170209762 upstream

Commit 330605423c fixed l2cap conn establishment for non-ssp remote
devices by not setting HCI_CONN_ENCRYPT_PEND every time conn security
is tested (which was always returning failure on any subsequent
security checks).

However, this broke l2cap conn establishment for ssp remote devices
when an ACL link was already established at SDP-level security. This
fix ensures that encryption must be pending whenever authentication
is also pending.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>

---
 net/bluetooth/hci_conn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -548,6 +548,10 @@ static int hci_conn_auth(struct hci_conn
 
 	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->pend)) {
 		struct hci_cp_auth_requested cp;
+
+		/* encrypt must be pending if auth is also pending */
+		set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend);
+
 		cp.handle = cpu_to_le16(conn->handle);
 		hci_send_cmd(conn->hdev, HCI_OP_AUTH_REQUESTED,
 							sizeof(cp), &cp);


