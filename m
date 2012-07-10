Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2GJQX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:23:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50372 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2GJQXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:23:55 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/4] UBI: Use the whole NAND device to calculate max bad block number
Date: Tue, 10 Jul 2012 18:23:38 +0200
Message-Id: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch serie applies on top of Shmulik Ladkani's patch serie:
"[PATCH 0/5] ubi: Fix bad PEBs reserve caclulation"
(and on mtd-artem git tree)

The goal here is to make UBI reserve a number of PEB for bad block dependant
of the whole NAND chipset size, and not of the MTD partition size.

As explained in patch 3/4, the NAND manufacturers only tell how many bad blocks
there will be in the worst case on a NAND device, but not that these blocks
will be equally disposed on the flash.
I.E. if a NAND flash admits at max 40 bad blocks, and is cutted in two equal
MTD partitions, it doesn't mean that there will be at max only 20 bad blocks
per partition.
The 40 BEBs could be all on the first partition.

So, for each MTD partition, UBI should reserved the maximum expected number of
bad erase blocks.

Patches 1/2/3 are making that happend with a kernel option MTD_UBI_BEB_LIMIT
Then, patch 4 replace this option with user-space parameters (kernel parameter
and a UBI_IOCATT ioctl)

The patch on mtd-utils follows the serie.

Richard Genoud (4):
  mtd_is_partition: struct mtd_info should be const
  MTD parts: introduce mtd_get_device_size()
  UBI: use the whole MTD device size to get bad_peb_limit
  UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter

 drivers/mtd/mtdpart.c          |   16 ++++++++-
 drivers/mtd/ubi/Kconfig        |   19 ----------
 drivers/mtd/ubi/build.c        |   73 ++++++++++++++++++++++++++++++---------
 drivers/mtd/ubi/cdev.c         |    9 ++++-
 drivers/mtd/ubi/ubi.h          |    6 +++-
 include/linux/mtd/partitions.h |    3 +-
 include/mtd/ubi-user.h         |   19 ++++++++++-
 7 files changed, 104 insertions(+), 41 deletions(-)

-- 
1.7.2.5

