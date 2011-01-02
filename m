Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1ABIMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:12:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:34109 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1ABHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:37 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nikanth Karthikesan <knikanth@suse.de>,
        Amit Arora <aarora@in.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 017/260] ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Sun,  2 Jan 2011 02:15:13 -0500
Message-Id: <1293952756-15010-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:25.0116 (UTC) FILETIME=[863735C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <knikanth@suse.de>

commit 6d19c42b7cf81c39632b6d4dbc514e8449bcd346 upstream.

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for that.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/extents.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee611da..8a8f9f0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3708,6 +3708,11 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (len + offset));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
-- 
1.7.3.3

