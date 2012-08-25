Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2HYIFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:05:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47648 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2HYIF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:05:28 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2] mtd: cmdlinepart: fix the wrong check condition
Date: Sat, 25 Aug 2012 16:06:50 -0400
Message-Id: <1345925210-7500-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `mtd_id` is set by the name of a mtd device driver.

As a nand controller driver, even we do not set the @name of
the mtd_info{}, the nand_get_flash_type() will set it with
the nand type's name. So the `mtd_id` can never be NULL in this
case.

But as a nor controller driver which may does not call the
nand_get_flash_type(), there is a risk that the `mtd_id` becames NULL.

If the `mtd_id` is NULL, the check condition will be true.
If we accidentally set some partitions in the kernel command line,
just like:
          #gpmi-nand:20m(boot),20m(kernel),1g(rootfs),-(user)

The cmdlinepart may parses out several mtd partitions right now.
This is obviously wrong. We even do not enable the gpmi-nand in
this case.

The patch comes from Artem's suggestion code which is better then mine.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/cmdlinepart.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index fc960a3..216d751 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -322,13 +322,16 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 	struct cmdline_mtd_partition *part;
 	const char *mtd_id = master->name;
 
+	if (!mtd_id)
+		return 0;
+
 	/* parse command line */
 	if (!cmdline_parsed)
 		mtdpart_setup_real(cmdline);
 
 	for(part = partitions; part; part = part->next)
 	{
-		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
+		if (!strcmp(part->mtd_id, mtd_id))
 		{
 			for(i = 0, offset = 0; i < part->num_parts; i++)
 			{
-- 
1.7.4.4

