Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab1EXBt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:49:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59816 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1EXBtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:49:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/cacheflush.h: flush icache when copying to user pages
Date: Mon, 23 May 2011 21:53:48 -0400
Message-Id: <1306202028-2615-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1302738328-22693-1-git-send-email-vapier@gentoo.org>
References: <1302738328-22693-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy_to_user_page() function is supposed to flush the icache on the
memory that was written, but the current asm-generic version lacks that
logic.  While normally it isn't a big deal as the asm-generic version of
icache flushing is a stub, it is a deal for ports that want to use the
asm-generic version as a baseline and then overlay its own specific parts
(like icache flushing).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: could you pick this up ?  i sent this a month ago and no-one noticed ...

 include/asm-generic/cacheflush.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
index 57b5c3c..87bc536 100644
--- a/include/asm-generic/cacheflush.h
+++ b/include/asm-generic/cacheflush.h
@@ -24,7 +24,10 @@
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+	do { \
+		memcpy(dst, src, len); \
+		flush_icache_user_range(vma, page, vaddr, len); \
+	} while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-- 
1.7.5.rc3

