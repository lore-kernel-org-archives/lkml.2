Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0EVIZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:25:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60778 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab0EVIZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:25:26 -0400
Date: Sat, 22 May 2010 10:25:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 22/27] net/dccp: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221025040.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/dccp/proto.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index b03ecf6..f79bcef 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -473,14 +473,9 @@ static int dccp_setsockopt_ccid(struct sock *sk, int type,
 	if (optlen < 1 || optlen > DCCP_FEAT_MAX_SP_VALS)
 		return -EINVAL;
 
-	val = kmalloc(optlen, GFP_KERNEL);
-	if (val == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(val, optval, optlen)) {
-		kfree(val);
-		return -EFAULT;
-	}
+	val = memdup_user(optval, optlen);
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
 	lock_sock(sk);
 	if (type == DCCP_SOCKOPT_TX_CCID || type == DCCP_SOCKOPT_CCID)
