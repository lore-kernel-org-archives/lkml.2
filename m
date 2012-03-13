Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2CMBAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:00:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:47639 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab2CMAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 064/196] UBIFS: fix oops when R/O file-system is fsync'ed
Date: Mon, 12 Mar 2012 20:19:37 -0400
Message-Id: <1331598109-31424-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 78530bf7f2559b317c04991b52217c1608d5a58d upstream.

This patch fixes severe UBIFS bug: UBIFS oopses when we 'fsync()' an
file on R/O-mounter file-system. We (the UBIFS authors) incorrectly
thought that VFS would not propagate 'fsync()' down to the file-system
if it is read-only, but this is not the case.

It is easy to exploit this bug using the following simple perl script:

use strict;
use File::Sync qw(fsync sync);

die "File path is not specified" if not defined $ARGV[0];
my $path = $ARGV[0];

open FILE, "<", "$path" or die "Cannot open $path: $!";
fsync(\*FILE) or die "cannot fsync $path: $!";
close FILE or die "Cannot close $path: $!";

Thanks to Reuben Dowle <Reuben.Dowle@navico.com> for reporting about this
issue.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reported-by: Reuben Dowle <Reuben.Dowle@navico.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5692cf7..1a411fd 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1312,6 +1312,9 @@ int ubifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	/*
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
-- 
1.7.9.3

