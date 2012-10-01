Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2JAXer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:34:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35128 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634Ab2JAXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:19 -0400
Message-Id: <20121001225201.586140633@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 094/180] eCryptfs: Properly check for O_RDONLY flag before doing privileged open
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 9fe79d7600497ed8a95c3981cbe5b73ab98222f0 upstream.

If the first attempt at opening the lower file read/write fails,
eCryptfs will retry using a privileged kthread. However, the privileged
retry should not happen if the lower file's inode is read-only because a
read/write open will still be unsuccessful.

The check for determining if the open should be retried was intended to
be based on the access mode of the lower file's open flags being
O_RDONLY, but the check was incorrectly performed. This would cause the
open to be retried by the privileged kthread, resulting in a second
failed open of the lower file. This patch corrects the check to
determine if the open request should be handled by the privileged
kthread.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ecryptfs/kthread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index e14cf7e..5ffc900 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -148,7 +148,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
-	if (flags & O_RDONLY) {
+	if ((flags & O_ACCMODE) == O_RDONLY) {
 		rc = PTR_ERR((*lower_file));
 		goto out;
 	}
-- 
1.7.2.1.45.g54fbc



