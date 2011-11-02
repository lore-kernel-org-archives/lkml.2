Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab1KCBh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933815Ab1KCBhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.745243050@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [105/107] Bluetooth: Prevent buffer overflow in l2cap config request
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2720,7 +2720,7 @@ static inline int l2cap_config_req(struc
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
+	if (len < 0 || l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(sk, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);


