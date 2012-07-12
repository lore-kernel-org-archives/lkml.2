Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162101Ab2GLWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:43:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162124Ab2GLWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 138/187] eCryptfs: Properly check for O_RDONLY flag before doing privileged open
Date: Thu, 12 Jul 2012 15:34:54 -0700
Message-Id: <20120712191535.183178157@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/ecryptfs/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -149,7 +149,7 @@ int ecryptfs_privileged_open(struct file
 	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
-	if (flags & O_RDONLY) {
+	if ((flags & O_ACCMODE) == O_RDONLY) {
 		rc = PTR_ERR((*lower_file));
 		goto out;
 	}


