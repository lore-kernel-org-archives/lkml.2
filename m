Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0LLXsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36884 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0LLXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: philb@gnu.org, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [210/223] econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
Message-Id: <20101212234837.79CF1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Phil Blundell <philb@gnu.org>

commit fa0e846494792e722d817b9d3d625a4ef4896c96 upstream.

Later parts of econet_sendmsg() rely on saddr != NULL, so return early
with EINVAL if NULL was passed otherwise an oops may occur.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/econet/af_econet.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

Index: linux/net/econet/af_econet.c
===================================================================
--- linux.orig/net/econet/af_econet.c
+++ linux/net/econet/af_econet.c
@@ -297,23 +297,14 @@ static int econet_sendmsg(struct kiocb *
 
 	mutex_lock(&econet_mutex);
 
-	if (saddr == NULL) {
-		struct econet_sock *eo = ec_sk(sk);
-
-		addr.station = eo->station;
-		addr.net     = eo->net;
-		port	     = eo->port;
-		cb	     = eo->cb;
-	} else {
-		if (msg->msg_namelen < sizeof(struct sockaddr_ec)) {
-			mutex_unlock(&econet_mutex);
-			return -EINVAL;
-		}
-		addr.station = saddr->addr.station;
-		addr.net = saddr->addr.net;
-		port = saddr->port;
-		cb = saddr->cb;
-	}
+        if (saddr == NULL || msg->msg_namelen < sizeof(struct sockaddr_ec)) {
+                mutex_unlock(&econet_mutex);
+                return -EINVAL;
+        }
+        addr.station = saddr->addr.station;
+        addr.net = saddr->addr.net;
+        port = saddr->port;
+        cb = saddr->cb;
 
 	/* Look for a device with the right network number. */
 	dev = net2dev_map[addr.net];
@@ -351,7 +342,6 @@ static int econet_sendmsg(struct kiocb *
 
 		eb = (struct ec_cb *)&skb->cb;
 
-		/* BUG: saddr may be NULL */
 		eb->cookie = saddr->cookie;
 		eb->sec = *saddr;
 		eb->sent = ec_tx_done;
