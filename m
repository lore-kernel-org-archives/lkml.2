Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab0FIWnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:43:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:47840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0FIWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,394,1272870000"; 
   d="scan'208";a="287078596"
Message-ID: <4C1018FD.8090109@linux.intel.com>
Date: Wed, 09 Jun 2010 15:43:09 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, bharrosh@panasas.com, bp@alien8.de,
       geert@linux-m68k.org, akpm@linux-foundation.org, toralf.foerster@gmx.de,
       tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, hweight: Fix UML boot crash
References: <201005271944.09541.toralf.foerster@gmx.de>	<20100530170346.GC1565@liondog.tnic> <tip-cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0@git.kernel.org>
In-Reply-To: <tip-cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: I have applied this  because it fixes a regression, but it bugs
the living bejeezus out of me that the saner patch:

diff --git a/arch/um/include/asm/arch_hweight.h
b/arch/um/include/asm/arch_hweight.h
new file mode 100644
index 0000000..c656cf4
--- /dev/null
+++ b/arch/um/include/asm/arch_hweight.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_UM_HWEIGHT_H
+#define _ASM_UM_HWEIGHT_H
+
+#include <asm-generic/bitops/arch_hweight.h>
+
+#endif

... supposedly didn't work.  As such, I consider this a temporary kluge
until a proper solution is found.  From a code-cleanliness perspective,
this patch is awful.

	-hpa


On 06/09/2010 03:07 PM, tip-bot for Borislav Petkov wrote:
> Commit-ID:  cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0
> Gitweb:     http://git.kernel.org/tip/cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0
> Author:     Borislav Petkov <bp@alien8.de>
> AuthorDate: Sun, 30 May 2010 19:03:46 +0200
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 9 Jun 2010 14:23:29 -0700
> 
> x86, hweight: Fix UML boot crash
> 
> UML apparently cannot stomach callee reg-saving trickery introduced
> with d61931d89be506372d01a90d1755f6d0a9fafe2d (x86: Add optimized
> popcnt variants) for reasons currently unknown, and oopses during
> boot: http://marc.info/?l=linux-kernel&m=127522065202435&w=2
> 
> Go ahead and fall back to the software hweight* routines on UML.
> 
> LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
> Tested-by: Toralf Förster <toralf.foerster@gmx.de>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> LKML-Reference: <20100530170346.GC1565@liondog.tnic>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Andrew Morgon <akpm@linux-foundation.org>
> ---
>  arch/x86/include/asm/bitops.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 545776e..c9dad12 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -444,7 +444,11 @@ static inline int fls(int x)
>  
>  #define ARCH_HAS_FAST_MULTIPLIER 1
>  
> +#ifdef CONFIG_UML
> +#include <asm-generic/bitops/arch_hweight.h>
> +#else
>  #include <asm/arch_hweight.h>
> +#endif
>  
>  #include <asm-generic/bitops/const_hweight.h>
>  

