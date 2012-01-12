Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2ALJ4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:56:05 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41686 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab2ALJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:33 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: John Stultz <johnstul@us.ibm.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] drivers/clocksource/cyclone.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:15 +0100
Message-Id: <1326362117-29371-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/clocksource/cyclone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 72f811f..9e0998f 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -55,11 +55,11 @@ static int __init init_cyclone_clocksource(void)
 	}
 	/* even on 64bit systems, this is only 32bits: */
 	base = readl(reg);
+	iounmap(reg);
 	if (!base) {
 		printk(KERN_ERR "Summit chipset: Could not find valid CBAR value.\n");
 		return -ENODEV;
 	}
-	iounmap(reg);
 
 	/* setup PMCC: */
 	offset = base + CYCLONE_PMCC_OFFSET;

