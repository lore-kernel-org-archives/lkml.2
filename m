Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0H2JyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:54:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50995 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0H2Jwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:53 -0400
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/7] drivers/mtd/nand/mpc5121_nfc.c: Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:42 +0200
Message-Id: <1283075566-27441-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283075566-27441-1-git-send-email-julia@diku.dk>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to of_node_put in the error handling code following a call to
of_find_compatible_node.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E,E1;
statement S;
@@

*x = 
(of_find_node_by_path
|of_find_node_by_name
|of_find_node_by_phandle
|of_get_parent
|of_get_next_parent
|of_get_next_child
|of_find_compatible_node
|of_match_node
)(...);
...
if (x == NULL) S
<... when != x = E
*if (...) {
  ... when != of_node_put(x)
      when != if (...) { ... of_node_put(x); ... }
(
  return <+...x...+>;
|
*  return ...;
)
}
...>
of_node_put(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/mpc5121_nfc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index df0c1da..f4610bc 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -568,6 +568,7 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info *mtd)
 	uint rcw_width;
 	uint rcwh;
 	uint romloc, ps;
+	int ret = 0;
 
 	rmnode = of_find_compatible_node(NULL, NULL, "fsl,mpc5121-reset");
 	if (!rmnode) {
@@ -579,7 +580,8 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info *mtd)
 	rm = of_iomap(rmnode, 0);
 	if (!rm) {
 		dev_err(prv->dev, "Error mapping reset module node!\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	rcwh = in_be32(&rm->rcwhr);
@@ -628,8 +630,9 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info *mtd)
 				rcw_width * 8, rcw_pagesize,
 				rcw_sparesize);
 	iounmap(rm);
+out:
 	of_node_put(rmnode);
-	return 0;
+	return ret;
 }
 
 /* Free driver resources */

