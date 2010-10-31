Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0JaP6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:58:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40149 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab0JaP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=EQ8goqDrfEBJ5DrF/5duhH5DbHh3QkzaQIFn4Vu+Cr5xpdUNLKEZUPdPKphscNiFi5
         Yb3zv3f8GtNfxgHO0YYOpytr1/q2ja2bQj0jOysOkSHMbw47f5FP7aVTsmGepQLjXeIN
         4stINbZ9rHQlzMc+QCyS5gPCOZls9X2r/oLAs=
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH] Regression: fix mounting NFS when NFSv3 support is not
	compiled
To: Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 31 Oct 2010 17:58:40 +0200
Message-ID: <20101031155840.21196.49014.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to mount NFS (root partition in my case) fails if CONFIG_NFS_V3
is not selected. nfs_validate_mount_data() returns EPROTONOSUPPORT,
because of this check:

#ifndef CONFIG_NFS_V3
	if (args->version == 3)
		goto out_v3_not_compiled;
#endif /* !CONFIG_NFS_V3 */

and args->version was always initialized to 3.

It was working in 2.6.36

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 fs/nfs/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0a42e8f..8737017 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2277,7 +2277,11 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	};
 	int error = -ENOMEM;
 
+#ifdef CONFIG_NFS_V3
 	data = nfs_alloc_parsed_mount_data(3);
+#else
+	data = nfs_alloc_parsed_mount_data(2);
+#endif
 	mntfh = nfs_alloc_fhandle();
 	if (data == NULL || mntfh == NULL)
 		goto out_free_fh;

