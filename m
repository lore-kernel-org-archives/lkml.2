Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1DODAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:00:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab1DODAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:00:06 -0400
Message-ID: <4DA7B575.7090805@cn.fujitsu.com>
Date: Fri, 15 Apr 2011 11:03:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: fix FS_IOC_SETFLAGS ioctl
References: <4DA7B559.8060800@cn.fujitsu.com>
In-Reply-To: <4DA7B559.8060800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-15 11:00:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-15 11:00:42,
	Serialize complete at 2011-04-15 11:00:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce the bug:

  - Call FS_IOC_SETLFAGS ioctl with flags=FS_COMPR_FL
  - Call FS_IOC_SETFLAGS ioctl with flags=0
  - Call FS_IOC_GETFLAGS ioctl, and you'll see FS_COMPR_FL is still set!

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index aeabf6b..3e7031d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -238,6 +238,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	} else if (flags & FS_COMPR_FL) {
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	} else {
+		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
 	trans = btrfs_join_transaction(root, 1);
-- 
1.7.3.1
