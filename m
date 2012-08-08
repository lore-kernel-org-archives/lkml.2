Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab2HHUIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:08:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:48270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2HHUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:08:22 -0400
Subject: Re: [PATCH] sched: fix divide by zero at {thread_group,task}_times
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <1344455404.2440.35.camel@marge.simpson.net>
References: <20120808092714.GA3580@redhat.com>
	 <1344455404.2440.35.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 22:08:20 +0200
Message-ID: <1344456500.16728.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 21:50 +0200, Mike Galbraith wrote:
> 32bit built do_div()
> and div64_u64() both sucked equally compared to 64bit 

/me peeks at div64_u64 fallback implementation and sees why, it still
does a single div, it does some neat fls tricks.

Ok, no point in avoiding this then.. 

I did the below little edit, no point in mixing the old and new
primitives.. those __force things annoy me, but I guess otherwise we'll
upset sparse.

---
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -3149,7 +3149,7 @@ static cputime_t scale_utime(cputime_t u
 	temp *= (__force u64) utime;
 
 	if (sizeof(cputime_t) == 4)
-		do_div(temp, (__force u32) total);
+		temp = div_u64(temp, (__force u32) total);
 	else
 		temp = div64_u64(temp, (__force u64) total);
 


