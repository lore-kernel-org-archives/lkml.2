Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1LADBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:01:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LADBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:01:08 -0500
From: Haogang Chen <haogangchen@gmail.com>
To: konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        haogangchen@gmail.com
Subject: [PATCH] FS: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()
Date: Wed, 30 Nov 2011 21:59:59 -0500
Message-Id: <1322708399-26919-1-git-send-email-haogangchen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in nilfs_ioctl_clean_segments().
When a large argv[n].v_nmembs is passed from the userspace, the
subsequent call to vmalloc() will allocate a buffer smaller than
expected, which leads to out-of-bound access in
nilfs_ioctl_move_blocks() and lfs_clean_segments().

The following check does not prevent the overflow because nsegs is also
controlled by the userspace and could be very large.

		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
			goto out_free;

This patch clamps argv[n].v_nmembs to UINT_MAX / argv[n].v_size, and
returns -EINVAL when overflow.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 fs/nilfs2/ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 41d6743..b805df9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -625,6 +625,9 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
 			goto out_free;
 
+		if (argv[n].v_nmembs >= UINT_MAX / argv[n].v_size)
+			goto out_free;
+
 		len = argv[n].v_size * argv[n].v_nmembs;
 		base = (void __user *)(unsigned long)argv[n].v_base;
 		if (len == 0) {
-- 
1.7.5.4

