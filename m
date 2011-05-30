Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1E3Nwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:52:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32934 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1E3Nwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lwcN5s0R0CjJRpgXjugS5qr3o9bDZoYuFP4+nGEBg9MumZtqSP01nBke6RyCRiAlI2
         5WSG/sWOgLgf3glOJShvzKO4RHzeqQ73Lo6CbJe1ZZIQwUwgE2z4AzS3LAQJxy4072hZ
         BsMlfBDQlI3zXNWykTlU3boI16AGUVv/KI1gg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 3/3] reiserfs: use hweight_long
Date: Mon, 30 May 2011 22:53:15 +0900
Message-Id: <1306763595-13908-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306763595-13908-1-git-send-email-akinobu.mita@gmail.com>
References: <1306763595-13908-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hweight_long() to count free bits in the bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/bitmap.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index f9e26c1..69d7137 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1219,15 +1219,11 @@ void reiserfs_cache_bitmap_metadata(struct super_block *sb,
 	info->free_count = 0;
 
 	while (--cur >= (unsigned long *)bh->b_data) {
-		int i;
-
 		/* 0 and ~0 are special, we can optimize for them */
 		if (*cur == 0)
 			info->free_count += BITS_PER_LONG;
 		else if (*cur != ~0L)	/* A mix, investigate */
-			for (i = BITS_PER_LONG - 1; i >= 0; i--)
-				if (!test_bit_le(i, cur))
-					info->free_count++;
+			info->free_count += BITS_PER_LONG - hweight_long(*cur);
 	}
 }
 
-- 
1.7.4.4

