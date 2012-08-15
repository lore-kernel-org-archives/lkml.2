Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2HON6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:58:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37257 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2HON6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:58:48 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz,
        stable@vger.kernel.org
Subject: [PATCH 1/4] vfs: canonicalize create mode in build_open_flags()
Date: Wed, 15 Aug 2012 15:59:56 +0200
Message-Id: <1345039199-5904-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345039199-5904-1-git-send-email-miklos@szeredi.hu>
References: <1345039199-5904-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Userspace can pass weird create mode in open(2) that we canonicalize to
"(mode & S_IALLUGO) | S_IFREG" in vfs_create().

The problem is that we use the uncanonicalized mode before calling vfs_create()
with unforseen consequences.

So do the canonicalization early in build_open_flags().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
CC: stable@vger.kernel.org
---
 fs/open.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index bc132e1..e1f2cdb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -852,9 +852,10 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 	int lookup_flags = 0;
 	int acc_mode;
 
-	if (!(flags & O_CREAT))
-		mode = 0;
-	op->mode = mode;
+	if (flags & O_CREAT)
+		op->mode = (mode & S_IALLUGO) | S_IFREG;
+	else
+		op->mode = 0;
 
 	/* Must never be set by userspace */
 	flags &= ~FMODE_NONOTIFY;
-- 
1.7.7

