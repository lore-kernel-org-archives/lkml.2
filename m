Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2CUW61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab2CUW6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:58:24 -0400
Date: Wed, 21 Mar 2012 23:58:13 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v4 2/3] thp: add HPAGE_PMD_* definitions for
 !CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20120321225813.GM24602@redhat.com>
References: <1331591456-20769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1331591456-20769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <CAP=VYLoGSckJH+2GytZN0V0P3Uuv-PiVneKbFsVb5kQa3kcTCQ@mail.gmail.com>
 <20120321154721.3b8884bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321154721.3b8884bd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 21, 2012 at 03:47:21PM -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2012 18:07:41 -0400
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
> > On Mon, Mar 12, 2012 at 6:30 PM, Naoya Horiguchi
> > <n-horiguchi@ah.jp.nec.com> wrote:
> > > These macros will be used in later patch, where all usage are expected
> > > to be optimized away without #ifdef CONFIG_TRANSPARENT_HUGEPAGE.
> > > But to detect unexpected usages, we convert existing BUG() to BUILD_BUG().
> > 
> > Just a heads up that this showed up in linux-next today as the
> > cause of a new build failure for an ARM board:
> > 
> > http://kisskb.ellerman.id.au/kisskb/buildresult/5930053/
> 
> The internet started working again.
> 
> mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
> mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared with attribute error: BUILD_BUG failed
> 
> I guess we shouldn't be evaluating HPAGE_PMD_MASK at all if
> !CONFIG_TRANSPARENT_HUGEPAGE, so...

Yes. Either that or define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH without
actually implementing the function to flush it away of the .text (is
it perhaps flushed away at vmlinux link time?). That
function never could be called by ARM. The BUG() is actually correct
even in the original position, just now it triggers at build time
because it doesn't know it can't be called.

> 
> --- a/mm/pgtable-generic.c~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix
> +++ a/mm/pgtable-generic.c
> @@ -70,10 +70,11 @@ int pmdp_clear_flush_young(struct vm_are
>  			   unsigned long address, pmd_t *pmdp)
>  {
>  	int young;
> -#ifndef CONFIG_TRANSPARENT_HUGEPAGE
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +#else
>  	BUG();
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>  	young = pmdp_test_and_clear_young(vma, address, pmdp);
>  	if (young)
>  		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
> _
> 
