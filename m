Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0FYWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 18:08:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33434 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab0FYWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 18:08:18 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 18:08:18 EDT
Subject: [PATCH] of/flattree: Fix crash when device tree absent
To: benh@kernel.crashing.org, monstr@monstr.eu
From: Grant Likely <grant.likely@secretlab.ca>
Cc: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       sfr@canb.auug.org.au
Date: Fri, 25 Jun 2010 16:03:06 -0600
Message-ID: <20100625220306.6903.17916.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the condition where device tree support is compiled
in, but no device tree was proved by firmware.  It makes
of_platform_bus_probe() explicitly check for a NULL device tree
pointer, and adds an error message if the device tree was unable
to be flattened.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/fdt.c      |    2 ++
 drivers/of/platform.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index b6987bb..beda593 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -94,6 +94,8 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 			break;
 	} while (1);
 
+	if (rc)
+		pr_err("Failed to unflatten device tree blob.  rc=%i\n", rc);
 	return rc;
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3eb4cf6..1f5a210 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -640,6 +640,8 @@ int of_platform_bus_probe(struct device_node *root,
 		root = of_find_node_by_path("/");
 	else
 		of_node_get(root);
+	if (root == NULL)
+		return -EINVAL;
 
 	pr_debug("of_platform_bus_probe()\n");
 	pr_debug(" starting at: %s\n", root->full_name);

