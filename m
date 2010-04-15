Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0DOXHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab0DOXHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:04 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 22/35] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Thu, 15 Apr 2010 16:04:29 -0700
Message-Id: <1271372682-21225-23-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-22-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
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
index b179062..900df0f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2670,6 +2670,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2759,6 +2763,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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

