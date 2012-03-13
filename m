Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab2CMAv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:51:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:48018 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab2CMAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 103/196] nfs: don't lose MS_SYNCHRONOUS on remount of noac mount
Date: Mon, 12 Mar 2012 20:20:16 -0400
Message-Id: <1331598109-31424-58-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 26c4c170731f00008f4317a2888a0a07ac99d90d upstream.

On a remount, the VFS layer will clear the MS_SYNCHRONOUS bit on the
assumption that the flags on the mount syscall will have it set if the
remounted fs is supposed to keep it.

In the case of "noac" though, MS_SYNCHRONOUS is implied. A remount of
such a mount will lose the MS_SYNCHRONOUS flag since "sync" isn't part
of the mount options.

Reported-by: Max Matveev <makc@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index ae570b0..85958a1 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1989,6 +1989,15 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	if (error < 0)
 		goto out;
 
+	/*
+	 * noac is a special case. It implies -o sync, but that's not
+	 * necessarily reflected in the mtab options. do_remount_sb
+	 * will clear MS_SYNCHRONOUS if -o sync wasn't specified in the
+	 * remount options, so we have to explicitly reset it.
+	 */
+	if (data->flags & NFS_MOUNT_NOAC)
+		*flags |= MS_SYNCHRONOUS;
+
 	/* compare new mount options with old ones */
 	error = nfs_compare_remount_data(nfss, data);
 out:
-- 
1.7.9.3

