Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2AMPUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:43 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47091 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab2AMPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:39 -0500
Message-ID: <4F104A51.2000701@ah.jp.nec.com>
Date: Fri, 13 Jan 2012 10:14:25 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>	<1326396898-5579-3-git-send-email-n-horiguchi@ah.jp.nec.com> <CAJd=RBB6azf9nin5tjqTtHakxy896rCxr6ErK4p2KDrke_goEA@mail.gmail.com>
In-Reply-To: <CAJd=RBB6azf9nin5tjqTtHakxy896rCxr6ErK4p2KDrke_goEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

(1/13/2012 7:04), Hillf Danton wrote:
[...]
>> +/*
>> + * Returns 1 if a given pmd is mapping a thp and stable (not under splitting.)
>> + * Returns 0 otherwise. Note that if it returns 1, this routine returns without
>> + * unlocking page table locks. So callers must unlock them.
>> + */
>> +int pmd_trans_huge_stable(pmd_t *pmd, struct vm_area_struct *vma)
>> +{
>> +       VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
>> +
>> +       if (!pmd_trans_huge(*pmd))
>> +               return 0;
>> +
>> +       spin_lock(&vma->vm_mm->page_table_lock);
>> +       if (likely(pmd_trans_huge(*pmd))) {
>> +               if (pmd_trans_splitting(*pmd)) {
>> +                       spin_unlock(&vma->vm_mm->page_table_lock);
>> +                       wait_split_huge_page(vma->anon_vma, pmd);
>> +                       return 0;
>> +               } else {
> 
>                             spin_unlock(&vma->vm_mm->page_table_lock);     yes?

No. Unlocking is supposed to be done by the caller as commented.

Thanks,
Naoya

> 
>> +                       /* Thp mapped by 'pmd' is stable, so we can
>> +                        * handle it as it is. */
>> +                       return 1;
>> +               }
>> +       }
>> +       spin_unlock(&vma->vm_mm->page_table_lock);
>> +       return 0;
>> +}
>> +

