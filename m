Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1GLH60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:58:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GLH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:58:24 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] bootmem: Fix __free_pages_bootmem() to use @order properly
Date: Tue, 12 Jul 2011 09:58:06 +0200
Message-Id: <1310457490-3356-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310457490-3356-1-git-send-email-tj@kernel.org>
References: <1310457490-3356-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a226f6c899 (FRV: Clean up bootmem allocator's page freeing algorithm)
separated out __free_pages_bootmem() from free_all_bootmem_core().
__free_pages_bootmem() takes @order argument but it assumes @order is
either 0 or ilog2(BITS_PER_LONG).  Note that all the current users
match that assumption and this doesn't cause actual problems.

Fix it by using 1 << order instead of BITS_PER_LONG.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9119faa..b6da6ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -705,10 +705,10 @@ void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
 		int loop;
 
 		prefetchw(page);
-		for (loop = 0; loop < BITS_PER_LONG; loop++) {
+		for (loop = 0; loop < (1 << order); loop++) {
 			struct page *p = &page[loop];
 
-			if (loop + 1 < BITS_PER_LONG)
+			if (loop + 1 < (1 << order))
 				prefetchw(p + 1);
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
-- 
1.7.6

