Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383Ab1IOXQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:16:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52293 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab1IOXQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:16:51 -0400
Date: Thu, 15 Sep 2011 16:16:45 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext4: Prevent stack overrun in ext4_file_open when
	recording last known mountpoint
Message-ID: <20110915231645.GE12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ext4_file_open, the filesystem records the mountpoint of the first file that
is opened after mounting the filesystem.  It does this by allocating a 64-byte
stack buffer, calling d_path() to grab the mount point through which this file
was accessed, and then memcpy()ing 64 bytes into the superblock's
s_last_mounted field, starting from the return value of d_path(), which is
stored as "cp".  However, if cp > buf (which it frequently is since path
components are prepended starting at the end of buf) then we can end up copying
stack data into the superblock.

Writing stack variables into the superblock doesn't sound like a great idea, so
use strncpy instead.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..67223e0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -181,8 +181,8 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		path.dentry = mnt->mnt_root;
 		cp = d_path(&path, buf, sizeof(buf));
 		if (!IS_ERR(cp)) {
-			memcpy(sbi->s_es->s_last_mounted, cp,
-			       sizeof(sbi->s_es->s_last_mounted));
+			strncpy(sbi->s_es->s_last_mounted, cp,
+				sizeof(sbi->s_es->s_last_mounted));
 			ext4_mark_super_dirty(sb);
 		}
 	}
