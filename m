Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1BEOWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1BEOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TDAtcCOMe2Ys4xTstTD4sqP7rwCLxGSVMB2pf0YpMcb1ZAKBt8xAkBIk3duSdv5cFV
         cJwL88DdXoU9D49ikn/cXE7TzwAWiKRhGfwXvCKo5kNQYzul9kVNvUhfrYZY8dO1erD4
         8vATqjqyE9xnl9gcVJMSNznRwQ3qo+XeTT1u8=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 27/52] kstrtox: convert drivers/md/
Date: Sat,  5 Feb 2011 16:20:30 +0200
Message-Id: <1296915654-7458-27-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/md/bitmap.c  |   14 ++++----
 drivers/md/dm-raid.c |   31 ++++++++++-------
 drivers/md/md.c      |   86 +++++++++++++++++++++++++++++++++----------------
 drivers/md/md.h      |    2 +-
 drivers/md/raid5.c   |   16 ++++++---
 5 files changed, 94 insertions(+), 55 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9a35320..68c5152 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1885,10 +1885,8 @@ location_store(mddev_t *mddev, const char *buf, size_t len)
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
@@ -1943,7 +1941,7 @@ timeout_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	/* timeout can be set at any time */
 	unsigned long timeout;
-	int rv = strict_strtoul_scaled(buf, &timeout, 4);
+	int rv = kstrtoul_scaled(buf, &timeout, 4);
 	if (rv)
 		return rv;
 
@@ -1984,7 +1982,9 @@ static ssize_t
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
@@ -2010,7 +2010,7 @@ chunksize_store(mddev_t *mddev, const char *buf, size_t len)
 	unsigned long csize;
 	if (mddev->bitmap)
 		return -EBUSY;
-	rv = strict_strtoul(buf, 10, &csize);
+	rv = kstrtoul(buf, 10, &csize);
 	if (rv)
 		return rv;
 	if (csize < 512 ||
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b9e1e15..e889c24 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -254,12 +254,15 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 	unsigned i, rebuild_cnt = 0;
 	unsigned long value;
 	char *key;
+	int rv;
 
 	/*
 	 * First, parse the in-order required arguments
 	 */
-	if ((strict_strtoul(argv[0], 10, &value) < 0) ||
-	    !is_power_of_2(value) || (value < 8)) {
+	rv = kstrtoul(argv[0], 10, &value);
+	if (rv < 0)
+		return rv;
+	if (!is_power_of_2(value) || (value < 8)) {
 		rs->ti->error = "Bad chunk size";
 		return -EINVAL;
 	}
@@ -295,9 +298,10 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 		}
 
 		key = argv[i++];
-		if (strict_strtoul(argv[i], 10, &value) < 0) {
+		rv = kstrtoul(argv[i], 10, &value);
+		if (rv < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
-			return -EINVAL;
+			return rv;
 		}
 
 		if (!strcmp(key, "rebuild")) {
@@ -410,10 +414,10 @@ static void raid_unplug(struct dm_target_callbacks *cb)
  */
 static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
-	int ret;
 	struct raid_type *rt;
-	unsigned long num_raid_params, num_raid_devs;
+	unsigned int num_raid_params, num_raid_devs;
 	struct raid_set *rs = NULL;
+	int ret;
 
 	/* Must have at least <raid_type> <#raid_params> */
 	if (argc < 2) {
@@ -431,9 +435,10 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	argv++;
 
 	/* number of RAID parameters */
-	if (strict_strtoul(argv[0], 10, &num_raid_params) < 0) {
+	ret = kstrtouint(argv[0], 10, &num_raid_params);
+	if (ret < 0) {
 		ti->error = "Cannot understand number of RAID parameters";
-		return -EINVAL;
+		return ret;
 	}
 	argc--;
 	argv++;
@@ -444,17 +449,17 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		return -EINVAL;
 	}
 
-	if ((strict_strtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
-	    (num_raid_devs >= INT_MAX)) {
+	ret = kstrtouint(argv[num_raid_params], 10, &num_raid_devs);
+	if (ret < 0) {
 		ti->error = "Cannot understand number of raid devices";
-		return -EINVAL;
+		return ret;
 	}
 
-	rs = context_alloc(ti, rt, (unsigned)num_raid_devs);
+	rs = context_alloc(ti, rt, num_raid_devs);
 	if (IS_ERR(rs))
 		return PTR_ERR(rs);
 
-	ret = parse_raid_params(rs, argv, (unsigned)num_raid_params);
+	ret = parse_raid_params(rs, argv, num_raid_params);
 	if (ret)
 		goto bad;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b76cfc8..de8e62a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2552,13 +2552,15 @@ static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
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
@@ -2571,15 +2573,31 @@ static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
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
@@ -2657,12 +2675,17 @@ static ssize_t recovery_start_show(mdk_rdev_t *rdev, char *page)
 
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
@@ -2914,7 +2937,7 @@ static void analyze_sbs(mddev_t * mddev)
  * multiplying that number by 10^'scale'.
  * all without any floating-point arithmetic.
  */
-int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
+int kstrtoul_scaled(const char *cp, unsigned long *res, int scale)
 {
 	unsigned long result = 0;
 	long decimals = -1;
@@ -2958,7 +2981,7 @@ safe_delay_store(mddev_t *mddev, const char *cbuf, size_t len)
 {
 	unsigned long msec;
 
-	if (strict_strtoul_scaled(cbuf, &msec, 3) < 0)
+	if (kstrtoul_scaled(cbuf, &msec, 3) < 0)
 		return -EINVAL;
 	if (msec == 0)
 		mddev->safemode_delay = 0;
@@ -2995,7 +3018,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	char clevel[16];
 	ssize_t rv = len;
 	struct mdk_personality *pers;
-	long level;
+	int level;
 	void *priv;
 	mdk_rdev_t *rdev;
 
@@ -3032,11 +3055,8 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
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
@@ -3632,8 +3652,9 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
 	 * If array is active, we can try an on-line resize
 	 */
 	sector_t sectors;
-	int err = strict_blocks_to_sectors(buf, &sectors);
+	int err;
 
+	err = kstr_blocks_to_sector_t(buf, &sectors);
 	if (err < 0)
 		return err;
 	if (mddev->pers) {
@@ -3877,11 +3898,12 @@ sync_force_parallel_show(mddev_t *mddev, char *page)
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
 
@@ -3941,8 +3963,10 @@ min_sync_show(mddev_t *mddev, char *page)
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
@@ -3978,9 +4002,12 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
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
@@ -4124,8 +4151,11 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 
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
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index eec517c..9d145d4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -514,7 +514,7 @@ extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(mddev_t *mddev);
 extern int md_integrity_register(mddev_t *mddev);
 extern void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
-extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
+extern int kstrtoul_scaled(const char *cp, unsigned long *res, int scale);
 extern void restore_bitmap_write_access(struct file *file);
 extern void md_unplug(mddev_t *mddev);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5044bab..34de5d0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4614,7 +4614,7 @@ static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev->private;
-	unsigned long new;
+	unsigned int new;
 	int err;
 
 	if (len >= PAGE_SIZE)
@@ -4622,8 +4622,9 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
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
@@ -4649,14 +4650,17 @@ static ssize_t
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
1.7.3.4

