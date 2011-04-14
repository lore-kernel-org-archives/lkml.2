Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1DNR5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:41475 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674Ab1DNR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Phil Blundell <philb@gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 123/209] econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
Date: Thu, 14 Apr 2011 13:54:41 -0400
Message-Id: <1302803767-9715-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Blundell <philb@gnu.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit fa0e846494792e722d817b9d3d625a4ef4896c96 upstream.

Later parts of econet_sendmsg() rely on saddr != NULL, so return early
with EINVAL if NULL was passed otherwise an oops may occur.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/econet/af_econet.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 2a5a805..8170acb 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -297,23 +297,14 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
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
@@ -351,7 +342,6 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 		eb = (struct ec_cb *)&skb->cb;
 
-		/* BUG: saddr may be NULL */
 		eb->cookie = saddr->cookie;
 		eb->sec = *saddr;
 		eb->sent = ec_tx_done;
-- 
1.7.4.4

