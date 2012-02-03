Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2BCP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:28:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51305 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2BCP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:28:45 -0500
From: Xi Wang <xi.wang@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Haogang Chen <haogangchen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()
Date: Fri,  3 Feb 2012 10:26:07 -0500
Message-Id: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nsegs is read from userspace.  Limit its value and avoid overflowing
nsegs * sizeof(__u64) in the subsequent call to memdup_user().

This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/nilfs2/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 8866496..2a70fce 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -603,6 +603,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
 		goto out;
+	if (nsegs > UINT_MAX / sizeof(__u64))
+		goto out;
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
-- 
1.7.5.4

