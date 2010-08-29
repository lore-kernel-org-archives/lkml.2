Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0H2JyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:54:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50994 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0H2Jwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:53 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 2/7] drivers/serial/mpc52xx_uart.c: Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:41 +0200
Message-Id: <1283075566-27441-3-git-send-email-julia@diku.dk>
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
 drivers/serial/mpc52xx_uart.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 8dedb26..c4399e2 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -500,6 +500,7 @@ static int __init mpc512x_psc_fifoc_init(void)
 	psc_fifoc = of_iomap(np, 0);
 	if (!psc_fifoc) {
 		pr_err("%s: Can't map FIFOC\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 

