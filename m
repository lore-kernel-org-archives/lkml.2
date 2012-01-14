Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2ANDYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 22:24:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62007 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2ANDYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 22:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F104A51.2000701@ah.jp.nec.com>
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1326396898-5579-3-git-send-email-n-horiguchi@ah.jp.nec.com>
	<CAJd=RBB6azf9nin5tjqTtHakxy896rCxr6ErK4p2KDrke_goEA@mail.gmail.com>
	<4F104A51.2000701@ah.jp.nec.com>
Date: Sat, 14 Jan 2012 11:24:06 +0800
Message-ID: <CAJd=RBB2GMRQNUH+2z7R5Fy6OKKtid9wn2mTFORvtefo+wUaOQ@mail.gmail.com>
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

On Fri, Jan 13, 2012 at 11:14 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> Hi Hillf,
>
> (1/13/2012 7:04), Hillf Danton wrote:
> [...]
>>> +/*
>>> + * Returns 1 if a given pmd is mapping a thp and stable (not under splitting.)
>>> + * Returns 0 otherwise. Note that if it returns 1, this routine returns without
>>> + * unlocking page table locks. So callers must unlock them.
>>> + */
>>> +int pmd_trans_huge_stable(pmd_t *pmd, struct vm_area_struct *vma)
>>> +{
>>> +       VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
>>> +
>>> +       if (!pmd_trans_huge(*pmd))
>>> +               return 0;
>>> +
>>> +       spin_lock(&vma->vm_mm->page_table_lock);
>>> +       if (likely(pmd_trans_huge(*pmd))) {
>>> +               if (pmd_trans_splitting(*pmd)) {
>>> +                       spin_unlock(&vma->vm_mm->page_table_lock);
>>> +                       wait_split_huge_page(vma->anon_vma, pmd);
>>> +                       return 0;
>>> +               } else {
>>
>>                             spin_unlock(&vma->vm_mm->page_table_lock);     yes?
>
> No. Unlocking is supposed to be done by the caller as commented.
>
Thanks for correcting /Hillf
