Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab2EIMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:16:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3153 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab2EIMQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:16:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 09 May 2012 05:16:58 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regmap: fix possible memory corruption in regmap_bulk_read()
Date: Wed,  9 May 2012 17:43:12 +0530
Message-Id: <1336565592-17577-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function regmap_bulk_read() calls the regmap_read() for
each register if set of register has volatile and cache is
enabled. In this case, last few register read makes the memory
corruption if the register size is not the size of unsigned int.
The regam_read() takes argument as unsigned int for returning
value and it update the value as
	*val = map->format.parse_val(map->work_buf);
This causes complete 4 bytes (size of unsigned int) to get written.
Now if client pass the memory pointer for value which is equal to the
required size of register count in regmap_bulk_read() then last few
register read actually update the memory beyond passed pointer size.

Avoid this by using local variable for read and then do memcpy()
for actual byte copy to passed pointer based on register size.

I allocated one pointer ptr and take first 16 bytes dump of that
pointer then call regmap_bulk_read() with pointer which is just
on top of this allocated pointer and register count of 128. Here
register size is 1 byte.
The memory trace of last 5 register read are as follows:

[    5.438589] regmap_bulk_read after regamp_read() for register 122
[    5.447421] 0xef993c20 0xef993c00 0x00000000 0x00000001
[    5.467535] regmap_bulk_read after regamp_read() for register 123
[    5.476374] 0xef993c20 0xef993c00 0x00000000 0x00000001
[    5.496425] regmap_bulk_read after regamp_read() for register 124
[    5.505260] 0xef993c20 0xef993c00 0x00000000 0x00000001
[    5.525372] regmap_bulk_read after regamp_read() for register 125
[    5.534205] 0xef993c00 0xef993c00 0x00000000 0x00000001
[    5.554258] regmap_bulk_read after regamp_read() for register 126
[    5.563100] 0xef990000 0xef993c00 0x00000000 0x00000001
[    5.554258] regmap_bulk_read after regamp_read() for register 127
[    5.587108] 0xef000000 0xef993c00 0x00000000 0x00000001

Here it is observed that the memory content at first word started changing
on last 3 regmap_read() and so corruption happened.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch is against the linus' tree.
Added tree as
git remote add -t master -f linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

 drivers/base/regmap/regmap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7a3f535..bb80853 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -775,9 +775,11 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 			map->format.parse_val(val + i);
 	} else {
 		for (i = 0; i < val_count; i++) {
-			ret = regmap_read(map, reg + i, val + (i * val_bytes));
+			unsigned int ival;
+			ret = regmap_read(map, reg + i, &ival);
 			if (ret != 0)
 				return ret;
+			memcpy(val + (i * val_bytes), &ival, val_bytes);
 		}
 	}
 
-- 
1.7.1.1

