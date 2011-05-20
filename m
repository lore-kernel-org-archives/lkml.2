Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab1ETBPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:15:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37980 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933379Ab1ETBPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:15:21 -0400
Date: Fri, 20 May 2011 11:15:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure in Linus' tree
Message-Id: <20110520111516.784c0c9c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With just Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
failed like this:

In file included from arch/powerpc/mm/fault.c:18:
include/linux/signal.h:239: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:239: error: its scope is only this definition or declaration, which is probably not what you want
include/linux/signal.h:240: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:241: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:250: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:254: error: 'struct task_struct' declared inside parameter list
cc1: warnings being treated as errors

and so on ...

reverting commit e66eed651fd1 ("list: remove prefetching from regular
list iterators").  This is, of course, why we like to put stuff into
linux-next before it goes into your tree :-)

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 11:11:53 +1000
Subject: [PATCH] signal.h need a definition of struct task_struct

fixes these build errors on powerpc:

In file included from arch/powerpc/mm/fault.c:18:
include/linux/signal.h:239: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:239: error: its scope is only this definition or declaration, which is probably not what you want
include/linux/signal.h:240: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:241: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:250: error: 'struct task_struct' declared inside parameter list
include/linux/signal.h:254: error: 'struct task_struct' declared inside parameter list
cc1: warnings being treated as errors

Exposed by commit e66eed651fd1 ("list: remove prefetching from regular
list iterators").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/signal.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index fcd2b14..29a68ac 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -7,6 +7,8 @@
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+struct task_struct;
+
 /* for sysctl */
 extern int print_fatal_signals;
 /*
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
