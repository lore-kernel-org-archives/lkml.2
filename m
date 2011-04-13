Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1DMXp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:45:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60309 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab1DMXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:45:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/cacheflush.h: flush icache when copying to user pages
Date: Wed, 13 Apr 2011 19:45:28 -0400
Message-Id: <1302738328-22693-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
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
1.7.5.rc1

