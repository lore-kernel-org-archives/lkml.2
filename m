Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0LPGK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:10:29 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:45082 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0LPGK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:10:26 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH v2] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Thu, 16 Dec 2010 07:10:18 +0100
Message-Id: <1292479818-5135-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101216055637.GA4826@mako-laptop>
References: <20101216055637.GA4826@mako-laptop>
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
 fs/btrfs/acl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..6d1410e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl))
+			if (IS_ERR(acl)) {
+				kfree(value);
 				return acl;
+			}
 			set_cached_acl(inode, type, acl);
 		}
 		kfree(value);
-- 
1.7.0.4

