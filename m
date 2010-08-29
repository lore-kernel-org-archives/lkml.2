Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0H2Jw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:52:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51034 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0H2Jw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:56 -0400
From: Julia Lawall <julia@diku.dk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 7/7] arch/powerpc/platforms/cell: Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:46 +0200
Message-Id: <1283075566-27441-8-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283075566-27441-1-git-send-email-julia@diku.dk>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to of_node_put in the error handling code following calls to
of_find_node_by_path and of_find_node_by_phandle.

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
 arch/powerpc/platforms/cell/ras.c        |    4 +++-
 arch/powerpc/platforms/cell/spider-pic.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index 1d3c4ef..5ec1e47 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -173,8 +173,10 @@ static int __init cbe_ptcal_enable(void)
 		return -ENODEV;
 
 	size = of_get_property(np, "ibm,cbe-ptcal-size", NULL);
-	if (!size)
+	if (!size) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	pr_debug("%s: enabling PTCAL, size = 0x%x\n", __func__, *size);
 	order = get_order(*size);
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 5876e88..3f2e557 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -258,8 +258,10 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 		return NO_IRQ;
 	imap += intsize + 1;
 	tmp = of_get_property(iic, "#interrupt-cells", NULL);
-	if (tmp == NULL)
+	if (tmp == NULL) {
+		of_node_put(iic);
 		return NO_IRQ;
+	}
 	intsize = *tmp;
 	/* Assume unit is last entry of interrupt specifier */
 	unit = imap[intsize - 1];

