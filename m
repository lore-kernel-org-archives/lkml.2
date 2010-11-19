Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab0KSWS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:18:27 -0500
Received: from kroah.org ([198.145.64.141]:52841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab0KSWEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:06 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:23 2010
Message-Id: <20101119220123.086369324@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nathan Holstein <nathan.holstein@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [11/66] Bluetooth: fix oops in l2cap_connect_req
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nathan Holstein <nathan.holstein@gmail.com>

commit d793fe8caa3911e6a1e826b45d4ee00d250cdec8 upstream.

In error cases when the ACL is insecure or we fail to allocate a new
struct sock, we jump to the "response" label.  If so, "sk" will be
null and the kernel crashes.

Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/l2cap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2891,7 +2891,7 @@ static inline int l2cap_connect_req(stru
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


