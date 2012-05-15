Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563Ab2EOC3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:29:37 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53549 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489Ab2EOCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 163/179] mm: fix wrong vmap address calculations with odd NR_CPUS values
Date: Mon, 14 May 2012 22:14:19 -0400
Message-ID: <1337048075-6132-164-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f982f91516fa4cfd9d20518833cd04ad714585be upstream.

Commit db64fe02258f ("mm: rewrite vmap layer") introduced code that does
address calculations under the assumption that VMAP_BLOCK_SIZE is a
power of two.  However, this might not be true if CONFIG_NR_CPUS is not
set to a power of two.

Wrong vmap_block index/offset values could lead to memory corruption.
However, this has never been observed in practice (or never been
diagnosed correctly); what caught this was the BUG_ON in vb_alloc() that
checks for inconsistent vmap_block indices.

To fix this, ensure that VMAP_BLOCK_SIZE always is a power of two.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=31572
Reported-by: Pavel Kysilka <goldenfish@linuxsoft.cz>
Reported-by: Matias A. Fonzo <selk@dragora.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/vmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 20a402c..d44abdd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -671,9 +671,10 @@ static void free_unmap_vmap_area_addr(unsigned long addr)
 #define VMAP_BBMAP_BITS_MIN	(VMAP_MAX_ALLOC*2)
 #define VMAP_MIN(x, y)		((x) < (y) ? (x) : (y)) /* can't use min() */
 #define VMAP_MAX(x, y)		((x) > (y) ? (x) : (y)) /* can't use max() */
-#define VMAP_BBMAP_BITS		VMAP_MIN(VMAP_BBMAP_BITS_MAX,		\
-					VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
-						VMALLOC_PAGES / NR_CPUS / 16))
+#define VMAP_BBMAP_BITS		\
+		VMAP_MIN(VMAP_BBMAP_BITS_MAX,	\
+		VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
+			VMALLOC_PAGES / roundup_pow_of_two(NR_CPUS) / 16))
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 
-- 
1.7.9.6

