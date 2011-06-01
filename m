Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab1FAOjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:39:21 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48725 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab1FAOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dUkEzpHXeVTVxFcqe15sA4y607sF8EGs7C2d20NLOj0W8/Y54AD/fcw2Aea+ZL+24/
         1liXuMISXrszul3HwzrD5AMJt4CMSlnbm6imq3cvde1unM+ZNvjjZUe7/sTUe0Eb/AwE
         L4BD+ql+LbVU1e2+VM+ri92Gg8Y+XCwb/d6/Y=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH v2 2/2] reiserfs: use hweight_long()
Date: Wed,  1 Jun 2011 23:39:58 +0900
Message-Id: <1306939198-11356-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306939198-11356-1-git-send-email-akinobu.mita@gmail.com>
References: <1306939198-11356-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hweight_long() to count free bits in the bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: reiserfs-devel@vger.kernel.org
---
v2: rewritten to keep reiserfs_*_le_bit() macros

 fs/reiserfs/bitmap.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 567385a..d1aca1d 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1222,15 +1222,11 @@ void reiserfs_cache_bitmap_metadata(struct super_block *sb,
 	info->free_count = 0;
 
 	while (--cur >= (unsigned long *)bh->b_data) {
-		int i;
-
 		/* 0 and ~0 are special, we can optimize for them */
 		if (*cur == 0)
 			info->free_count += BITS_PER_LONG;
 		else if (*cur != ~0L)	/* A mix, investigate */
-			for (i = BITS_PER_LONG - 1; i >= 0; i--)
-				if (!reiserfs_test_le_bit(i, cur))
-					info->free_count++;
+			info->free_count += BITS_PER_LONG - hweight_long(*cur);
 	}
 }
 
-- 
1.7.4.4

