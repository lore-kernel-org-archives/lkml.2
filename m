Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1CBLfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:35:46 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:48503 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab1CBLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H0dTDJfMt1ml/P9Kvtt7Ylp9GXWDMzWyZExsVpQlfsIp8ZG5Wo3ckoB/kcE4EkfXj7
         yyGrlNt+HcEs+cTb5sYU5kasLcsbTm1retNsxxdN50fPscNOoKQYl2LkwIZMNIG/G+VH
         N1RrefDQgCuxM/nusY4w1MFzpbvebN+7TT0co=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] bfs: fix bitmap size argument to find_first_zero_bit()
Date: Wed,  2 Mar 2011 20:36:39 +0900
Message-Id: <1299065799-6289-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of find_first_zero_bit() in bfs_create() is wrong for
two reasons.

The bitmap size argument to find_first_zero_bit() is info->si_lasti
but the correct bitmap size is info->si_lasti + 1 as info->si_lasti
is the last valid index in info->si_imap bitmap.

Another problem is that it is impossible to detect that info->si_imap
bitmap is full because there is an off-by-one bug in the return value
check for find_first_zero_bit().  If no zero bits exist in info->si_imap,
find_first_zero_bit() returns info->si_lasti. But the check can't catch it
due to the off-by-one.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/bfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 685ecff..b14cebf 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -97,7 +97,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (!inode)
 		return -ENOSPC;
 	mutex_lock(&info->bfs_lock);
-	ino = find_first_zero_bit(info->si_imap, info->si_lasti);
+	ino = find_first_zero_bit(info->si_imap, info->si_lasti + 1);
 	if (ino > info->si_lasti) {
 		mutex_unlock(&info->bfs_lock);
 		iput(inode);
-- 
1.7.4

