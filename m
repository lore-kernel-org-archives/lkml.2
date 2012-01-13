Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2AMME6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:04:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2AMME5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <1326396898-5579-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1326396898-5579-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 13 Jan 2012 20:04:56 +0800
Message-ID: <CAJd=RBB6azf9nin5tjqTtHakxy896rCxr6ErK4p2KDrke_goEA@mail.gmail.com>
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 3:34 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> Currently when we check if we can handle thp as it is or we need to
> split it into regular sized pages, we hold page table lock prior to
> check whether a given pmd is mapping thp or not. Because of this,
> when it's not "huge pmd" we suffer from unnecessary lock/unlock overhead.
> To remove it, this patch introduces a optimized check function and
> replace several similar logics with it.
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: David Rientjes <rientjes@google.com>
>
> Changes since v2:
>  - Fix missing "return 0" in "thp under splitting" path
>  - Remove unneeded comment
>  - Change the name of check function to describe what it does
>  - Add VM_BUG_ON(mmap_sem)
> ---
>  fs/proc/task_mmu.c      |   73 +++++++++------------------
>  include/linux/huge_mm.h |    7 +++
>  mm/huge_memory.c        |  127 +++++++++++++++++++++++------------------------
>  mm/mremap.c             |    3 +-
>  4 files changed, 95 insertions(+), 115 deletions(-)
>
[...]
> +/*
> + * Returns 1 if a given pmd is mapping a thp and stable (not under splitting.)
> + * Returns 0 otherwise. Note that if it returns 1, this routine returns without
> + * unlocking page table locks. So callers must unlock them.
> + */
> +int pmd_trans_huge_stable(pmd_t *pmd, struct vm_area_struct *vma)
> +{
> +       VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
> +
> +       if (!pmd_trans_huge(*pmd))
> +               return 0;
> +
> +       spin_lock(&vma->vm_mm->page_table_lock);
> +       if (likely(pmd_trans_huge(*pmd))) {
> +               if (pmd_trans_splitting(*pmd)) {
> +                       spin_unlock(&vma->vm_mm->page_table_lock);
> +                       wait_split_huge_page(vma->anon_vma, pmd);
> +                       return 0;
> +               } else {

                            spin_unlock(&vma->vm_mm->page_table_lock);     yes?

> +                       /* Thp mapped by 'pmd' is stable, so we can
> +                        * handle it as it is. */
> +                       return 1;
> +               }
> +       }
> +       spin_unlock(&vma->vm_mm->page_table_lock);
> +       return 0;
> +}
> +
