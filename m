Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0H2Jxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:53:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51013 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0H2Jwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:55 -0400
From: Julia Lawall <julia@diku.dk>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 5/7] arch/powerpc/sysdev/qe_lib/qe.c: Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:44 +0200
Message-Id: <1283075566-27441-6-git-send-email-julia@diku.dk>
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
 arch/powerpc/sysdev/qe_lib/qe.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index 3da8014..90020de 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -640,6 +640,7 @@ unsigned int qe_get_num_of_snums(void)
 		if ((num_of_snums < 28) || (num_of_snums > QE_NUM_OF_SNUM)) {
 			/* No QE ever has fewer than 28 SNUMs */
 			pr_err("QE: number of snum is invalid\n");
+			of_node_put(qe);
 			return -EINVAL;
 		}
 	}

