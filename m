Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2JRPCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:02:17 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56334 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2JRPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:02:15 -0400
Date: Thu, 18 Oct 2012 17:02:09 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-ID: <20121018150209.GB17439@linux-mips.org>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 05:22:01PM +1100, Stephen Rothwell wrote:

> Caused by commit 35d3d3427314 ("s390/thp: select
> HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> from the tip tree.
> 
> N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> and so will be broken in some configs now as well.

The other issue I'm running into is:

  CC      mm/huge_memory.o
mm/huge_memory.c: In function ‘do_huge_pmd_prot_none’:
mm/huge_memory.c:789:3: error: incompatible type for argument 3 of ‘update_mmu_cache’
In file included from include/linux/mm.h:44:0,
                 from mm/huge_memory.c:8:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/pgtable.h:375:91: note: expected ‘struct pte_t *’ but argument is of type ‘pmd_t’
mm/huge_memory.c: In function ‘__split_huge_page_map’:
mm/huge_memory.c:1424:2: error: implicit declaration of function ‘pmd_pgprot’ [-Werror=implicit-function-declaration]
mm/huge_memory.c:1424:7: error: incompatible types when assigning to type ‘pgprot_t’ from type ‘int’
cc1: some warnings being treated as errors
make[1]: *** [mm/huge_memory.o] Error 1

which is caused by:

commit a573b4dfcf58f86235d586ea1f82ed54b2b7e620
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Jul 17 18:25:14 2012 +0200

    mm/mpol: Create special PROT_NONE infrastructure

is adding a update_mmu_cache() call with incorrect arguments to
do_huge_pmd_prot_none().  This only shows up where update_mmu_cache()
is implemented as a C function; the usual macro implementation is eating
everything and the kitchensink as arguments.

  Ralf
