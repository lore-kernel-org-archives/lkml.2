Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2JKRZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:25:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:51920 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab2JKRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="203356632"
Date: Fri, 12 Oct 2012 01:25:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] trivial writeback fixes
Message-ID: <20121011172515.GA18997@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull 3 trivial writeback fixes.

Thanks,
Fengguang
---

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-next

for you to fetch changes up to 2f60d628ffd042e65e0b1d3431fb3e38d6f7c1be:

  CPU hotplug, writeback: Don't call writeback_set_ratelimit() too often during hotplug (2012-09-28 20:27:49 +0800)

----------------------------------------------------------------
Namjae Jeon (1):
      backing-dev: use kstrto* in preference to simple_strtoul

Srivatsa S. Bhat (1):
      CPU hotplug, writeback: Don't call writeback_set_ratelimit() too often during hotplug

Wang Sheng-Hui (1):
      writeback: correct comment for move_expired_inodes()

 fs/fs-writeback.c   |    2 +-
 mm/backing-dev.c    |   50 ++++++++++++++++++++++++++------------------------
 mm/page-writeback.c |   14 +++++++++++---
 3 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be3efc4..fd255c0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -248,7 +248,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
 }
 
 /*
- * Move expired (dirtied after work->older_than_this) dirty inodes from
+ * Move expired (dirtied before work->older_than_this) dirty inodes from
  * @delaying_queue to @dispatch_queue.
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b41823c..d3ca2b3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -158,16 +158,16 @@ static ssize_t read_ahead_kb_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned long read_ahead_kb;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 
-	read_ahead_kb = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
-		ret = count;
-	}
-	return ret;
+	ret = kstrtoul(buf, 10, &read_ahead_kb);
+	if (ret < 0)
+		return ret;
+
+	bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
+
+	return count;
 }
 
 #define K(pages) ((pages) << (PAGE_SHIFT - 10))
@@ -187,16 +187,17 @@ static ssize_t min_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned int ratio;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &ratio);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_min_ratio(bdi, ratio);
+	if (!ret)
+		ret = count;
 
-	ratio = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		ret = bdi_set_min_ratio(bdi, ratio);
-		if (!ret)
-			ret = count;
-	}
 	return ret;
 }
 BDI_SHOW(min_ratio, bdi->min_ratio)
@@ -205,16 +206,17 @@ static ssize_t max_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned int ratio;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &ratio);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_max_ratio(bdi, ratio);
+	if (!ret)
+		ret = count;
 
-	ratio = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		ret = bdi_set_max_ratio(bdi, ratio);
-		if (!ret)
-			ret = count;
-	}
 	return ret;
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5ad5ce2..830893b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1602,10 +1602,18 @@ void writeback_set_ratelimit(void)
 }
 
 static int __cpuinit
-ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
+ratelimit_handler(struct notifier_block *self, unsigned long action,
+		  void *hcpu)
 {
-	writeback_set_ratelimit();
-	return NOTIFY_DONE;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		writeback_set_ratelimit();
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
 }
 
 static struct notifier_block __cpuinitdata ratelimit_nb = {
