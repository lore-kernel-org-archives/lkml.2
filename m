Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1FXMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:38:20 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:53365 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1FXMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:38:18 -0400
Subject: [PATCH] Bluetooth: Prevent buffer overflow in l2cap config request
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 08:38:05 -0400
Message-ID: <1308919085.5295.11.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A remote user can provide a small value for the command size field in
the command header of an l2cap configuration request, resulting in an
integer underflow when subtracting the size of the configuration request
header.  This results in copying a very large amount of data via
memcpy() and destroying the kernel heap.  Check for underflow.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable <stable@kernel.org>
---
 net/bluetooth/l2cap_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e64a1c2..06ea272 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2334,7 +2334,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (chan->conf_len + len > sizeof(chan->conf_req)) {
+	if (len < 0 || chan->conf_len + len > sizeof(chan->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(chan, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);


