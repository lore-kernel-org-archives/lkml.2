Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2A1LXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 06:23:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60163 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2A1LXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 06:23:49 -0500
MIME-Version: 1.0
In-Reply-To: <1327705373-29395-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1327705373-29395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1327705373-29395-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Sat, 28 Jan 2012 19:23:47 +0800
Message-ID: <CAJd=RBCGeqqAMvNAF3wPKAVQCFO-hNk1c+7UwKod6tMWqQ1Gkw@mail.gmail.com>
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naoya

On Sat, Jan 28, 2012 at 7:02 AM, Naoya Horiguchi
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
> Changes since v3:
>  - Fix likely/unlikely pattern in pmd_trans_huge_stable()
>  - Change suffix from _stable to _lock
>  - Introduce __pmd_trans_huge_lock() to avoid micro-regression
>  - Return 1 when wait_split_huge_page path is taken
>
> Changes since v2:
>  - Fix missing "return 0" in "thp under splitting" path
>  - Remove unneeded comment
>  - Change the name of check function to describe what it does
>  - Add VM_BUG_ON(mmap_sem)
> ---
>  fs/proc/task_mmu.c      |   70 +++++++++------------------
>  include/linux/huge_mm.h |   17 +++++++
>  mm/huge_memory.c        |  120 ++++++++++++++++++++++-------------------------
>  3 files changed, 96 insertions(+), 111 deletions(-)
>
[...]

> @@ -1064,21 +1056,14 @@ int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  {
>        int ret = 0;
>
> -       spin_lock(&vma->vm_mm->page_table_lock);
> -       if (likely(pmd_trans_huge(*pmd))) {
> -               ret = !pmd_trans_splitting(*pmd);

Here the value of ret is either false or true,

> -               spin_unlock(&vma->vm_mm->page_table_lock);
> -               if (unlikely(!ret))
> -                       wait_split_huge_page(vma->anon_vma, pmd);
> -               else {
> -                       /*
> -                        * All logical pages in the range are present
> -                        * if backed by a huge page.
> -                        */
> -                       memset(vec, 1, (end - addr) >> PAGE_SHIFT);
> -               }
> -       } else
> +       if (__pmd_trans_huge_lock(pmd, vma) == 1) {
> +               /*
> +                * All logical pages in the range are present
> +                * if backed by a huge page.
> +                */
>                spin_unlock(&vma->vm_mm->page_table_lock);
> +               memset(vec, 1, (end - addr) >> PAGE_SHIFT);
> +       }
>
>        return ret;

what is the returned value of this function? /Hillf

>  }
> @@ -1108,20 +1093,10 @@ int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
>                goto out;
>        }
