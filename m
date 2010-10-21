Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0JUFWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:22:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41977 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0JUFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:22:04 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: greg@kroah.com, linux-bluetooth@vger.kernel.org
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Nathan Holstein <nathan.holstein@gmail.com>
Subject: [PATCH 1/1] Bluetooth: fix oops in l2cap_connect_req
Date: Thu, 21 Oct 2010 03:19:53 -0200
Message-Id: <1287638393-8573-2-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
References: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Holstein <nathan.holstein@gmail.com>

In error cases when the ACL is insecure or we fail to allocate a new
struct sock, we jump to the "response" label.  If so, "sk" will be
null and the kernel crashes.

Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 net/bluetooth/l2cap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 0b54b7d..dc60205 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2891,7 +2891,7 @@ static inline int l2cap_connect_req(struct l2cap_conn *conn, struct l2cap_cmd_hd
 	struct l2cap_chan_list *list = &conn->chan_list;
 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
 	struct l2cap_conn_rsp rsp;
-	struct sock *parent, *uninitialized_var(sk);
+	struct sock *parent, *sk = NULL;
 	int result, status = L2CAP_CS_NO_INFO;
 
 	u16 dcid = 0, scid = __le16_to_cpu(req->scid);
@@ -3000,7 +3000,7 @@ sendresp:
 					L2CAP_INFO_REQ, sizeof(info), &info);
 	}
 
-	if (!(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
+	if (sk && !(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
 				result == L2CAP_CR_SUCCESS) {
 		u8 buf[128];
 		l2cap_pi(sk)->conf_state |= L2CAP_CONF_REQ_SENT;
-- 
1.7.3.1

