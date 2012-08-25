Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2H1Ndg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:33:36 -0400
Received: from noserose.net ([66.220.18.76]:43044 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752162Ab2H1Ndf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:33:35 -0400
Message-Id: <3f93113bbc17094e23c299ae85735118ec217f17.1346158422.git.ecashin@coraid.com>
In-Reply-To: <cover.1346158422.git.ecashin@coraid.com>
References: <cover.1346158422.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Sat, 25 Aug 2012 10:39:50 -0400
Subject: [PATCH 06/14] aoe: failover remote interface based on aoe_deadsecs parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aoe_deadsecs module parameter allows the user to specify a hard
limit on the number of seconds an AoE command can be retransmitted
before the AoE block device is considered to have failed.

Using aoe_deadsecs to determine the time we try using a different
remote interface helps to ensure that the hard limit is not reached
before we've tried to recover by sending to a different remote port.

As a data storage target, the AoE target is unambiguously identified
by its {major, minor} AoE address tuple, and an AoE target can have
multiple MAC addresses.  However, note that "target" in the driver
code and comments means a {major, minor, MAC address} tuple, as in
"somewhere to send packets".

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoecmd.c |    8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index ffded64..d17b727 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -96,7 +96,6 @@ enum {
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
 	MAXTIMER = HZ << 1,
-	HELPWAIT = 20,
 };
 
 struct buf {
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index cf196ed..7f9cc44 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -632,11 +632,9 @@ rexmit_timer(ulong vp)
 		list_del(pos);
 
 		t = f->t;
-		if (n > HELPWAIT) {
-			/* see if another target can help */
-			if (d->ntargets > 1)
-				d->htgt = t;
-		}
+		if (n > aoe_deadsecs/2)
+			d->htgt = t; /* see if another target can help */
+
 		if (t->nout == t->maxout) {
 			if (t->maxout > 1)
 				t->maxout--;
-- 
1.7.2.5

