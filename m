Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab0ITE6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 00:58:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43124 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0ITE6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 00:58:20 -0400
Date: Mon, 20 Sep 2010 14:58:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the bkl-trivial tree with the mmc tree
Message-Id: <20100920145817.71fa0c35.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-trivial tree got a conflict in
drivers/mmc/card/block.c between commit
28280d210bacf6788a5e4b12c5a9430bd50860b4 ("mmc: make number of mmcblk
minors configurable") from the mmc tree and commit
5778067afcfd8b718ffc3744c25fdd194fc886a1 ("block: autoconvert trivial BKL
users to private mutex") from the bkl-trivial tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/card/block.c
index 5568044,00073b7..0000000
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@@ -44,26 -43,15 +43,27 @@@
  #include "queue.h"
  
  MODULE_ALIAS("mmc:block");
 +#ifdef MODULE_PARAM_PREFIX
 +#undef MODULE_PARAM_PREFIX
 +#endif
 +#define MODULE_PARAM_PREFIX "mmcblk."
 +
 +
 +/*
 + * The defaults come from config options but can be overriden by module
 + * or bootarg options.
 + */
 +static int perdev_minors = CONFIG_MMC_BLOCK_MINORS;
  
  /*
 - * max 8 partitions per card
 + * We've only got one major, so number of mmcblk devices is
 + * limited to 256 / number of minors per device.
   */
 -#define MMC_SHIFT	3
 -#define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
 +static int max_devices;
  
+ static DEFINE_MUTEX(block_mutex);
 -static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
 +/* 256 minors, so at most 256 separate devices */
 +static DECLARE_BITMAP(dev_use, 256);
  
  /*
   * There is one mmc_blk_data per slot.
