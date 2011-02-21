Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1BUVeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:34:36 -0500
Received: from mail-ew0-f42.google.com ([209.85.215.42]:59743 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1BUVee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:34:34 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 16:34:34 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=jUBPGvpb5jL8fE2ZoaaQ5Mt8x06MlOgfL6hmFCke8odFMEJ9jznZAJEftAa/kPBMFz
         JyCXQMZqwcs5MJH7Q11TTzh8f2bvh6/dCYEMzsy18El1vwX8D6gLB+KvW4JE4KdX7+7A
         IWPf5i4buOaTRTP7Crn8sddK2xCsMFdX+LprQ=
Subject: [PATCH v2] NFS: account direct-io into task io accounting
To: linux-nfs@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 22 Feb 2011 00:28:34 +0300
Message-ID: <20110221212834.2442.65228.stgit@localhost6>
In-Reply-To: <20110221191546.5920.96947.stgit@localhost6>
References: <20110221191546.5920.96947.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account NFS direct-io reads and writes into Task I/O Accounting.
Do it before complition to handle aio.

NFS have unusual direct-io implementation,
thus accounting in generic code does not work.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/nfs/direct.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 9943a75..bd2cb5d 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -45,6 +45,7 @@
 #include <linux/pagemap.h>
 #include <linux/kref.h>
 #include <linux/slab.h>
+#include <linux/task_io_accounting_ops.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
@@ -938,6 +939,8 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		goto out;
 
+	task_io_account_read(count);
+
 	retval = nfs_direct_read(iocb, iov, nr_segs, pos);
 	if (retval > 0)
 		iocb->ki_pos = pos + retval;
@@ -999,6 +1002,8 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		goto out;
 
+	task_io_account_write(count);
+
 	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);
 
 	if (retval > 0)

