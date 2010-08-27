Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0H0VCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:02:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41287 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab0H0VBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:01:48 -0400
From: Julia Lawall <julia@diku.dk>
To: Tony Luck <tony.luck@intel.com>
Cc: kernel-janitors@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arch/ia64/kernel: Move up iounmap
Date: Fri, 27 Aug 2010 23:01:30 +0200
Message-Id: <1282942890-465-2-git-send-email-julia@diku.dk>
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
 arch/ia64/kernel/cyclone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index 71e3586..d52f1f7 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -59,13 +59,13 @@ int __init init_cyclone_clock(void)
 		return -ENODEV;
 	}
 	base = readq(reg);
+	iounmap(reg);
 	if(!base){
 		printk(KERN_ERR "Summit chipset: Could not find valid CBAR"
 				" value.\n");
 		use_cyclone = 0;
 		return -ENODEV;
 	}
-	iounmap(reg);
 
 	/* setup PMCC */
 	offset = (base + CYCLONE_PMCC_OFFSET);

