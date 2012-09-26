Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2IZPwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:52:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2IZPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:06 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com
Subject: UBI: Fastmap request for inclusion (v19)
Date: Wed, 26 Sep 2012 17:51:40 +0200
Message-Id: <1348674710-102885-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBI Fastmap is an optional feature which stores the physical to
logical eraseblock relations in a checkpoint (called fastmap) to reduce
the initialization time of UBI. The current init time of UBI is
proportional to the number of physical erase blocks on the FLASH
device. With fastmap enabled the scan time is limited to a fixed
number of blocks.

Fastmap does not affect any of the existing UBI robustness
features and in fact the fastmap code falls back to scanning
mode when the found fastmap is corrupted.

A fastmap consists of two elements:

1) A primary super block, which contains merrily a pointer to the
   erase block(s) which hold the real fastmap data.

   This super block is guaranteed to be held within the first 64
   eraseblocks of a device.

2) The secondary fastmap blocks, which contain the real
   fastmap data (physical to logical eraseblock relations,
   erase counts, sequence numbers ...)

   Aside of that the fastmap data contains a list of blocks
   which belong to the active working pool. The active working pool is
   a fixed number of blocks to be used by the WL sub-system itself and the
   layer on top of UBI, which can be modified before the next fastmap
   is written to FLASH. These blocks need to be scanned in the
   conventional UBI scan mode.

   The reason for these pool blocks is to reduce the fastmap
   updates to the necessary minimum to avoid accelerated device
   wearout in scenarios where data changes rapidly. The fastmap
   data is updated whenever a working pool runs out of blocks.

So the fastmap scan consists of the following steps:

   1) Find the fastmap super block block by scanning the start of the
      device.

   2) Read the real fastmap data and construct the UBI device info
      structures.

   3) Scan the pool blocks.

The fastmap functionality is fully compatible with existing UBI
deployments. If no fastmap blocks can be found then the device is
scanned and the fastmap blocks are created from the scanned
information.

Changes sinze v18:
   - Aiaiai uncovered some issues, now the patch set is fully bisectable,
     all compiler warnings have been fixed (set but unused variable),
     coccinelle found a missing check for kmalloc()'s return value.
     
     "drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]"
     is a false positive.

Changes since v17:

   - UBI reserves now PEBs to hold two fastmaps. It is guaranteed that
     each LEB has a corresponding PEB which can be used by an user.

   - Fastmap is automatically disabled if the FLASH devices has less than 64 PEBs

   - Fastmap is only available if CONFIG_MTD_UBI_FASTMAP is enabled.
     It is per default N. If fastmap has proven stable over some time we can
     remove CONFIG_MTD_UBI_FASTMAP and the corresponding #ifdefs.
     Even with CONFIG_MTD_UBI_FASTMAP=Y UBI will not automatically
     install a fastmap on existing images.
     This behavior is controlled by the fm_autoconvert UBI module parameter.
     Only if set to 1 UBI will install a fastmap automatically.
     By default it will use the fastmap only if one is found.

     So, if you want to test fastmap enable CONFIG_MTD_UBI_FASTMAP and
     set  fm_autoconvert to 1.
     If the device was attached by a fastmap you'll observe the following log
     message while attaching: "UBI: attached by fastmap".

State of fastmap:

We (linutronix gmbh) did numerous tests and are not aware of any issue or
regression so far. The tests have been done on real hardware and simulators
(nandsim and mtdram). Of course with and without bitflip emulation enabled
and on NAND "bad" devices with bad blocks, bitflips, IO erros, ...
The tests consisted of mtd-util's ubi-tests, my fastmap torture script[1]
and real world use cases.

Each test run was done with the following configurations:
- CONFIG_MTD_UBI_FASTMAP=n
To verify that traditional UBI works fine.

- CONFIG_MTD_UBI_FASTMAP=y, fm_autoconvert=0
In this configuration the fastmap pool mechanism is active but
no fastmap is written to non-fastmap devices.

- CONFIG_MTD_UBI_FASTMAP=y, fm_autoconvert=1
Fastmap is enabled and non-fastmap devices get fastmap enabled.
Either at detach time or while writing.

I hope the MTD community do will also test fastmap in many different situations.
Bug reports are welcome!

Future work:

- Currently fastmap's powercut policy is that it will fall back to scanning mode if
  a power cut happened while writing the fastmap. If users really need fast attaching
  also after a power cut we could use the adjacent blocks mechanism for writing fastmap.
- Add fastmap support to ubinize
- If fastmap has proven stable, we can remove CONFIG_MTD_UBI_FASTMAP
  and enable it per default.

This patch set is based on artems ubi repository:
git://git.infradead.org/linux-ubi.git

Thanks to the folks at CELF who sponsored this work!

Thanks,
//richard

[1]
http://lists.infradead.org/pipermail/linux-mtd/2012-June/042347.html

 MAINTAINERS                 |    6 +
 drivers/mtd/ubi/Kconfig     |   20 ++
 drivers/mtd/ubi/Makefile    |    1 +
 drivers/mtd/ubi/attach.c    |  386 +++++++++++++++++++---------
 drivers/mtd/ubi/build.c     |   70 +++++-
 drivers/mtd/ubi/eba.c       |  126 +++++++++-
 drivers/mtd/ubi/ubi-media.h |  137 ++++++++++
 drivers/mtd/ubi/ubi.h       |  118 +++++++++-
 drivers/mtd/ubi/wl.c        |  599 ++++++++++++++++++++++++++++++++++++++-----
 9 files changed, 1252 insertions(+), 211 deletions(-)

[PATCH 01/10] UBI: Add fastmap on-flash data structures
[PATCH 02/10] UBI: Add fastmap stuff to ubi.h
[PATCH 03/10] UBI: Export next_sqnum()
[PATCH 04/10] UBI: Add self_check_eba()
[PATCH 05/10] UBI: Add fastmap bits to build.c
[PATCH 06/10] UBI: Wire-up ->fm_sem
[PATCH 07/10] UBI: Add fastmap stuff to attach.c
[PATCH 08/10] UBI: Add fastmap support to the WL sub-system
[PATCH 09/10] UBI: Add fastmap core
[PATCH 10/10] UBI: Wire-up fastmap
