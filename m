Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab2GWBmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab2GWBmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:43 -0400
Message-Id: <20120723010706.399261642@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 098/108] eCryptfs: Properly check for O_RDONLY flag before doing privileged
 open
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index 69f994a..0dbe58a 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -149,7 +149,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
-	if (flags & O_RDONLY) {
+	if ((flags & O_ACCMODE) == O_RDONLY) {
 		rc = PTR_ERR((*lower_file));
 		goto out;
 	}


