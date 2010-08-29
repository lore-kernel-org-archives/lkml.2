Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0H2Jxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:53:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51012 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab0H2Jwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:55 -0400
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 4/7] arch/powerpc/platforms/powermac/pfunc_core.c: Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:43 +0200
Message-Id: <1283075566-27441-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283075566-27441-1-git-send-email-julia@diku.dk>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to of_node_put in the error handling code following a call to
of_find_node_by_phandle.

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
 arch/powerpc/platforms/powermac/pfunc_core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/pfunc_core.c b/arch/powerpc/platforms/powermac/pfunc_core.c
index cec6359..b0c3777 100644
--- a/arch/powerpc/platforms/powermac/pfunc_core.c
+++ b/arch/powerpc/platforms/powermac/pfunc_core.c
@@ -837,8 +837,10 @@ struct pmf_function *__pmf_find_function(struct device_node *target,
 		return NULL;
  find_it:
 	dev = pmf_find_device(actor);
-	if (dev == NULL)
-		return NULL;
+	if (dev == NULL) {
+		result = NULL;
+		goto out;
+	}
 
 	list_for_each_entry(func, &dev->functions, link) {
 		if (name && strcmp(name, func->name))
@@ -850,8 +852,9 @@ struct pmf_function *__pmf_find_function(struct device_node *target,
 		result = func;
 		break;
 	}
-	of_node_put(actor);
 	pmf_put_device(dev);
+out:
+	of_node_put(actor);
 	return result;
 }
 

