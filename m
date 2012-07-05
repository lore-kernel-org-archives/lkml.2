Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab2GEOco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:32:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47601 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2GEOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:32:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] of: address: Don't fail a lookup just because a node has no reg property
Date: Thu,  5 Jul 2012 15:32:34 +0100
Message-Id: <1341498754-30445-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it doesn't make any sense for a node to have an address.
In this case device lookup will always be unsuccessful because we
currently assume every node will have a reg property. This patch
changes the semantics so that the resource address and the lookup
address will only be compared if one exists.

Things like AUXDATA() rely on of_dev_lookup to return the lookup
entry of a particular device in order to do things like apply
platform_data to a device. However, this is currently broken for
nodes which do not have a reg property, meaning that platform_data
can not be passed in those cases.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/platform.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 343ad29..9600480 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -317,10 +317,9 @@ static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *l
 	for(; lookup->compatible != NULL; lookup++) {
 		if (!of_device_is_compatible(np, lookup->compatible))
 			continue;
-		if (of_address_to_resource(np, 0, &res))
-			continue;
-		if (res.start != lookup->phys_addr)
-			continue;
+		if (!of_address_to_resource(np, 0, &res))
+			if (res.start != lookup->phys_addr)
+				continue;
 		pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
 		return lookup;
 	}
-- 
1.7.9.5

