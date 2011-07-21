Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab1GUOEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1GUOEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:04:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Fix __fscache_uncache_all_inode_pages()'s outer loop
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@kernel.org
Date: Thu, 21 Jul 2011 15:02:43 +0100
Message-ID: <20110721140243.21768.64949.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@novell.com>

The compiler, at least for ix86 and m68k, validly warns that the comparison:

	next <= (loff_t)-1

is always true (and it's always true also for x86-64 and probably all other
arches - as long as pgoff_t isn't wider than loff_t).  The intention appears
to be to avoid wrapping of "next", so rather than eliminating the pointless
comparison, fix the loop to indeed get exited when "next" would otherwise
wrap.

On m68k the following warning is observed:

fs/fscache/page.c: In function '__fscache_uncache_all_inode_pages':
fs/fscache/page.c:979: warning: comparison is always false due to
limited range of data type

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---

 fs/fscache/page.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 60315b3..ff1e68f 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -993,16 +993,12 @@ void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
 
 	pagevec_init(&pvec, 0);
 	next = 0;
-	while (next <= (loff_t)-1 &&
-	       pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)
-	       ) {
+	do {
+		if (!pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE))
+			break;
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			pgoff_t page_index = page->index;
-
-			ASSERTCMP(page_index, >=, next);
-			next = page_index + 1;
-
+			next = page->index;
 			if (PageFsCache(page)) {
 				__fscache_wait_on_page_write(cookie, page);
 				__fscache_uncache_page(cookie, page);
@@ -1010,7 +1006,7 @@ void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-	}
+	} while (++next);
 
 	_leave("");
 }

