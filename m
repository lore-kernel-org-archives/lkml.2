Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0EZP45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:56:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40742 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab0EZP4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:56:54 -0400
Date: Wed, 26 May 2010 17:56:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
       "David S. , Miller" <davem@davemloft.net>, linux-s390@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/17] net/iucv: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261756330.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  There seems like no reason
why the lock should continue to be held if the kzalloc fail.

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
 net/iucv/af_iucv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c8b4599..9637e45 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1619,7 +1619,7 @@ static void iucv_callback_rx(struct iucv_path *path, struct iucv_message *msg)
 save_message:
 	save_msg = kzalloc(sizeof(struct sock_msg_q), GFP_ATOMIC | GFP_DMA);
 	if (!save_msg)
-		return;
+		goto out_unlock;
 	save_msg->path = path;
 	save_msg->msg = *msg;
 
