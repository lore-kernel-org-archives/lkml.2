Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1AOE2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 23:28:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1AOE2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 23:28:03 -0500
Date: Sat, 15 Jan 2011 05:27:53 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20110115042753.GS9506@random.random>
References: <20110115131027.2c07ccb0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115131027.2c07ccb0.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 15, 2011 at 01:10:27PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:
> 
> In file included from arch/sparc/include/asm/pgtable_32.h:455,
>                  from arch/sparc/include/asm/pgtable.h:6,
>                  from include/linux/mm.h:41,
>                  from arch/sparc/kernel/process_32.c:17:
> include/asm-generic/pgtable.h: In function 'pmdp_get_and_clear':
> include/asm-generic/pgtable.h:96: error: implicit declaration of function '__pmd'
> include/asm-generic/pgtable.h:96: error: incompatible types when returning type 'int' but 'pmd_t' was expected
> 
> and *lots* more.
> 
> Caused by commit e2cda322648122dc400c85ada80eaddbc612ef6a ("thp: add pmd
> mangling generic functions").  This has already been reported broken in
> other architectures as well.
> 
> I have just left it for today.

See arch/sparc/include/asm/page_32.h

/* #define __pmd(x)        ((pmd_t) { (x) } ) */ /* XXX procedure with loop */
/* #define __pmd(x)        (x) */ /* XXX later */


Not sure why __pmd is commented out on sparc32 (it isn't in sparc64,
this is why sparc looked like building ok in a earlier report).

Removing those two comments at first glance should fix the build, but
I don't understand the comment, so I'm unsure if it's safe and what
"XXX later" means. Overall this __pmd(0) thing is just a fake.  We've
to return some dummy pmd_t structure to build, because the function
returns a pmd_t, there's a BUG() before __pmd is evaluated, but I
didn't think of a better way yet than to return __pmd(0).

static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
       	      	    			             unsigned long
       	      	    			             address,
						     pmd_t *pmdp)
{
	BUG();
	return __pmd(0);
}
