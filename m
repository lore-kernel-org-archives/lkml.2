Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497Ab2J2WBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:01:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:47953 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761360Ab2J2Vh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 083/101] Bluetooth: SMP: Fix setting unknown auth_req bits
Date: Mon, 29 Oct 2012 14:35:36 -0700
Message-Id: <20121029213249.536788976@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -32,6 +32,8 @@
 
 #define SMP_TIMEOUT	msecs_to_jiffies(30000)
 
+#define AUTH_REQ_MASK   0x07
+
 static inline void swap128(u8 src[16], u8 dst[16])
 {
 	int i;
@@ -230,7 +232,7 @@ static void build_pairing_cmd(struct l2c
 		req->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 		req->init_key_dist = 0;
 		req->resp_key_dist = dist_keys;
-		req->auth_req = authreq;
+		req->auth_req = (authreq & AUTH_REQ_MASK);
 		return;
 	}
 
@@ -239,7 +241,7 @@ static void build_pairing_cmd(struct l2c
 	rsp->max_key_size = SMP_MAX_ENC_KEY_SIZE;
 	rsp->init_key_dist = 0;
 	rsp->resp_key_dist = req->resp_key_dist & dist_keys;
-	rsp->auth_req = authreq;
+	rsp->auth_req = (authreq & AUTH_REQ_MASK);
 }
 
 static u8 check_enc_key_size(struct l2cap_conn *conn, __u8 max_key_size)


