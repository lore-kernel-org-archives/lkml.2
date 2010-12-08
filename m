Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab0LHBER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:17 -0500
Received: from kroah.org ([198.145.64.141]:33903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab0LHBEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:07 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005748.956477911@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Blundell <philb@gnu.org>, "David S. Miller" <davem@davemloft.net>
Subject: [275/289] econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Blundell <philb@gnu.org>

commit fa0e846494792e722d817b9d3d625a4ef4896c96 upstream.

Later parts of econet_sendmsg() rely on saddr != NULL, so return early
with EINVAL if NULL was passed otherwise an oops may occur.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/econet/af_econet.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
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


