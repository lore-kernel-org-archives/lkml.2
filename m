Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2HZFUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 01:20:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2HZFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 01:20:35 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, shmulik.ladkani@gmail.com,
        Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 3/3] mtd: cmdlinepart: fix the wrong partitions number when truncating occurs
Date: Sun, 26 Aug 2012 13:21:40 -0400
Message-Id: <1346001700-26895-3-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on the assumption that all the partitions are
in the right offset order.

Assume we have a 1GB(8Gb) nand chip, and we set the partitions
in the command line like this:
    #gpmi-nand:100m(boot),100m(kernel),1g(rootfs)

In this case, the partition truncating occurs. The current code will
get the following result:

     ----------------------------------
	root@freescale ~$ cat /proc/mtd
	dev:    size   erasesize  name
	mtd0: 06400000 00040000 "boot"
	mtd1: 06400000 00040000 "kernel"
     ----------------------------------

It is obvious that we lost the truncated partition `rootfs` which should
be 824M in this case.

Why? The old code sets the wrong partitions number when the truncating
occurs. This patch fixes it. Alao add a `break` to shortcut the code in this
case.

After apply this patch, the result becomes:
     ----------------------------------
	root@freescale ~$ cat /proc/mtd
	dev:    size   erasesize  name
	mtd0: 06400000 00040000 "boot"
	mtd1: 06400000 00040000 "kernel"
	mtd2: 33800000 00040000 "rootfs"
     ----------------------------------

We get the right result.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/cmdlinepart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index f40d390..9f0afe5 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -382,7 +382,8 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 					       "%s: partitioning exceeds flash size, truncating\n",
 					       part->mtd_id);
 					part->parts[i].size = master->size - offset;
-					part->num_parts = i;
+					part->num_parts = i + 1;
+					break;
 				}
 				offset += part->parts[i].size;
 			}
-- 
1.7.4.4

