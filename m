Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0KAT37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:29:59 -0400
Received: from king.tilera.com ([72.1.168.226]:3864 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0KAT34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:29:56 -0400
Message-Id: <201011011929.oA1JTm24024942@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 1 Nov 2010 15:25:16 -0400
Subject: [PATCH] arch/tile: avoid __must_check warning on one strict_strtol check
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Nov 2010 19:29:48.0726 (UTC) FILETIME=[25BFA560:01CB79FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the "initfree" boot argument it's not that big a deal, but
to avoid warnings in the code, we check for a valid value before
allowing the specified argument to override the kernel default.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/init.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 78e1982..0b9ce69 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -988,8 +988,12 @@ static long __write_once initfree = 1;
 /* Select whether to free (1) or mark unusable (0) the __init pages. */
 static int __init set_initfree(char *str)
 {
-	strict_strtol(str, 0, &initfree);
-	pr_info("initfree: %s free init pages\n", initfree ? "will" : "won't");
+	long val;
+	if (strict_strtol(str, 0, &val)) {
+		initfree = val;
+		pr_info("initfree: %s free init pages\n",
+			initfree ? "will" : "won't");
+	}
 	return 1;
 }
 __setup("initfree=", set_initfree);
-- 
1.6.5.2

