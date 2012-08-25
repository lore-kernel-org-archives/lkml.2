Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2H1Nf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:35:58 -0400
Received: from noserose.net ([66.220.18.76]:45384 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751781Ab2H1Nf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:35:57 -0400
Message-Id: <c1f14dc6b8097c6d0b3780d422c13ffc0ee2b259.1346158422.git.ecashin@coraid.com>
In-Reply-To: <cover.1346158422.git.ecashin@coraid.com>
References: <cover.1346158422.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Sat, 25 Aug 2012 10:39:51 -0400
Subject: [PATCH 08/14] aoe: disallow unsupported AoE minor addresses
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A guard is inserted to prevent AoE minor addresses (slot addresses)
higher than 15 to be used, as they are not yet supported by the
driver.

There is a change coming that will allow the aoe driver to overcome
this limit by using system device minor numbers dynamically, but until
then, this guard prevents unexpected targets from being used by the
driver when AoE targets with high minor numbers are on the AoE
network.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 7f9cc44..61cc1cf 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1359,6 +1359,13 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
+	if (h->minor >= NPERSHELF) {
+		pr_err("aoe: e%ld.%d %s, %d\n",
+			aoemajor, h->minor,
+			"slot number larger than the maximum",
+			NPERSHELF-1);
+		return;
+	}
 
 	sysminor = SYSMINOR(aoemajor, h->minor);
 	if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
-- 
1.7.2.5

