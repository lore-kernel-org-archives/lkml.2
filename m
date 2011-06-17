Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab1FQSlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:41:25 -0400
Received: from outcampmail001.snc4.facebook.com ([66.220.144.159]:65423 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353Ab1FQSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:41:24 -0400
Message-ID: <4DFBA001.4010500@fb.com>
Date: Fri, 17 Jun 2011 11:42:09 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
References: <20110615163115.773d072e.akpm@linux-foundation.org> <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com> <4DFB8AAF.1040002@fb.com> <BANLkTindmEA7NsaRjuukh1-oRCtVWpeuCA@mail.gmail.com> <4DFB93C1.9000901@fb.com> <BANLkTim5zEo=Rn2sqUExL-8n=p4inLEpuQ@mail.gmail.com>
In-Reply-To: <BANLkTim5zEo=Rn2sqUExL-8n=p4inLEpuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/11 11:06 AM, Mike Frysinger wrote:

> fixes one thing while breaking another.  linux/atomic.h includes
> asm/atomic.h which includes asm-generic/atomic.h which includes
> asm-generic/atomic-long.h which needs atomic_add_unless(), but that
> isnt provided until after the asm/atomic.h include in linux/atomic.h.
>
> but linux/atomic.h needs asm/atomic.h before atomic_add_unless()
> because it relies on the new __atomic_add_unless().
>

Right. I think we need to get rid of that include as well:

--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -156,7 +145,5 @@ static inline void atomic_clear_mask(unsigned long 
mask, unsigned long *addr)
  #define smp_mb__before_atomic_inc()    barrier()
  #define smp_mb__after_atomic_inc()     barrier()

-#include <asm-generic/atomic-long.h>
-
  #endif /* __KERNEL__ */
  #endif /* __ASM_GENERIC_ATOMIC_H */

since <linux/atomic.h> includes it directly now.

> having linux/atomic.h and asm-generic/atomic.h just strikes me as
> wrong.  the point of asm-generic is to unify things, but now we have
> two places to unify things without 0 indication as to which is for
> which ?  i'm wondering if we shouldnt convert all arches to
> asm-generic/atomic.h and then add your new logic there and just skip
> this whole linux/atomic.h mess.

I believe the logic is:

<asm-generic/atomic.h> shared code for simple archs that don't want to 
define their own primitives. Only used by 4 archs.

<linux/atomic.h> a header file that's usable in machine independent 
kernel code.

<linux/atomic.h> seems to be relatively recent, introduced by:

commit 3f9d35b9514da6757ca98831372518f9eeb71b33
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu Nov 11 14:05:08 2010 -0800

     atomic: add atomic_inc_not_zero_hint()

<asm-generic/atomic.h> came from:

commit d3cb487149bd706aa6aeb02042332a450978dc1c
Author: Christoph Lameter <clameter@engr.sgi.com>
Date:   Fri Jan 6 00:11:20 2006 -0800

     [PATCH] atomic_long_t & include/asm-generic/atomic.h V2

My guess is that if <linux/atomic.h> existed in 2006, people would've 
added shared code over there. Also, the code in <asm-generic/atomic.h> 
is not truly generic:

smp_mb__before_atomic_dec() for eg is implemented differently for some 
archs.

  -Arun
