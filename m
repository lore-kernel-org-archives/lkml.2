Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0IRTwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:52:42 -0400
Received: from kroah.org ([198.145.64.141]:51397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab0IRTBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:43 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.184922275@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gary King <gking@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: [051/123] bounce: call flush_dcache_page() after bounce_copy_vec()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=bounce-call-flush_dcache_page-after-bounce_copy_vec.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/bounce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -115,8 +115,8 @@ static void copy_to_high_bio_irq(struct
 		 */
 		vfrom = page_address(fromvec->bv_page) + tovec->bv_offset;
 
-		flush_dcache_page(tovec->bv_page);
 		bounce_copy_vec(tovec, vfrom);
+		flush_dcache_page(tovec->bv_page);
 	}
 }
 


