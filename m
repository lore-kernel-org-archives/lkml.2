Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab1FWSJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:09:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:34661 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab1FWRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Konstantin Khorenko <khorenko@parallels.com>,
        Konstantin Khorenko <khorenko@openvz.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 090/247] NFSD: memory corruption due to writing beyond the stat array
Date: Thu, 23 Jun 2011 13:32:38 -0400
Message-Id: <1308850515-15242-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khorenko <khorenko@parallels.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3aa6e0aa8ab3e64bbfba092c64d42fd1d006b124 upstream.

If nfsd fails to find an exported via NFS file in the readahead cache, it
should increment corresponding nfsdstats counter (ra_depth[10]), but due to a
bug it may instead write to ra_depth[11], corrupting the following field.

In a kernel with NFSDv4 compiled in the corruption takes the form of an
increment of a counter of the number of NFSv4 operation 0's received; since
there is no operation 0, this is harmless.

In a kernel with NFSDv4 disabled it corrupts whatever happens to be in the
memory beyond nfsdstats.

Signed-off-by: Konstantin Khorenko <khorenko@openvz.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/vfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4eb9baa..054b50b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -819,7 +819,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;
-- 
1.7.4.4

