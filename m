Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349Ab1EAUNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:13:23 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63302 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1EAUNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:13:22 -0400
Date: Sun, 1 May 2011 22:13:06 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] timer: apply_slack: fix algorithm to always get best result
Message-ID: <20110501201306.GA17568@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of apply_slack() will select the most
aligned value for "expires" only if the original value was not aligned.
However, if the initial value is already aligned, the current
algorithm will select the increased value. For example, betweem 1024
and 1025, 1025 is selected.  Using "expires - 1" in the xor fixes the
behaviour.  The short-circuit return is not really needed, as
the following math will return the original value in any case.

Explanation:

If the original "expires" value is aligned in some way (i.e., it ends
with at least one 0 bit), then "expires-1" has the "aligned" bits set;
thus they are good bits to be zeroed in the result, and the
algorithm will do that because the xor will preserve the most significant
bit that is already 0 on "expires" and is not 0 in "expires_limit".

If "expires" is not aligned "expires-1" has less bits and will contribute
at most bit number 0 to the xor. But bit 0 has no effect on the result:
if it is the only bit, the resulting mask "(1 << bit) - 1" is 0; if there
are other bits in the xor (i.e., expires_limit is not equal to expires),
using "expires - 1" in the xor has the same effect as using "expires"
and the most aligned value in the range will be chosen.

With 1023 and 1025 (or any greater value), both versions return 1024,
but with 1024 and 1025 this patch returns 1024, whereas original code
returned 1025 -- in general it returned the most aligned between
"expires+1" and "expires_limit", never returning "expires" itself,
irrespective of its good alignment.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
---

 kernel/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..b48ddbe 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -760,9 +760,9 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 		if (time_after(expires, now))
 			expires_limit = expires + (expires - now)/256;
 	}
-	mask = expires ^ expires_limit;
-	if (mask == 0)
+	if (expires_limit == expires)
 		return expires;
+	mask = (expires - 1) ^ expires_limit;
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-- 
1.5.6.5
