Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab0HEHT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:19:57 -0400
Received: from www84.your-server.de ([213.133.104.84]:49571 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811Ab0HEHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:19:54 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>
Cc: stefani@seibold.net
Subject: [PATCH] Change struct flchip_shared spinlock locking into mutex
Date: Thu,  5 Aug 2010 09:19:26 +0200
Message-Id: <1280992766-13745-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.2
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch prevent to schedule while atomic by changing the
flchip_shared spinlock into a mutex. This should be save since no atomic
path will use this lock.

This patch is based on linux kernel 2.6.35. Please apply.

It was suggested by Arnd Bergmann and Vasiliy Kulikov.

Change since last release:

- fix lpddr_cmds.c
- tested with make allyesconfig

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   20 ++++++++++----------
 drivers/mtd/lpddr/lpddr_cmds.c      |   20 ++++++++++----------
 include/linux/mtd/flashchip.h       |    2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 62f3ea9..3364061 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -717,7 +717,7 @@ static int cfi_intelext_partition_fixup(struct mtd_info *mtd,
 		chip = &newcfi->chips[0];
 		for (i = 0; i < cfi->numchips; i++) {
 			shared[i].writing = shared[i].erasing = NULL;
-			spin_lock_init(&shared[i].lock);
+			mutex_init(&shared[i].lock);
 			for (j = 0; j < numparts; j++) {
 				*chip = cfi->chips[i];
 				chip->start += j << partshift;
@@ -886,7 +886,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		 */
 		struct flchip_shared *shared = chip->priv;
 		struct flchip *contender;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		contender = shared->writing;
 		if (contender && contender != chip) {
 			/*
@@ -899,7 +899,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 			 * get_chip returns success we're clear to go ahead.
 			 */
 			ret = mutex_trylock(&contender->mutex);
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			if (!ret)
 				goto retry;
 			mutex_unlock(&chip->mutex);
@@ -914,7 +914,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 				mutex_unlock(&contender->mutex);
 				return ret;
 			}
-			spin_lock(&shared->lock);
+			mutex_lock(&shared->lock);
 
 			/* We should not own chip if it is already
 			 * in FL_SYNCING state. Put contender and retry. */
@@ -930,7 +930,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		 * on this chip. Sleep. */
 		if (mode == FL_ERASING && shared->erasing
 		    && shared->erasing->oldstate == FL_ERASING) {
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
@@ -944,7 +944,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		shared->writing = chip;
 		if (mode == FL_ERASING)
 			shared->erasing = chip;
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 	ret = chip_ready(map, chip, adr, mode);
 	if (ret == -EAGAIN)
@@ -959,7 +959,7 @@ static void put_chip(struct map_info *map, struct flchip *chip, unsigned long ad
 
 	if (chip->priv) {
 		struct flchip_shared *shared = chip->priv;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		if (shared->writing == chip && chip->oldstate == FL_READY) {
 			/* We own the ability to write, but we're done */
 			shared->writing = shared->erasing;
@@ -967,7 +967,7 @@ static void put_chip(struct map_info *map, struct flchip *chip, unsigned long ad
 				/* give back ownership to who we loaned it from */
 				struct flchip *loaner = shared->writing;
 				mutex_lock(&loaner->mutex);
-				spin_unlock(&shared->lock);
+				mutex_unlock(&shared->lock);
 				mutex_unlock(&chip->mutex);
 				put_chip(map, loaner, loaner->start);
 				mutex_lock(&chip->mutex);
@@ -985,11 +985,11 @@ static void put_chip(struct map_info *map, struct flchip *chip, unsigned long ad
 			 * Don't let the switch below mess things up since
 			 * we don't have ownership to resume anything.
 			 */
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			wake_up(&chip->wq);
 			return;
 		}
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 
 	switch(chip->oldstate) {
diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index fece5be..04fdfcc 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -98,7 +98,7 @@ struct mtd_info *lpddr_cmdset(struct map_info *map)
 	numchips = lpddr->numchips / lpddr->qinfo->HWPartsNum;
 	for (i = 0; i < numchips; i++) {
 		shared[i].writing = shared[i].erasing = NULL;
-		spin_lock_init(&shared[i].lock);
+		mutex_init(&shared[i].lock);
 		for (j = 0; j < lpddr->qinfo->HWPartsNum; j++) {
 			*chip = lpddr->chips[i];
 			chip->start += j << lpddr->chipshift;
@@ -217,7 +217,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, int mode)
 		 */
 		struct flchip_shared *shared = chip->priv;
 		struct flchip *contender;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		contender = shared->writing;
 		if (contender && contender != chip) {
 			/*
@@ -230,7 +230,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, int mode)
 			 * get_chip returns success we're clear to go ahead.
 			 */
 			ret = mutex_trylock(&contender->mutex);
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			if (!ret)
 				goto retry;
 			mutex_unlock(&chip->mutex);
@@ -245,7 +245,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, int mode)
 				mutex_unlock(&contender->mutex);
 				return ret;
 			}
-			spin_lock(&shared->lock);
+			mutex_lock(&shared->lock);
 
 			/* We should not own chip if it is already in FL_SYNCING
 			 * state. Put contender and retry. */
@@ -261,7 +261,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, int mode)
 		   Must sleep in such a case. */
 		if (mode == FL_ERASING && shared->erasing
 		    && shared->erasing->oldstate == FL_ERASING) {
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 			mutex_unlock(&chip->mutex);
@@ -275,7 +275,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, int mode)
 		shared->writing = chip;
 		if (mode == FL_ERASING)
 			shared->erasing = chip;
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 
 	ret = chip_ready(map, chip, mode);
@@ -348,7 +348,7 @@ static void put_chip(struct map_info *map, struct flchip *chip)
 {
 	if (chip->priv) {
 		struct flchip_shared *shared = chip->priv;
-		spin_lock(&shared->lock);
+		mutex_lock(&shared->lock);
 		if (shared->writing == chip && chip->oldstate == FL_READY) {
 			/* We own the ability to write, but we're done */
 			shared->writing = shared->erasing;
@@ -356,7 +356,7 @@ static void put_chip(struct map_info *map, struct flchip *chip)
 				/* give back the ownership */
 				struct flchip *loaner = shared->writing;
 				mutex_lock(&loaner->mutex);
-				spin_unlock(&shared->lock);
+				mutex_unlock(&shared->lock);
 				mutex_unlock(&chip->mutex);
 				put_chip(map, loaner);
 				mutex_lock(&chip->mutex);
@@ -374,11 +374,11 @@ static void put_chip(struct map_info *map, struct flchip *chip)
 			 * Don't let the switch below mess things up since
 			 * we don't have ownership to resume anything.
 			 */
-			spin_unlock(&shared->lock);
+			mutex_unlock(&shared->lock);
 			wake_up(&chip->wq);
 			return;
 		}
-		spin_unlock(&shared->lock);
+		mutex_unlock(&shared->lock);
 	}
 
 	switch (chip->oldstate) {
diff --git a/include/linux/mtd/flashchip.h b/include/linux/mtd/flashchip.h
index f43e9b4..23cc10f 100644
--- a/include/linux/mtd/flashchip.h
+++ b/include/linux/mtd/flashchip.h
@@ -92,7 +92,7 @@ struct flchip {
 /* This is used to handle contention on write/erase operations
    between partitions of the same physical chip. */
 struct flchip_shared {
-	spinlock_t lock;
+	struct mutex lock;
 	struct flchip *writing;
 	struct flchip *erasing;
 };
-- 
1.7.2

