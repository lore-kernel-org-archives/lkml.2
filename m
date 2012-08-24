Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2HXHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:25:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:16952 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2HXHZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="213328871"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [RFC] [PATCH] vfs: remount all file-systems R/O on emergency remount.
Date: Fri, 24 Aug 2012 10:26:06 +0300
Message-Id: <1345793166-14230-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Currently the emergency remount (triggered by Sysrq-u) re-mounting only
those file-systems R/O, which have an associated block device (sb->s_bdev).
This does not work for file-systems like UBIFS and JFFS2 which work on top
of MTD devices (character devices) and always have sb->s_bdev = NULL.

This also does not work for tmpfs.

Most probably the intention was to avoid re-mounting R/O file-systems like
procfs, sysfs, cgroup, and debugfs. However, I do not really see why not
to remount them R/O as well in case of emergency.

This patch removes the 'sb->s_bdev != NULL' check from
'do_emergency_remount()', so _all_ file-systems will be re-mounted R/O.

Tested in Fedora - all file-systems (ext4, ubifs, procfs, sysfs, cgroup, and
debugfs) become R/O on Sysrq-u with this patch.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 0902cfa..95cf173 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -812,7 +812,7 @@ static void do_emergency_remount(struct work_struct *work)
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_write(&sb->s_umount);
-		if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
+		if (sb->s_root && (sb->s_flags & MS_BORN) &&
 		    !(sb->s_flags & MS_RDONLY)) {
 			/*
 			 * What lock protects sb->s_flags??
-- 
1.7.10.4

