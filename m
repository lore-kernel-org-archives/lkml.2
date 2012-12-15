Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2LOPZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 10:25:34 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36967 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2LOPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 10:25:33 -0500
Message-ID: <50CC9663.4010200@gmail.com>
Date: Sat, 15 Dec 2012 23:25:23 +0800
From: ys <sickamd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: david@fromorbit.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger@dilger.ca
Subject: [PATCH] vfs: update atimes over one day in the past or future
Content-Type: multipart/mixed;
 boundary="------------030503060804010400080106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030503060804010400080106
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit



--------------030503060804010400080106
Content-Type: text/x-patch;
 name="0001-vfs-update-atimes-over-one-day-in-the-past-or-future.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-vfs-update-atimes-over-one-day-in-the-past-or-future.pa";
 filename*1="tch"

>From 3d56c131b58a21c05bcd677b9d2ba915abcbf195 Mon Sep 17 00:00:00 2001
From: yangsheng <sickamd@gmail.com>
Date: Sat, 15 Dec 2012 21:46:22 +0800
Subject: [PATCH] vfs: update atimes over one day in the past or future

Relatime should update the inode atime if it is more than one day
in the future.  The original problem seen was a tarball that had
a bad atime in the distant future, but could also happen if someone
fat-fingers a "touch".  The future atime will never be fixed.

Without relatime enabled, a future atime is updated to the current
kernel time on access.  Relatime is meant to reduce the frequency
of atime updates, not decide if whether the system clock or the
inode timestamp is correct or not.

Signed-off-by: Yang Sheng <sickamd@gmail.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Acked-by: David Chinner <david@fromorbit.com>
CC: stable@vger.kernel.org
---
 fs/inode.c | 7 ++++---
 1 个文件被修改，插入 4 行(+)，删除 3 行(-)

diff --git a/fs/inode.c b/fs/inode.c
index 14084b7..8713dc8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1488,10 +1488,11 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
-	 * Is the previous atime value older than a day? If yes,
-	 * update atime:
+	 * Update atime if it's older than a day or more than a day
+	 * in the future, which we assume is corrupt.
+	 * 	 	 
 	 */
-	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
+	if (abs(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
 		return 1;
 	/*
 	 * Good, we can skip the atime update:
-- 
1.7.11.7


--------------030503060804010400080106--
