Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2EKIAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:00:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34413 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2EKIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:00:28 -0400
Date: Fri, 11 May 2012 01:00:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction to
 0
Message-ID: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is there less MemFree than there used to be?  It perturbed a test,
so I've just been bisecting linux-next, and now find the offender went
upstream yesterday.

Commit 93278814d359 "mm: fix division by 0 in percpu_pagelist_fraction()"
mistakenly initialized percpu_pagelist_fraction to the sysctl's minimum 8,
which leaves 1/8th of memory on percpu lists (on each cpu??); but most of
us expect it to be left unset at 0 (and it's not then used as a divisor).

MemTotal: 8061476kB  8061476kB  8061476kB  8061476kB  8061476kB  8061476kB
Repetitive test with percpu_pagelist_fraction 8:
MemFree:  6948420kB  6237172kB  6949696kB  6840692kB  6949048kB  6862984kB
Same test with percpu_pagelist_fraction back to 0:
MemFree:  7945000kB  7944908kB  7948568kB  7949060kB  7948796kB  7948812kB

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.4-rc6+/mm/page_alloc.c	2012-05-10 22:53:35.362478419 -0700
+++ linux/mm/page_alloc.c	2012-05-11 00:07:31.613657283 -0700
@@ -105,7 +105,7 @@ unsigned long totalreserve_pages __read_
  */
 unsigned long dirty_balance_reserve __read_mostly;
 
-int percpu_pagelist_fraction = 8;
+int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_PM_SLEEP
