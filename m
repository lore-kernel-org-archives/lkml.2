Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2A2Udx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:33:53 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20198 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2A2Udv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:33:51 -0500
Date: Sun, 29 Jan 2012 21:34:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcma: Fix mem leak in bcma_bus_scan()
Message-ID: <alpine.LNX.2.00.1201292131480.27749@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcma_bus_scan() leaks 'struct bcma_device' bytes if
bcma_get_next_core() returns error.

Restructure the code so we always kfree() the memory we allocate to
the variable 'core' before it goes out of scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/bcma/scan.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

 Note: Patch is compile tested only.

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cad9948..3a2f672 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -399,15 +399,18 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		core->bus = bus;
 
 		err = bcma_get_next_core(bus, &eromptr, NULL, core_num, core);
-		if (err == -ENODEV) {
-			core_num++;
-			continue;
-		} else if (err == -ENXIO)
-			continue;
-		else if (err == -ESPIPE)
-			break;
-		else if (err < 0)
+		if (err < 0) {
+			kfree(core);
+			if (err == -ENODEV) {
+				core_num++;
+				continue;
+			} else if (err == -ENXIO) {
+				continue;
+			} else if (err == -ESPIPE) {
+				break;
+			}
 			return err;
+		}
 
 		core->core_index = core_num++;
 		bus->nr_cores++;
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

