Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1ABHWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:35001 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1ABHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Gary King <gking@nvidia.com>,
        Tejun Heo <tj@kernel.org>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 069/260] bounce: call flush_dcache_page() after bounce_copy_vec()
Date: Sun,  2 Jan 2011 02:16:05 -0500
Message-Id: <1293952756-15010-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:22.0398 (UTC) FILETIME=[A85BBFE0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary King <gking@nvidia.com>

commit ac8456d6f9a3011c824176bd6084d39e5f70a382 upstream.

I have been seeing problems on Tegra 2 (ARMv7 SMP) systems with HIGHMEM
enabled on 2.6.35 (plus some patches targetted at 2.6.36 to perform cache
maintenance lazily), and the root cause appears to be that the mm bouncing
code is calling flush_dcache_page before it copies the bounce buffer into
the bio.

The bounced page needs to be flushed after data is copied into it, to
ensure that architecture implementations can synchronize instruction and
data caches if necessary.

Signed-off-by: Gary King <gking@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/bounce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 13b6dad..1481de6 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -116,8 +116,8 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 		 */
 		vfrom = page_address(fromvec->bv_page) + tovec->bv_offset;
 
-		flush_dcache_page(tovec->bv_page);
 		bounce_copy_vec(tovec, vfrom);
+		flush_dcache_page(tovec->bv_page);
 	}
 }
 
-- 
1.7.3.3

