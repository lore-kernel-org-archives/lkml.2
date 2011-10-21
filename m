Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1JUVS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:18:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57452 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1JUVSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:18:24 -0400
Subject: [PATCH 4/5] ext4: Prevent stack overrun in ext4_file_open when
	recording last known mountpoint
To: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@mit.edu>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 21 Oct 2011 14:18:18 -0700
Message-ID: <20111021211818.10784.77127.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102121-3352-0000-0000-0000004F6639
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
use strlcpy instead.  Andi Kleen suggested using strlcpy instead of strncpy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..9781099 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -181,8 +181,8 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		path.dentry = mnt->mnt_root;
 		cp = d_path(&path, buf, sizeof(buf));
 		if (!IS_ERR(cp)) {
-			memcpy(sbi->s_es->s_last_mounted, cp,
-			       sizeof(sbi->s_es->s_last_mounted));
+			strlcpy(sbi->s_es->s_last_mounted, cp,
+				sizeof(sbi->s_es->s_last_mounted));
 			ext4_mark_super_dirty(sb);
 		}
 	}

