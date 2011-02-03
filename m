Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1BCU7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:59:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BCU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:59:41 -0500
Message-ID: <4D4B1721.9010100@redhat.com>
Date: Thu, 03 Feb 2011 15:59:13 -0500
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
References: <4CB76E8B.2090309@goop.org> <4CC0AB73.8060609@goop.org> <20110203024838.GI5843@random.random>
In-Reply-To: <20110203024838.GI5843@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 09:48 PM, Andrea Arcangeli wrote:
> Hello,
>
> Larry (CC'ed) found a problem with the patch in subject. When
> USE_SPLIT_PTLOCKS is not defined (NR_CPUS == 2) it will deadlock in
> ptep_clear_flush_notify in rmap.c because it's sending IPIs with the
> page_table_lock already held, and the other CPUs now spins on the
> page_table_lock with irq disabled, so the IPI never runs. With
> CONFIG_TRANSPARENT_HUGEPAGE=y this deadlocks happens even with
> USE_SPLIT_PTLOCKS defined so it become visible but it needs to be
> fixed regardless (for NR_CPUS == 2).
>
> I'd like to understand why the pgd_lock needs irq disabled, it sounds
> too easy that I can just remove the _irqsave, doesn't it?
>
> A pgd_free comment says it can run from irq. page_table_lock having to
> be taken there is for Xen only, but other archs also uses
> spin_lock_irqsave(pgd_lock) so I guess it's either common code, or
> it's superfluous and not another Xen special requirement.
>
> If we could remove that _irqsave like below it'd solve it... But
> clearly something must be taking the pgd_lock from irq. (using a
> rwlock would also be possible as long as nobody takes it in write mode
> during irq, but if it's pgd_free that really runs in irq, that would
> need the write_lock so it wouldn't be a solution).
>
> I'm trying this fix and the VM_BUG_ON never triggered yet.
>
> In short: who takes the pgd_lock from an irq? (__mmdrop shouldn't but
> maybe I'm overlooking some aio bit?)
>
>
This is the specifics:

The problem is with THP.  The page reclaim code calls page_referenced_one()
which takes the mm->page_table_lock on one CPU before sending an IPI to other
CPU(s):

On CPU1 we take the mm->page_table_lock, send IPIs and wait for a response:
page_referenced_one(...)
         if (unlikely(PageTransHuge(page))) {
                 pmd_t *pmd;

                 spin_lock(&mm->page_table_lock);
                 pmd = page_check_address_pmd(page, mm, address,
                                              PAGE_CHECK_ADDRESS_PMD_FLAG);
                 if (pmd&&  !pmd_trans_splitting(*pmd)&&
                     pmdp_clear_flush_young_notify(vma, address, pmd))
                         referenced++;
                 spin_unlock(&mm->page_table_lock);
         } else {


CPU2 can race in vmalloc_sync_all() because it disables interrupt(preventing a
response to the IPI from CPU1) and takes the pgd_lock then spins in the
mm->page_table_lock which is already held on CPU1.

                 spin_lock_irqsave(&pgd_lock, flags);
                 list_for_each_entry(page,&pgd_list, lru) {
                         pgd_t *pgd;
                         spinlock_t *pgt_lock;

                         pgd = (pgd_t *)page_address(page) + pgd_index(address);

                         pgt_lock =&pgd_page_get_mm(page)->page_table_lock;
                         spin_lock(pgt_lock);


At this point the system is deadlocked.  The pmdp_clear_flush_young_notify
needs to do its PDG business with the page_table_lock held then release that
lock before sending the IPIs to the other CPUs.


