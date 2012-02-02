Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2BBIeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:34:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46023 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2BBIeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:34:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Feb 2012 17:32:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
Message-Id: <20120202173235.066b16b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328160478-28346-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20120130152212.3a6a2039.kamezawa.hiroyu@jp.fujitsu.com>
	<1328160478-28346-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Feb 2012 00:27:58 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Mon, Jan 30, 2012 at 03:22:12PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Fri, 27 Jan 2012 18:02:49 -0500
> > Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> >
> > > Currently when we check if we can handle thp as it is or we need to
> > > split it into regular sized pages, we hold page table lock prior to
> > > check whether a given pmd is mapping thp or not. Because of this,
> > > when it's not "huge pmd" we suffer from unnecessary lock/unlock overhead.
> > > To remove it, this patch introduces a optimized check function and
> > > replace several similar logics with it.
> > >
> > > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > Cc: David Rientjes <rientjes@google.com>
> > >
> > > Changes since v3:
> > >   - Fix likely/unlikely pattern in pmd_trans_huge_stable()
> > >   - Change suffix from _stable to _lock
> > >   - Introduce __pmd_trans_huge_lock() to avoid micro-regression
> > >   - Return 1 when wait_split_huge_page path is taken
> > >
> > > Changes since v2:
> > >   - Fix missing "return 0" in "thp under splitting" path
> > >   - Remove unneeded comment
> > >   - Change the name of check function to describe what it does
> > >   - Add VM_BUG_ON(mmap_sem)
> >
> >
> > > +/*
> > > + * Returns 1 if a given pmd maps a stable (not under splitting) thp,
> > > + * -1 if the pmd maps thp under splitting, 0 if the pmd does not map thp.
> > > + *
> > > + * Note that if it returns 1, this routine returns without unlocking page
> > > + * table locks. So callers must unlock them.
> > > + */
> >
> >
> > Seems nice clean up but... why you need to return (-1, 0, 1) ?
> >
> > It seems the caller can't see the difference between -1 and 0.
> >
> > Why not just return 0 (not locked) or 1 (thp found and locked) ?
> 
> Sorry, I changed wrongly from v3.
> We can do fine without return value of -1 if we remove else-if (!err)
> {...} block after move_huge_pmd() call in move_page_tables(), right?
> (split_huge_page_pmd() after wait_split_huge_page() do nothing...)
> 

Hm ?

               if (pmd_trans_huge(*old_pmd)) {
                        int err = 0;
                        if (extent == HPAGE_PMD_SIZE)
                                err = move_huge_pmd(vma, new_vma, old_addr,
                                                    new_addr, old_end,
                                                    old_pmd, new_pmd);
                        if (err > 0) {
                                need_flush = true;
                                continue;
                        } else if (!err) {
                                split_huge_page_pmd(vma->vm_mm, old_pmd);
                        }
                        VM_BUG_ON(pmd_trans_huge(*old_pmd));
                }

I think you're right. BUG_ON() in wait_split_huge_page() 

 #define wait_split_huge_page(__anon_vma, __pmd)                         \
        do {                                                            \
                pmd_t *____pmd = (__pmd);                               \
                anon_vma_lock(__anon_vma);                              \
                anon_vma_unlock(__anon_vma);                            \
                BUG_ON(pmd_trans_splitting(*____pmd) ||                 \
                       pmd_trans_huge(*____pmd));                       \
        } while (0)

says pmd is always splitted.

Thanks,
-Kame





