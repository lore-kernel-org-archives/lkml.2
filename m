Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab2IEJVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:21:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48466 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430Ab2IEJV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:21:28 -0400
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] btrfs-progs: Fix up memory leakage
Date: Wed,  5 Sep 2012 17:21:07 +0800
Message-Id: <1346836867-1060-3-git-send-email-wuzhy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
References: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090509-1976-0000-0000-000010F19F9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Some code pathes forget to free memory on exit.

Changelog from v1:
  Fix the variable is used uncorrectly. [Ram Pai]

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 cmds-filesystem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e62c4fd..9c43d35 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -47,7 +47,7 @@ static const char * const cmd_df_usage[] = {
 
 static int cmd_df(int argc, char **argv)
 {
-	struct btrfs_ioctl_space_args *sargs;
+	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
 	u64 count = 0, i;
 	int ret;
 	int fd;
@@ -65,7 +65,7 @@ static int cmd_df(int argc, char **argv)
 		return 12;
 	}
 
-	sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
 	if (!sargs)
 		return -ENOMEM;
 
@@ -83,6 +83,7 @@ static int cmd_df(int argc, char **argv)
 	}
 	if (!sargs->total_spaces) {
 		close(fd);
+		free(sargs);
 		return 0;
 	}
 
@@ -92,6 +93,7 @@ static int cmd_df(int argc, char **argv)
 			(count * sizeof(struct btrfs_ioctl_space_info)));
 	if (!sargs) {
 		close(fd);
+		free(sargs_orig);
 		return -ENOMEM;
 	}
 
-- 
1.7.6.5

