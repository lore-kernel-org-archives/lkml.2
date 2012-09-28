Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030756Ab2I1TlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:41:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2I1TAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 126/262] Bluetooth: mgmt: Fix enabling SSP while powered off
Date: Fri, 28 Sep 2012 11:50:55 -0700
Message-Id: <20120928183012.933217395@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>

commit 3d1cbdd6aefff711bcf389fdabc4af9bc22e8201 upstream.

When new BT USB adapter is plugged in it's configured while still being powered
off (HCI_AUTO_OFF flag is set), thus Set SSP will only set dev_flags but won't
write changes to controller. As a result remote devices won't use Secure Simple
Pairing with our device due to SSP Host Support flag disabled in extended
features and may also reject SSP attempt from our side (with possible fallback
to legacy pairing).

This patch ensures HCI Write Simple Pairing Mode is sent when Set Powered is
called to power on controller and clear HCI_AUTO_OFF flag.

Signed-off-by: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2879,6 +2879,12 @@ int mgmt_powered(struct hci_dev *hdev, u
 		if (scan)
 			hci_send_cmd(hdev, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 
+		if (test_bit(HCI_SSP_ENABLED, &hdev->dev_flags)) {
+			u8 ssp = 1;
+
+			hci_send_cmd(hdev, HCI_OP_WRITE_SSP_MODE, 1, &ssp);
+		}
+
 		update_class(hdev);
 		update_name(hdev, hdev->dev_name);
 		update_eir(hdev);


