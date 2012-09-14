Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2INQWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:22:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60552 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2INQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:22:07 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST] iommu/tegra: smmu: Use debugfs_create_dir for directory
Date: Fri, 14 Sep 2012 10:22:00 -0600
Message-Id: <1347639720-2991-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Doyu <hdoyu@nvidia.com>

The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
used only for regulars" doesn't allow to use debugfs_create_file() for
dir. Keep debugfs data in smmu_device instead of directory's i_private.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |   52 +++++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 5e51fb7..c749f96 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -246,6 +246,12 @@ struct smmu_as {
 	spinlock_t		client_lock; /* for client list */
 };
 
+struct smmu_debugfs_info {
+	struct smmu_device *smmu;
+	int mc;
+	int cache;
+};
+
 /*
  * Per SMMU device - IOMMU device
  */
@@ -267,6 +273,7 @@ struct smmu_device {
 	unsigned long asid_security;
 
 	struct dentry *debugfs_root;
+	struct smmu_debugfs_info *debugfs_info;
 
 	struct device_node *ahb;
 
@@ -920,9 +927,10 @@ static ssize_t smmu_debugfs_stats_write(struct file *file,
 					const char __user *buffer,
 					size_t count, loff_t *pos)
 {
+	struct smmu_debugfs_info *info;
 	struct smmu_device *smmu;
 	struct dentry *dent;
-	int i, cache, mc;
+	int i;
 	enum {
 		_OFF = 0,
 		_ON,
@@ -950,11 +958,10 @@ static ssize_t smmu_debugfs_stats_write(struct file *file,
 		return -EINVAL;
 
 	dent = file->f_dentry;
-	cache = (int)dent->d_inode->i_private;
-	mc = (int)dent->d_parent->d_inode->i_private;
-	smmu = dent->d_parent->d_parent->d_inode->i_private;
+	info = dent->d_inode->i_private;
+	smmu = info->smmu;
 
-	offs = SMMU_CACHE_CONFIG(cache);
+	offs = SMMU_CACHE_CONFIG(info->cache);
 	val = smmu_read(smmu, offs);
 	switch (i) {
 	case _OFF:
@@ -986,21 +993,21 @@ static ssize_t smmu_debugfs_stats_write(struct file *file,
 
 static int smmu_debugfs_stats_show(struct seq_file *s, void *v)
 {
+	struct smmu_debugfs_info *info;
 	struct smmu_device *smmu;
 	struct dentry *dent;
-	int i, cache, mc;
+	int i;
 	const char * const stats[] = { "hit", "miss", };
 
 	dent = d_find_alias(s->private);
-	cache = (int)dent->d_inode->i_private;
-	mc = (int)dent->d_parent->d_inode->i_private;
-	smmu = dent->d_parent->d_parent->d_inode->i_private;
+	info = dent->d_inode->i_private;
+	smmu = info->smmu;
 
 	for (i = 0; i < ARRAY_SIZE(stats); i++) {
 		u32 val;
 		size_t offs;
 
-		offs = SMMU_STATS_CACHE_COUNT(mc, cache, i);
+		offs = SMMU_STATS_CACHE_COUNT(info->mc, info->cache, i);
 		val = smmu_read(smmu, offs);
 		seq_printf(s, "%s:%08x ", stats[i], val);
 
@@ -1028,16 +1035,22 @@ static const struct file_operations smmu_debugfs_stats_fops = {
 static void smmu_debugfs_delete(struct smmu_device *smmu)
 {
 	debugfs_remove_recursive(smmu->debugfs_root);
+	kfree(smmu->debugfs_info);
 }
 
 static void smmu_debugfs_create(struct smmu_device *smmu)
 {
 	int i;
+	size_t bytes;
 	struct dentry *root;
 
-	root = debugfs_create_file(dev_name(smmu->dev),
-				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				   NULL, smmu, NULL);
+	bytes = ARRAY_SIZE(smmu_debugfs_mc) * ARRAY_SIZE(smmu_debugfs_cache) *
+		sizeof(*smmu->debugfs_info);
+	smmu->debugfs_info = kmalloc(bytes, GFP_KERNEL);
+	if (!smmu->debugfs_info)
+		return;
+
+	root = debugfs_create_dir(dev_name(smmu->dev), NULL);
 	if (!root)
 		goto err_out;
 	smmu->debugfs_root = root;
@@ -1046,18 +1059,23 @@ static void smmu_debugfs_create(struct smmu_device *smmu)
 		int j;
 		struct dentry *mc;
 
-		mc = debugfs_create_file(smmu_debugfs_mc[i],
-					 S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-					 root, (void *)i, NULL);
+		mc = debugfs_create_dir(smmu_debugfs_mc[i], root);
 		if (!mc)
 			goto err_out;
 
 		for (j = 0; j < ARRAY_SIZE(smmu_debugfs_cache); j++) {
 			struct dentry *cache;
+			struct smmu_debugfs_info *info;
+
+			info = smmu->debugfs_info;
+			info += i * ARRAY_SIZE(smmu_debugfs_mc) + j;
+			info->smmu = smmu;
+			info->mc = i;
+			info->cache = j;
 
 			cache = debugfs_create_file(smmu_debugfs_cache[j],
 						    S_IWUGO | S_IRUGO, mc,
-						    (void *)j,
+						    (void *)info,
 						    &smmu_debugfs_stats_fops);
 			if (!cache)
 				goto err_out;
-- 
1.7.0.4

