Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1GDOLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:11:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35335 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1GDOLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:11:50 -0400
From: Julia Lawall <julia@diku.dk>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] arch/arm/mach-omap2/smartreflex.c: add missing error-handling code
Date: Mon,  4 Jul 2011 16:11:43 +0200
Message-Id: <1309788705-22278-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At this point, the ioremap has taken place, so the error handling code at
the label err_iounmap should be used rather than returning directly.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x;
@@

kfree(x)

@@
identifier r.x;
expression E1!=0,E2,E3,E4;
statement S;
@@

(
if (<+...x...+>) S
|
if (...) { ... when != kfree(x)
               when != if (...) { ... kfree(x); ... }
               when != x = E3
* return E1;
}
... when != x = E2
if (...) { ... when != x = E4
 kfree(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-omap2/smartreflex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index fb7dc52..e8280df 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -891,7 +891,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		ret = sr_late_init(sr_info);
 		if (ret) {
 			pr_warning("%s: Error in SR late init\n", __func__);
-			return ret;
+			goto err_iounmap;
 		}
 	}
 

