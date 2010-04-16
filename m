Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0DPK6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:58:24 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:36598 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219Ab0DPK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:58:23 -0400
Subject: [PATCH RFC]  buffer_head: remove redundant test from wait_on_buffer
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 11:58:19 +0100
Message-ID: <1271415499.2075.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment suggests that when b_count equals zero it is calling
__wait_no_buffer to trigger some debug, but as there is no debug in
__wait_on_buffer the whole thing is redundant.

AFAICT from the git log this has been the case for at least 5 years, so
it seems safe just to remove this.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

This patch against 2.6.34-rc4
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 16ed028..4c62dd4 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -305,15 +305,10 @@ map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
 	bh->b_size = sb->s_blocksize;
 }
 
-/*
- * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
- * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
- * functions is bloaty.
- */
 static inline void wait_on_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
+	if (buffer_locked(bh))
 		__wait_on_buffer(bh);
 }
 


