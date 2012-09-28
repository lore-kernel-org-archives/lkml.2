Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032592Ab2I1U1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:27:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032557Ab2I1U1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 102/218] Bluetooth: mgmt: Fix enabling LE while powered off
Date: Fri, 28 Sep 2012 13:15:19 -0700
Message-Id: <20120928201513.281322695@linuxfoundation.org>
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

commit 562fcc246ebe31ade6e1be08585673b9b2785498 upstream.

When new BT USB adapter is plugged in it's configured while still being powered
off (HCI_AUTO_OFF flag is set), thus Set LE will only set dev_flags but won't
write changes to controller. As a result it's not possible to start device
discovery session on LE controller as it uses interleaved discovery which
requires LE Supported Host flag in extended features.

This patch ensures HCI Write LE Host Supported is sent when Set Powered is
called to power on controller and clear HCI_AUTO_OFF flag.

Signed-off-by: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2807,6 +2807,16 @@ int mgmt_powered(struct hci_dev *hdev, u
 			hci_send_cmd(hdev, HCI_OP_WRITE_SSP_MODE, 1, &ssp);
 		}
 
+		if (test_bit(HCI_LE_ENABLED, &hdev->dev_flags)) {
+			struct hci_cp_write_le_host_supported cp;
+
+			cp.le = 1;
+			cp.simul = !!(hdev->features[6] & LMP_SIMUL_LE_BR);
+
+			hci_send_cmd(hdev, HCI_OP_WRITE_LE_HOST_SUPPORTED,
+				     sizeof(cp), &cp);
+		}
+
 		update_class(hdev);
 		update_name(hdev, hdev->dev_name);
 		update_eir(hdev);


