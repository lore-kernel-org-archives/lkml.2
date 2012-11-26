Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab2KZRL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab2KZRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 181/270] Bluetooth: SMP: Fix setting unknown auth_req bits
Date: Mon, 26 Nov 2012 14:57:51 -0200
Message-Id: <1353949160-26803-182-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/smp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 926043c..22fe004 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -31,6 +31,8 @@
 
 #define SMP_TIMEOUT	msecs_to_jiffies(30000)
 
+#define AUTH_REQ_MASK   0x07
+
 static inline void swap128(u8 src[16], u8 dst[16])
 {
 	int i;
@@ -229,7 +231,7 @@ static void build_pairing_cmd(struct l2cap_conn *conn,
 		req->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 		req->init_key_dist = 0;
 		req->resp_key_dist = dist_keys;
-		req->auth_req = authreq;
+		req->auth_req = (authreq & AUTH_REQ_MASK);
 		return;
 	}
 
@@ -238,7 +240,7 @@ static void build_pairing_cmd(struct l2cap_conn *conn,
 	rsp->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 	rsp->init_key_dist = 0;
 	rsp->resp_key_dist = req->resp_key_dist & dist_keys;
-	rsp->auth_req = authreq;
+	rsp->auth_req = (authreq & AUTH_REQ_MASK);
 }
 
 static u8 check_enc_key_size(struct l2cap_conn *conn, __u8 max_key_size)
-- 
1.7.9.5

