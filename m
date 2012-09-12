Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2IMAef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:34:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2ILXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Szymon Janc <szymon.janc@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 041/108] Bluetooth: Fix legacy pairing with some devices
Date: Wed, 12 Sep 2012 16:28:39 -0700
Message-Id: <20120912232454.831919069@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit a9ea3ed9b71cc3271dd59e76f65748adcaa76422 upstream.

Some devices e.g. some Android based phones don't do SDP search before
pairing and cancel legacy pairing when ACL is disconnected.

PIN Code Request event which changes ACL timeout to HCI_PAIRING_TIMEOUT
is only received after remote user entered PIN.

In that case no L2CAP is connected so default HCI_DISCONN_TIMEOUT
(2 seconds) is being used to timeout ACL connection. This results in
problems with legacy pairing as remote user has only few seconds to
enter PIN before ACL is disconnected.

Increase disconnect timeout for incomming connection to
HCI_PAIRING_TIMEOUT if SSP is disabled and no linkey exists.

To avoid keeping ACL alive for too long after SDP search set ACL
timeout back to HCI_DISCONN_TIMEOUT when L2CAP is connected.

2012-07-19 13:24:43.413521 < HCI Command: Create Connection (0x01|0x0005) plen 13
    bdaddr 00:02:72:D6:6A:3F ptype 0xcc18 rswitch 0x01 clkoffset 0x0000
    Packet type: DM1 DM3 DM5 DH1 DH3 DH5
2012-07-19 13:24:43.425224 > HCI Event: Command Status (0x0f) plen 4
    Create Connection (0x01|0x0005) status 0x00 ncmd 1
2012-07-19 13:24:43.885222 > HCI Event: Role Change (0x12) plen 8
    status 0x00 bdaddr 00:02:72:D6:6A:3F role 0x01
    Role: Slave
2012-07-19 13:24:44.054221 > HCI Event: Connect Complete (0x03) plen 11
    status 0x00 handle 42 bdaddr 00:02:72:D6:6A:3F type ACL encrypt 0x00
2012-07-19 13:24:44.054313 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
    handle 42
2012-07-19 13:24:44.055176 > HCI Event: Page Scan Repetition Mode Change (0x20) plen 7
    bdaddr 00:02:72:D6:6A:3F mode 0
2012-07-19 13:24:44.056217 > HCI Event: Max Slots Change (0x1b) plen 3
    handle 42 slots 5
2012-07-19 13:24:44.059218 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 0
2012-07-19 13:24:44.062192 > HCI Event: Command Status (0x0f) plen 4
    Unknown (0x00|0x0000) status 0x00 ncmd 1
2012-07-19 13:24:44.067219 > HCI Event: Read Remote Supported Features (0x0b) plen 11
    status 0x00 handle 42
    Features: 0xbf 0xfe 0xcf 0xfe 0xdb 0xff 0x7b 0x87
2012-07-19 13:24:44.067248 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
    handle 42 page 1
2012-07-19 13:24:44.071217 > HCI Event: Command Status (0x0f) plen 4
    Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
2012-07-19 13:24:44.076218 > HCI Event: Read Remote Extended Features (0x23) plen 13
    status 0x00 handle 42 page 1 max 1
    Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
2012-07-19 13:24:44.076249 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
    bdaddr 00:02:72:D6:6A:3F mode 2 clkoffset 0x0000
2012-07-19 13:24:44.081218 > HCI Event: Command Status (0x0f) plen 4
    Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
2012-07-19 13:24:44.105214 > HCI Event: Remote Name Req Complete (0x07) plen 255
    status 0x00 bdaddr 00:02:72:D6:6A:3F name 'uw000951-0'
2012-07-19 13:24:44.105284 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
    handle 42
2012-07-19 13:24:44.111207 > HCI Event: Command Status (0x0f) plen 4
    Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
2012-07-19 13:24:44.112220 > HCI Event: Link Key Request (0x17) plen 6
    bdaddr 00:02:72:D6:6A:3F
2012-07-19 13:24:44.112249 < HCI Command: Link Key Request Negative Reply (0x01|0x000c) plen 6
    bdaddr 00:02:72:D6:6A:3F
2012-07-19 13:24:44.115215 > HCI Event: Command Complete (0x0e) plen 10
    Link Key Request Negative Reply (0x01|0x000c) ncmd 1
    status 0x00 bdaddr 00:02:72:D6:6A:3F
2012-07-19 13:24:44.116215 > HCI Event: PIN Code Request (0x16) plen 6
    bdaddr 00:02:72:D6:6A:3F
2012-07-19 13:24:48.099184 > HCI Event: Auth Complete (0x06) plen 3
    status 0x13 handle 42
    Error: Remote User Terminated Connection
2012-07-19 13:24:48.179182 > HCI Event: Disconn Complete (0x05) plen 4
    status 0x00 handle 42 reason 0x13
    Reason: Remote User Terminated Connection

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c  |    7 ++++++-
 net/bluetooth/l2cap_core.c |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1783,7 +1783,12 @@ static inline void hci_conn_complete_evt
 		if (conn->type == ACL_LINK) {
 			conn->state = BT_CONFIG;
 			hci_conn_hold(conn);
-			conn->disc_timeout = HCI_DISCONN_TIMEOUT;
+
+			if (!conn->out && !hci_conn_ssp_enabled(conn) &&
+			    !hci_find_link_key(hdev, &ev->bdaddr))
+				conn->disc_timeout = HCI_PAIRING_TIMEOUT;
+			else
+				conn->disc_timeout = HCI_DISCONN_TIMEOUT;
 		} else
 			conn->state = BT_CONNECTED;
 
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1163,6 +1163,7 @@ static void l2cap_le_conn_ready(struct l
 	sk = chan->sk;
 
 	hci_conn_hold(conn->hcon);
+	conn->hcon->disc_timeout = HCI_DISCONN_TIMEOUT;
 
 	bacpy(&bt_sk(sk)->src, conn->src);
 	bacpy(&bt_sk(sk)->dst, conn->dst);


