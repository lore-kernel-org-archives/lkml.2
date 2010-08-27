Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0H0VBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:01:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41285 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0H0VBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:01:47 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/clocksource/cyclone.c: Move up iounmap
Date: Fri, 27 Aug 2010 23:01:29 +0200
Message-Id: <1282942890-465-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By moving the iounmap up above the test, it takes place whether the test
succeeds or fails.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E,E1;
identifier l;
statement S;
@@

*x = ioremap_nocache(...);
...
if (x == NULL) S
... when != iounmap(x)
    when != if (...) { ... iounmap(x); ... }
    when != E = x
if (...) {
  ... when != iounmap(x)
      when != if (...) { ... iounmap(x); ... }
(
  return <+...x...+>;
|
* return ...;
)
}
... when != x = E1
iounmap(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/clocksource/cyclone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 64e528e..4c62e20 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -57,11 +57,11 @@ static int __init init_cyclone_clocksource(void)
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

