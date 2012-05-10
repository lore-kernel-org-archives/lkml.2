Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2EJCYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:24:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:5705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2EJCYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98349583"
Message-ID: <4FAB26A1.3080605@intel.com>
Date: Thu, 10 May 2012 10:23:29 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: clean up TLB_FLUSH_ALL definition?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


why we need the different definition for TLB_FLUSH_ALL in 32 or 64 bits mode in commit d291cf83639? 


 #ifdef CONFIG_X86_32
-# include "tlbflush_32.h"
+# define TLB_FLUSH_ALL 0xffffffff
 #else
-# include "tlbflush_64.h"
+# define TLB_FLUSH_ALL -1ULL
+#endif

If it's possible to unify it as following?

#define TLB_FLUSH_ALL -1UL 

-----------------

>From 928db8019f7f66470a6a6188f870ec9a6f108a8c Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 10 May 2012 18:01:59 +0800
Subject: [PATCH] x86/tlb: clean up and unify TLB_FLUSH_ALL definition

Since sizeof(long) is 4 in x86_32 mode, and it's 8 in x86_64 mode,
sizeof(long long) is also 8 byte in x86_64 mode.
use long mode can fit TLB_FLUSH_ALL defination here both in 32 or
64 bits mode.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c0e108e..7e8a096 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,11 +62,7 @@ static inline void __flush_tlb_one(unsigned long addr)
 		__flush_tlb();
 }
 
-#ifdef CONFIG_X86_32
-# define TLB_FLUSH_ALL	0xffffffff
-#else
-# define TLB_FLUSH_ALL	-1ULL
-#endif
+#define TLB_FLUSH_ALL	-1UL
 
 /*
  * TLB flushing:
-- 
1.7.0.1

