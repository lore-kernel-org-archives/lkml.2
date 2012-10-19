Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2JSVs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:48:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49435 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab2JSVs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:48:56 -0400
Date: Fri, 19 Oct 2012 23:48:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-ID: <20121019214850.GB9630@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
 <20121018145101.GA17439@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018145101.GA17439@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ralf Baechle <ralf@linux-mips.org> wrote:

> On Thu, Oct 18, 2012 at 05:22:01PM +1100, Stephen Rothwell wrote:
> 
> > After merging the final tree, today's linux-next build (s390 allyesconfig)
> > failed like this:
> > 
> > mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_pgprot' [-Werror=implicit-function-declaration]
> > mm/huge_memory.c:1424:7: error: incompatible types when assigning to type 'pgprot_t' from type 'int'
> > 
> > (see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)
> > 
> > Caused by commit 35d3d3427314 ("s390/thp: select
> > HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> > commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> > from the tip tree.
> > 
> > N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> > e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> > and so will be broken in some configs now as well.
> > 
> > Anyone have suggested merge fix patches I can apply?
> 
> See below.  There's further MIPS breakage in -next; more on than in a
> separate email.
> 
>   Ralf
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Thanks Ralf! I've applied it, with a changelog and a 
Reported-by: Stephen Rothwell line - see the commit below.

Note that I moved the definition slightly up, so that regardless 
of the order merging the commits don't create a conflict in 
linux-next. If that fine with you I'll push it out that way.

(Looking at the other MIPS problem as well.)

Thanks,

	Ingo


---------------->
>From 8cd7680d8b7241941fd51d83302677d58b447223 Mon Sep 17 00:00:00 2001
From: Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 18 Oct 2012 16:51:01 +0200
Subject: [PATCH] MIPS/thp: Add pmd_pgprot() implementation

Resolve the semantic conflict between the new THP code
on MIPS and the new NUMA code, in linux-next, by adding
the pmd_pgprot() method needed by the NUMA code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20121018145101.GA17439@linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index c02158b..bbe4cda 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -89,6 +89,8 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 extern void paging_init(void);
 
+#define pmd_pgprot(x)		__pgprot(pmd_val(x) & ~_PAGE_CHG_MASK)
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
