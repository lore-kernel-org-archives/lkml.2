Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423349Ab2I1VgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:36:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab2I1U06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 100/218] Bluetooth: mgmt: Fix enabling SSP while powered off
Date: Fri, 28 Sep 2012 13:15:17 -0700
Message-Id: <20120928201513.038474485@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2801,6 +2801,12 @@ int mgmt_powered(struct hci_dev *hdev, u
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


