Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0LERv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab0LERvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FO1r+seb1691wlxSvAUtu6Kl0FlDY3Ukx0chZZQE3HDWR33k5Q1hSlPjkHbvlsktzR
         mDrb9maevlQOnPwfiyyj8DWflBNm5DPRCAdb5G3D/TtrXdOLiKAm9+wzUHQeduTEGXUf
         r4CoLXW3JvUdyGomqcQt+047EWsDmaP8KlxE8=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 28/45] kstrtox: convert drivers/md/
Date: Sun,  5 Dec 2010 19:49:25 +0200
Message-Id: <1291571382-2719-28-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/md/bitmap.c |   12 ++++----
 drivers/md/md.c     |   82 ++++++++++++++++++++++++++++++++++----------------
 drivers/md/raid5.c  |   16 ++++++----
 3 files changed, 72 insertions(+), 38 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5a1ffe3..99ad322 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1881,10 +1881,8 @@ location_store(mddev_t *mddev, const char *buf, size_t len)
 			return -EINVAL;
 		} else {
 			int rv;
-			if (buf[0] == '+')
-				rv = strict_strtoll(buf+1, 10, &offset);
-			else
-				rv = strict_strtoll(buf, 10, &offset);
+
+			rv = kstrtoll(buf, 10, &offset);
 			if (rv)
 				return rv;
 			if (offset == 0)
@@ -1980,7 +1978,9 @@ static ssize_t
 backlog_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	unsigned long backlog;
-	int rv = strict_strtoul(buf, 10, &backlog);
+	int rv;
+
+	rv = kstrtoul(buf, 10, &backlog);
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
@@ -2006,7 +2006,7 @@ chunksize_store(mddev_t *mddev, const char *buf, size_t len)
 	unsigned long csize;
 	if (mddev->bitmap)
 		return -EBUSY;
-	rv = strict_strtoul(buf, 10, &csize);
+	rv = kstrtoul(buf, 10, &csize);
 	if (rv)
 		return rv;
 	if (csize < 512 ||
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84c46a1..86dd989 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2549,13 +2549,15 @@ static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
 	return 1;
 }
 
-static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
+static int kstr_blocks_to_sector_t(const char *buf, sector_t *sectors)
 {
 	unsigned long long blocks;
 	sector_t new;
+	int rv;
 
-	if (strict_strtoull(buf, 10, &blocks) < 0)
-		return -EINVAL;
+	rv = kstrtoull(buf, 10, &blocks);
+	if (rv < 0)
+		return rv;
 
 	if (blocks & 1ULL << (8 * sizeof(blocks) - 1))
 		return -EINVAL; /* sector conversion overflow */
@@ -2568,15 +2570,31 @@ static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
 	return 0;
 }
 
+static int kstrto_sector_t(const char *buf, unsigned int base, sector_t *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(buf, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(sector_t)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+
 static ssize_t
 rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	mddev_t *my_mddev = rdev->mddev;
 	sector_t oldsectors = rdev->sectors;
 	sector_t sectors;
+	int rv;
 
-	if (strict_blocks_to_sectors(buf, &sectors) < 0)
-		return -EINVAL;
+	rv = kstr_blocks_to_sector_t(buf, &sectors);
+	if (rv < 0)
+		return rv;
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
 			sectors = super_types[my_mddev->major_version].
@@ -2654,12 +2672,17 @@ static ssize_t recovery_start_show(mdk_rdev_t *rdev, char *page)
 
 static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
-	unsigned long long recovery_start;
+	sector_t recovery_start;
 
 	if (cmd_match(buf, "none"))
 		recovery_start = MaxSector;
-	else if (strict_strtoull(buf, 10, &recovery_start))
-		return -EINVAL;
+	else {
+		int rv;
+
+		rv = kstrto_sector_t(buf, 10, &recovery_start);
+		if (rv < 0)
+			return rv;
+	}
 
 	if (rdev->mddev->pers &&
 	    rdev->raid_disk >= 0)
@@ -2992,7 +3015,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	char clevel[16];
 	ssize_t rv = len;
 	struct mdk_personality *pers;
-	long level;
+	int level;
 	void *priv;
 	mdk_rdev_t *rdev;
 
@@ -3029,11 +3052,8 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	/* Now find the new personality */
 	if (len == 0 || len >= sizeof(clevel))
 		return -EINVAL;
-	strncpy(clevel, buf, len);
-	if (clevel[len-1] == '\n')
-		len--;
-	clevel[len] = 0;
-	if (strict_strtol(clevel, 10, &level))
+	strlcpy(clevel, buf, sizeof(clevel));
+	if (kstrtoint(clevel, 10, &level))
 		level = LEVEL_NONE;
 
 	if (request_module("md-%s", clevel) != 0)
@@ -3629,8 +3649,9 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
 	 * If array is active, we can try an on-line resize
 	 */
 	sector_t sectors;
-	int err = strict_blocks_to_sectors(buf, &sectors);
+	int err;
 
+	err = kstr_blocks_to_sector_t(buf, &sectors);
 	if (err < 0)
 		return err;
 	if (mddev->pers) {
@@ -3874,11 +3895,12 @@ sync_force_parallel_show(mddev_t *mddev, char *page)
 static ssize_t
 sync_force_parallel_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	long n;
-
-	if (strict_strtol(buf, 10, &n))
-		return -EINVAL;
+	int n;
+	int rv;
 
+	rv = kstrtoint(buf, 10, &n);
+	if (rv < 0)
+		return rv;
 	if (n != 0 && n != 1)
 		return -EINVAL;
 
@@ -3938,8 +3960,10 @@ min_sync_show(mddev_t *mddev, char *page)
 static ssize_t
 min_sync_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	unsigned long long min;
-	if (strict_strtoull(buf, 10, &min))
+	sector_t min;
+	int rv;
+
+	rv = kstrto_sector_t(buf, 10, &min);
 		return -EINVAL;
 	if (min > mddev->resync_max)
 		return -EINVAL;
@@ -3975,9 +3999,12 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
 	else {
-		unsigned long long max;
-		if (strict_strtoull(buf, 10, &max))
-			return -EINVAL;
+		sector_t max;
+		int rv;
+
+		rv = kstrto_sector_t(buf, 10, &max);
+		if (rv < 0)
+			return rv;
 		if (max < mddev->resync_min)
 			return -EINVAL;
 		if (max < mddev->resync_max &&
@@ -4112,8 +4139,11 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 
 		mddev->external_size = 0;
 	} else {
-		if (strict_blocks_to_sectors(buf, &sectors) < 0)
-			return -EINVAL;
+		int rv;
+
+		rv = kstr_blocks_to_sector_t(buf, &sectors);
+		if (rv < 0)
+			return rv;
 		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
 			return -E2BIG;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc574f3..61d63fb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4615,7 +4615,7 @@ static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev->private;
-	unsigned long new;
+	unsigned int new;
 	int err;
 
 	if (len >= PAGE_SIZE)
@@ -4623,8 +4623,9 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 	if (!conf)
 		return -ENODEV;
 
-	if (strict_strtoul(page, 10, &new))
-		return -EINVAL;
+	err = kstrtouint(page, 10, &new);
+	if (err < 0)
+		return err;
 	err = raid5_set_cache_size(mddev, new);
 	if (err)
 		return err;
@@ -4650,14 +4651,17 @@ static ssize_t
 raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev->private;
-	unsigned long new;
+	unsigned int new;
+	int rv;
+
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	if (strict_strtoul(page, 10, &new))
-		return -EINVAL;
+	rv = kstrtouint(page, 10, &new);
+	if (rv < 0)
+		return rv;
 	if (new > conf->max_nr_stripes)
 		return -EINVAL;
 	conf->bypass_threshold = new;
-- 
1.7.2.2

