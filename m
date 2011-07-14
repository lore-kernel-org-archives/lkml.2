Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1GNDiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:38:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:58700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab1GNDiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:38:14 -0400
Date: Thu, 14 Jul 2011 03:38:08 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-53348f27168534561c0c814843bbf181314374f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhowells@redhat.com, tj@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tj@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1310457490-3356-3-git-send-email-tj@kernel.org>
References: <1310457490-3356-3-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] bootmem: Fix __free_pages_bootmem() to use @order properly
Git-Commit-ID: 53348f27168534561c0c814843bbf181314374f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:38:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53348f27168534561c0c814843bbf181314374f4
Gitweb:     http://git.kernel.org/tip/53348f27168534561c0c814843bbf181314374f4
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:06 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:35:56 -0700

bootmem: Fix __free_pages_bootmem() to use @order properly

a226f6c899 (FRV: Clean up bootmem allocator's page freeing algorithm)
separated out __free_pages_bootmem() from free_all_bootmem_core().
__free_pages_bootmem() takes @order argument but it assumes @order is
either 0 or ilog2(BITS_PER_LONG).  Note that all the current users
match that assumption and this doesn't cause actual problems.

Fix it by using 1 << order instead of BITS_PER_LONG.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-3-git-send-email-tj@kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
