Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab2DZQfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:35:23 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:54316 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302Ab2DZQfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:35:21 -0400
From: Jim Meyering <jim@meyering.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: avoid buffer overrun in btrfs_printk
Date: Thu, 26 Apr 2012 18:35:12 +0200
Message-ID: <87vckmwiwv.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The buffer read-overrun would be triggered by a printk format
starting with <N>, where N is a single digit.  NUL-terminate
after strncpy.  Use memcpy, not strncpy, since we know the
string we're copying fits in the destination buffer and
contains no NUL byte.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/btrfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5ddf172..626f574 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -180,23 +180,24 @@ const char *logtypes[] = {
 void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
 	char lvl[4];
 	struct va_format vaf;
 	va_list args;
 	const char *type = logtypes[4];

 	va_start(args, fmt);

 	if (fmt[0] == '<' && isdigit(fmt[1]) && fmt[2] == '>') {
-		strncpy(lvl, fmt, 3);
+		memcpy(lvl, fmt, 3);
+		lvl[3] = '\0';
 		fmt += 3;
 		type = logtypes[fmt[1] - '0'];
 	} else
 		*lvl = '\0';

 	vaf.fmt = fmt;
 	vaf.va = &args;
 	printk("%sBTRFS %s (device %s): %pV", lvl, type, sb->s_id, &vaf);
 }

 /*
--
1.7.10.336.gc5e31
