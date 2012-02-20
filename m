Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2BTV6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:58:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35719 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2BTV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:58:51 -0500
From: Haogang Chen <haogangchen@gmail.com>
To: konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        haogangchen@gmail.com
Subject: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Mon, 20 Feb 2012 16:55:30 -0500
Message-Id: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ns_r_segments_percentage is read from the disk. Bogus or malicious
value could cause integer overflow and potential security holes.
This patch reports error when mounting such bogus volumes.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 fs/nilfs2/the_nilfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d327140..e12b47b 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
 	nilfs->ns_r_segments_percentage =
 		le32_to_cpu(sbp->s_r_segments_percentage);
+	if (nilfs->ns_r_segments_percentage < 1 ||
+		nilfs->ns_r_segments_percentage > 99) {
+		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		return -EINVAL;
+	}
+
 	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
-- 
1.7.5.4

