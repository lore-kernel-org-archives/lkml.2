Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1LMQWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:22:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:57463 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab1LMQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:22:41 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/2] nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()
Date: Wed, 14 Dec 2011 01:13:49 +0900
Message-Id: <1323792829-17395-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323792829-17395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1323792829-17395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 14 Dec 2011 01:22:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haogang Chen <haogangchen@gmail.com>

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
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3e65427..ac258be 100644
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
1.7.7.4

