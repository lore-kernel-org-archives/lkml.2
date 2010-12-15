Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0LOV5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:57:53 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:38441 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0LOV5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:57:51 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Wed, 15 Dec 2010 22:57:36 +0100
Message-Id: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If posix_acl_from_xattr() fails we leak memory stored in 'value'.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 fs/btrfs/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..11c9561 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
 			if (IS_ERR(acl))
+				kfree(value);
 				return acl;
 			set_cached_acl(inode, type, acl);
 		}
-- 
1.7.0.4

