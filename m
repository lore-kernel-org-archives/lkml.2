Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0ECXOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab0ECXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:13:48 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 23/39] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Mon,  3 May 2010 16:12:22 -0700
Message-Id: <1272928358-20854-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Call do_whiteout() when removing files and directories from a union
mounted file system.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a72187b..a02b118 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2680,6 +2680,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
+	if (IS_UNIONED_DIR(&nd.path)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit4;
+	}
 	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
@@ -2769,6 +2773,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
+		if (IS_UNIONED_DIR(&nd.path)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit3;
+		}
 		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
-- 
1.6.3.3

