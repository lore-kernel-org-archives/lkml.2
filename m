Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0IDKMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 06:12:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46092 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab0IDKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 06:12:04 -0400
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arch/powerpc/kernel/irq.c: Add of_node_put to avoid memory leak
Date: Sat,  4 Sep 2010 12:12:44 +0200
Message-Id: <1283595164-29146-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case, a device_node structure is stored in another structure that
is then freed without first decrementing the reference count of the
device_node structure.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression x;
identifier f;
position p1,p2;
@@

x@p1->f = \(of_find_node_by_path\|of_find_node_by_name\|of_find_node_by_phandle\|of_get_parent\|of_get_next_parent\|of_get_next_child\|of_find_compatible_node\|of_match_node\|of_find_node_by_type\|of_find_node_with_property\|of_find_matching_node\|of_parse_phandle\|of_node_get\)(...);
... when != of_node_put(x)
kfree@p2(x)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@
cocci.print_main("call",p1)
cocci.print_secs("free",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/kernel/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 4a65386..0a5bbe5 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -587,8 +587,10 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 			 * this will be fixed once slab is made available early
 			 * instead of the current cruft
 			 */
-			if (mem_init_done)
+			if (mem_init_done) {
+				of_node_put(host->of_node);
 				kfree(host);
+			}
 			return NULL;
 		}
 		irq_map[0].host = host;

