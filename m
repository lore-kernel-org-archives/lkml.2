Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2BEWmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:42:00 -0500
Received: from 1wt.eu ([62.212.114.60]:61977 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab2BEW0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:34 -0500
Message-Id: <20120205220951.631049117@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 51/91] Bluetooth: Prevent buffer overflow in l2cap config request
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 7ac28817536797fd40e9646452183606f9e17f71 upstream.

A remote user can provide a small value for the command size field in
the command header of an l2cap configuration request, resulting in an
integer underflow when subtracting the size of the configuration request
header.  This results in copying a very large amount of data via
memcpy() and destroying the kernel heap.  Check for underflow.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bluetooth/l2cap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/net/bluetooth/l2cap.c
===================================================================
--- longterm-2.6.27.orig/net/bluetooth/l2cap.c	2012-02-05 22:34:33.464915011 +0100
+++ longterm-2.6.27/net/bluetooth/l2cap.c	2012-02-05 22:34:42.135914462 +0100
@@ -1737,7 +1737,7 @@
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
+	if (len < 0 || l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(sk, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);


