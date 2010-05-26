Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0EZP4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:56:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40737 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0EZP4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:56:38 -0400
Date: Wed, 26 May 2010 17:56:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/17] net/caif: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261756150.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  The spin lock is used in a
balanced way elsewhere in the file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/caif/cfmuxl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/cfmuxl.c b/net/caif/cfmuxl.c
index 7372f27..80c8d33 100644
--- a/net/caif/cfmuxl.c
+++ b/net/caif/cfmuxl.c
@@ -174,10 +174,11 @@ struct cflayer *cfmuxl_remove_uplayer(struct cflayer *layr, u8 id)
 	spin_lock(&muxl->receive_lock);
 	up = get_up(muxl, id);
 	if (up == NULL)
-		return NULL;
+		goto out;
 	memset(muxl->up_cache, 0, sizeof(muxl->up_cache));
 	list_del(&up->node);
 	cfsrvl_put(up);
+out:
 	spin_unlock(&muxl->receive_lock);
 	return up;
 }
