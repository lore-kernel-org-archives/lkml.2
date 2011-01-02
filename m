Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1ABHZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:36923 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1ABHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 190/260] De-pessimize rds_page_copy_user
Date: Sun,  2 Jan 2011 02:18:06 -0500
Message-Id: <1293952756-15010-191-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:38.0776 (UTC) FILETIME=[F9A56180:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 799c10559d60f159ab2232203f222f18fa3c4a5f upstream.

Don't try to "optimize" rds_page_copy_user() by using kmap_atomic() and
the unsafe atomic user mode accessor functions.  It's actually slower
than the straightforward code on any reasonable modern CPU.

Back when the code was written (although probably not by the time it was
actually merged, though), 32-bit x86 may have been the dominant
architecture.  And there kmap_atomic() can be a lot faster than kmap()
(unless you have very good locality, in which case the virtual address
caching by kmap() can overcome all the downsides).

But these days, x86-64 may not be more populous, but it's getting there
(and if you care about performance, it's definitely already there -
you'd have upgraded your CPU's already in the last few years).  And on
x86-64, the non-kmap_atomic() version is faster, simply because the code
is simpler and doesn't have the "re-try page fault" case.

People with old hardware are not likely to care about RDS anyway, and
the optimization for the 32-bit case is simply buggy, since it doesn't
verify the user addresses properly.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rds/page.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/net/rds/page.c b/net/rds/page.c
index 595a952..1dfbfea 100644
--- a/net/rds/page.c
+++ b/net/rds/page.c
@@ -57,30 +57,17 @@ int rds_page_copy_user(struct page *page, unsigned long offset,
 	unsigned long ret;
 	void *addr;
 
-	if (to_user)
+	addr = kmap(page);
+	if (to_user) {
 		rds_stats_add(s_copy_to_user, bytes);
-	else
+		ret = copy_to_user(ptr, addr + offset, bytes);
+	} else {
 		rds_stats_add(s_copy_from_user, bytes);
-
-	addr = kmap_atomic(page, KM_USER0);
-	if (to_user)
-		ret = __copy_to_user_inatomic(ptr, addr + offset, bytes);
-	else
-		ret = __copy_from_user_inatomic(addr + offset, ptr, bytes);
-	kunmap_atomic(addr, KM_USER0);
-
-	if (ret) {
-		addr = kmap(page);
-		if (to_user)
-			ret = copy_to_user(ptr, addr + offset, bytes);
-		else
-			ret = copy_from_user(addr + offset, ptr, bytes);
-		kunmap(page);
-		if (ret)
-			return -EFAULT;
+		ret = copy_from_user(addr + offset, ptr, bytes);
 	}
+	kunmap(page);
 
-	return 0;
+	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(rds_page_copy_user);
 
-- 
1.7.3.3

