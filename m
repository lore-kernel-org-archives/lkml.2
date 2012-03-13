Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab2CMAZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:49072 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965298Ab2CMAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 194/196] Bluetooth: Prevent buffer overflow in l2cap config request
Date: Mon, 12 Mar 2012 20:21:47 -0400
Message-Id: <1331598109-31424-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7ac28817536797fd40e9646452183606f9e17f71 upstream.

A remote user can provide a small value for the command size field in
the command header of an l2cap configuration request, resulting in an
integer underflow when subtracting the size of the configuration request
header.  This results in copying a very large amount of data via
memcpy() and destroying the kernel heap.  Check for underflow.

[PG: 34 uses l2cap_pi(sk)->... instead of a local chan->... variable]

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/l2cap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 9753b69..b21e319 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2746,7 +2746,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
+	if (len < 0 || l2cap_pi(sk)->conf_len + len >
+					 sizeof(l2cap_pi(sk)->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(sk, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);
-- 
1.7.9.3

