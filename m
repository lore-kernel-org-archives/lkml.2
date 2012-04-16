Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2DPN2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:28:09 -0400
Received: from mail2.unitix.de ([176.9.2.175]:40450 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab2DPN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:28:08 -0400
From: Arnd Hannemann <arnd@arndnet.de>
To: dave@jikos.cz
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH v2] Btrfs: allow mount -o remount,compress=no
Date: Mon, 16 Apr 2012 15:27:51 +0200
Message-Id: <1334582871-3670-1-git-send-email-arnd@arndnet.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120406102232.GH14256@twin.jikos.cz>
References: <20120406102232.GH14256@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btrfs allows to turn on compression on a mounted and used filesystem
by issuing mount -o remount,compress=lzo.
This patch allows to turn compression off again
while the filesystem is mounted. As suggested by David Sterba
if the compress-force option was set, it is implicitly cleared
if compression is turned off.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 fs/btrfs/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..79a2ca5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -394,15 +394,22 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			    strcmp(args[0].from, "zlib") == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+			} else if (strncmp(args[0].from, "no", 2) == 0) {
+				compress_type = "no";
+				info->compress_type = BTRFS_COMPRESS_NONE;
+				btrfs_clear_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+				compress_force = false;
 			} else {
 				ret = -EINVAL;
 				goto out;
 			}
 
-			btrfs_set_opt(info->mount_opt, COMPRESS);
 			if (compress_force) {
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
 				pr_info("btrfs: force %s compression\n",
-- 
1.7.9.5

