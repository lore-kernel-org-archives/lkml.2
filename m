Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2J1XeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:34:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42184 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab2J1X2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:24 -0400
Message-Id: <20121028231549.745388506@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 041/105] Bluetooth: SMP: Fix setting unknown auth_req bits
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 065a13e2cc665f6547dc7e8a9d6b6565badf940a upstream.

When sending a pairing request or response we should not just blindly
copy the value that the remote device sent. Instead we should at least
make sure to mask out any unknown bits. This is particularly critical
from the upcoming LE Secure Connections feature perspective as
incorrectly indicating support for it (by copying the remote value)
would cause a failure to pair with devices that support it.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/smp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -30,6 +30,8 @@
 
 #define SMP_TIMEOUT 30000 /* 30 seconds */
 
+#define AUTH_REQ_MASK   0x07
+
 static inline void swap128(u8 src[16], u8 dst[16])
 {
 	int i;
@@ -206,7 +208,7 @@ static void build_pairing_cmd(struct l2c
 		req->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 		req->init_key_dist = dist_keys;
 		req->resp_key_dist = dist_keys;
-		req->auth_req = authreq;
+		req->auth_req = (authreq & AUTH_REQ_MASK);
 		return;
 	}
 
@@ -215,7 +217,7 @@ static void build_pairing_cmd(struct l2c
 	rsp->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 	rsp->init_key_dist = req->init_key_dist & dist_keys;
 	rsp->resp_key_dist = req->resp_key_dist & dist_keys;
-	rsp->auth_req = authreq;
+	rsp->auth_req = (authreq & AUTH_REQ_MASK);
 }
 
 static u8 check_enc_key_size(struct l2cap_conn *conn, __u8 max_key_size)


