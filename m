Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1ETGMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:12:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1ETGMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:12:20 -0400
Date: Fri, 20 May 2011 16:12:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

In file included from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/spinlock.h: In function 'spin_unlock_wait':
include/linux/spinlock.h:360: error: implicit declaration of function 'cpu_relax'

Probably the victim of some include changing ... I think it was due to
commit e66eed651fd1 ("list: remove prefetching from regular list
iterators").

I added the following patch for today (this may not be the best solution):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 15:48:17 +1000
Subject: [PATCH] spinlock_up.h: include asm/processor.h in for cpu_relax

Commit e66eed651fd1 ("list: remove prefetching from regular list
iterators") removed the include of prefetch.h from list.h and this was
a path to including asm/processor.h.  We need to include it excplicitly
now.

Fixes this build error on sparc32 (at least):

In file included from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/spinlock.h: In function 'spin_unlock_wait':
include/linux/spinlock.h:360: error: implicit declaration of function 'cpu_relax

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/spinlock_up.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index b14f6a9..a26e2fb 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -5,6 +5,8 @@
 # error "please don't include this file directly"
 #endif
 
+#include <asm/processor.h>	/* for cpu_relax() */
+
 /*
  * include/linux/spinlock_up.h - UP-debug version of spinlocks.
  *
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
