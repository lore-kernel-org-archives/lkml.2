Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0G3PRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:17:32 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60969 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0G3PRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:17:30 -0400
Date: Fri, 30 Jul 2010 17:17:28 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] arch/arm/common: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1007301717040.17618@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

__sa1111_remove always frees its argument, so the subsequent reference to
sachip->saved_state represents a use after free.  __sa1111_remove does not
appear to use the saved_state field, so the patch simply frees it first.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E2;
@@

__sa1111_remove(E)
...
(
  E = E2
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
arch/arm/common/sa1111.c            |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index ac2fd44..517d50d 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -1025,13 +1025,12 @@ static int sa1111_remove(struct platform_device *pdev)
 	struct sa1111 *sachip = platform_get_drvdata(pdev);
 
 	if (sachip) {
-		__sa1111_remove(sachip);
-		platform_set_drvdata(pdev, NULL);
-
 #ifdef CONFIG_PM
 		kfree(sachip->saved_state);
 		sachip->saved_state = NULL;
 #endif
+		__sa1111_remove(sachip);
+		platform_set_drvdata(pdev, NULL);
 	}
 
 	return 0;
